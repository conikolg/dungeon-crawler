extends Node


# Instance variables
var peer: NetworkedMultiplayerENet
var port: int = 42069
var client


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
	pass


# Called every frame
func _process(_delta: float) -> void:
	if not self.custom_multiplayer:
		return
	if not self.custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll();


func startServer() -> void:
	self.peer = NetworkedMultiplayerENet.new()
	self.peer.create_server(port)
	self.multiplayer.set_network_peer(self.peer)
	print("Server has started...")
	
	var error: int = 0
	error += self.peer.connect("peer_connected", self, "_on_peer_connected")
	error += self.peer.connect("peer_disconnected", self, "_on_peer_disconnected")
	if error != OK:
		print("Error in server multiplayer signal connect.")


func _on_peer_connected(peer_id: int) -> void:
	print("Peer with id=%s connected." % peer_id)
	

func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer with id=%s disconnected." % peer_id)


remote func updatePlayerPosition(position, _requester) -> void:
	print("received: ", position)


remote func request_data():
	print("Got rpc from client")
	var clientID: int = self.multiplayer.get_rpc_sender_id()
	rpc_id(clientID, "response_data", "Hello World")
