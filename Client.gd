extends Node


# Instance variables
var peer: NetworkedMultiplayerENet
var port: int = 42069
var ip: String = "localhost"
var server

var last_server_update_time: int 	# Timestamp of latest update recieved from the server
var world_state_buffer: Array = []	# Buffer of world states, only i=1 in the past
var render_time_offest: int = 50	# Render the world 50ms in the past
var lerp_factor: float = 0			# Proportion of time between states at i=0 and i=1


func _init() -> void:
	# Thank you https://github.com/LudiDorici/gd-custom-multiplayer
	# First, we assign a new MultiplayerAPI to our this node
	custom_multiplayer = MultiplayerAPI.new()
	# Then we need to specify that this will be the root node for this custom
	# MultiplayerAPI, so that all path references will be relative to this one
	# and only its children will be affected by RPCs/RSETs
	custom_multiplayer.set_root_node(self)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.last_server_update_time = -1


# Called every frame
func _process(_delta: float) -> void:
	# Allow network signals to work
	if not self.custom_multiplayer:
		return
	if not self.custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll();
	
	# Update lerp factor between server updates
	if self.world_state_buffer.size() < 2:
		return
	# Render the players at this timestamp
	var render_time: int = OS.get_system_time_msecs() - self.render_time_offest
	# Advance buffer so that only the first (oldest) state is in the past
	while self.world_state_buffer.size() > 2 and self.world_state_buffer[1]["time"] < render_time:
		self.world_state_buffer.remove(0)
	# Render in the right location
	self.lerp_factor = float(render_time - self.world_state_buffer[0]["time"]) / float(self.world_state_buffer[1]["time"] - self.world_state_buffer[0]["time"])


func connectToServer() -> void:
	self.peer = NetworkedMultiplayerENet.new()
	self.peer.create_client(self.ip, self.port)
	self.multiplayer.set_network_peer(self.peer)
	print("Connecting to '%s'..." % self.ip)
	
	var error: int = 0
	error += self.peer.connect("connection_failed", self, "_on_connection_failed")
	error += self.peer.connect("connection_succeeded", self, "_on_connection_succeeded")
	if error != OK:
		print("Error in client multiplayer signal connect.")


func _on_connection_failed() -> void:
	print("Failed to connect.")


func _on_connection_succeeded() -> void:
	print("Connection established.")
	rpc_id(1, "request_data")


##################################################
#			Outgoing Network Functions
##################################################

func send_server_player_state(state: Dictionary) -> void:
	if self.peer.get_connection_status() != NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		return
	
	# Attach current timestamp (ms since epoch) to the payload
	state["time"] = OS.get_system_time_msecs()
	
	# Dispatch payload to server
	rpc_unreliable_id(1, "server_receive_player_pos", state)


func send_server_enemy_hit(enemy_name: String) -> void:
	rpc_id(1, "server_receive_enemy_hit", enemy_name)


##################################################
#			Incoming Network Functions
##################################################

remote func client_receive_world_state(world_state: Dictionary) -> void:
	# Ignore if this is the most updated world state so far
	if world_state["time"] <= self.last_server_update_time:
		return
	
	# Erase the local player from the dictionary
	var player_dict: Dictionary = world_state["players"]
	var my_id = self.multiplayer.get_network_unique_id()
	player_dict.erase(str(my_id))
	
	# Record as state of the world
	self.world_state_buffer.append(world_state)
	
	# Hand off the state of all players to the RemotePlayers node
	self.get_node("/root/Main/RemotePlayers").update_players(player_dict)


remote func response_data(text: String) -> void:
	print("got from server: ", text)
