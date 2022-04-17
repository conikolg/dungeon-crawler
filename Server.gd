extends Node


# Instance variables
var port: int = 42069
var allow_remote_players: bool = true
var peer: NetworkedMultiplayerENet
var client

var physics_tick_max: int = 2  # Run at 30 ticks/sec
var physics_tick_counter: int = physics_tick_max
var world_state: Dictionary


func _init() -> void:
	# Thank you https://github.com/LudiDorici/gd-custom-multiplayer
	# First, we assign a new MultiplayerAPI to our this node
	custom_multiplayer = MultiplayerAPI.new()
	# Then we need to specify that this will be the root node for this custom
	# MultlpayerAPI, so that all path references will be relative to this one
	# and only its children will be affected by RPCs/RSETs
	custom_multiplayer.set_root_node(self)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.world_state = {}
	self.world_state['players'] = {}


# Called every frame
func _process(_delta: float) -> void:
	if not self.custom_multiplayer:
		return
	if not self.custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll();
	

func _physics_process(_delta: float) -> void:
	self.physics_tick_counter -= 1
	if self.physics_tick_counter == 0:
		self.server_update()
		self.physics_tick_counter = self.physics_tick_max


################################
#			Signals
################################

func _on_peer_connected(peer_id: int) -> void:
	print("Peer with id=%s connected." % peer_id)
	

func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer with id=%s disconnected." % peer_id)
	
	# Delete this peer from the world's players state
	self.world_state["players"].erase(str(peer_id))


##########################################
#			Internal Functions
##########################################

func startServer() -> void:
	self.peer = NetworkedMultiplayerENet.new()
	if self.allow_remote_players:
		self.peer.set_bind_ip("*")
	else:
		self.peer.set_bind_ip("127.0.0.1")
	self.peer.create_server(port)
	self.multiplayer.set_network_peer(self.peer)
	print("Server has started...")
	
	var error: int = 0
	error += self.peer.connect("peer_connected", self, "_on_peer_connected")
	error += self.peer.connect("peer_disconnected", self, "_on_peer_disconnected")
	if error != OK:
		print("Error in server multiplayer signal connect.")


func server_update() -> void:
	if not self.peer:
		return
	if self.peer.get_connection_status() != NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		return
	
	# Deep copy the world state before changing it
	var state: Dictionary = self.strip_timestamps(self.world_state.duplicate(true))
	# Add the server's timestamp to the whole payload
	state["time"] = OS.get_system_time_msecs()
	# Send all players the locations of all players
	rpc_unreliable_id(0, "client_receive_world_state", state)


func strip_timestamps(state: Dictionary) -> Dictionary:
	# Recursively remove any "time" attributes from subcomponents
	if "time" in state.keys():
		state.erase("time")
	for key in state:
		if state[key] is Dictionary:
			self.strip_timestamps(state[key])
	
	return state


##################################################
#			Outgoing Network Functions
##################################################


##################################################
#			Incoming Network Functions
##################################################

remote func server_receive_player_pos(state: Dictionary) -> void:
	# Get who sent this update
	var client_id: int = self.multiplayer.get_rpc_sender_id()
	# Is it a brand new update?
	if !(str(client_id) in self.world_state['players'].keys()):
		self.world_state['players'][str(client_id)] = state
	# Otherwise, is it newer?
	elif state["time"] > self.world_state['players'][str(client_id)]["time"]:
		self.world_state['players'][str(client_id)] = state
	# Not new update - ignore it
	else:
		pass


remote func request_data():
	print("Got rpc from client")
	var client_id: int = self.multiplayer.get_rpc_sender_id()
	rpc_id(client_id, "response_data", "Hello World")
