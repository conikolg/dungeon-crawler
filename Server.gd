extends Node


# Instance variables
var network: NetworkedMultiplayerENet
var port: int = 42069
var max_players: int = 100
var client


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Server tree: ", self.get_tree())
	print("Server mp: ", self.multiplayer)


# Called every frame
func _process(_delta: float) -> void:
	if not self.custom_multiplayer:
		return
	if not self.custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll();


func startServer() -> void:
	self.custom_multiplayer = MultiplayerAPI.new()
	self.network = NetworkedMultiplayerENet.new()
	self.custom_multiplayer.root_node = self.get_node("/root/Client")
	
	self.network.create_server(self.port, self.max_players)
	self.custom_multiplayer.network_peer = self.network
	print("Server net peer: ", self.get_tree().network_peer)
	print("Server has started...")
	
	var error: int = 0
	error += self.network.connect("peer_connected", self, "_on_peer_connected")
	error += self.network.connect("peer_disconnected", self, "_on_peer_disconnected")
	if error != OK:
		print("Error in server multiplayer signal connect.")


func _on_peer_connected(peer_id: int) -> void:
	print("Peer with id=%s connected." % peer_id)
	

func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer with id=%s disconnected." % peer_id)


remote func updatePlayerPosition(position, _requester) -> void:
	print("received: ", position)


remotesync func request_data():
	print("Got rpc from client")
	var clientID: int = self.multiplayer.get_rpc_sender_id()
	rpc_id(clientID, "response_data", "Hello World")
