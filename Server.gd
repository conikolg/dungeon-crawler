extends Node


# Instance variables
var network: NetworkedMultiplayerENet
var max_players: int = 100
var port: int = 42069
var client


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame
func _process(delta: float) -> void:
	if not self.custom_multiplayer:
		return
	if not self.custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll();


func startServer() -> void:
	self.custom_multiplayer = MultiplayerAPI.new();
	self.network = NetworkedMultiplayerENet.new();
	self.client = get_node("../Client");
	self.custom_multiplayer.set_root_node(self.client);
	
	self.network.create_server(self.port, self.max_players)
	self.custom_multiplayer.network_peer = self.network;
	print("Server has started...")
	
	self.network.connect("peer_connected", self, "_on_peer_connected")
	self.network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(peer_id: int) -> void:
	print("Peer with id=%s connected." % peer_id)
	

func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer with id=%s disconnected." % peer_id)
