extends Node


# Instance variables - client and server
var network: NetworkedMultiplayerENet
var port: int = 42069
var ip: String = "localhost"
var server


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func connectToServer() -> void:
	self.custom_multiplayer = MultiplayerAPI.new();
	self.network = NetworkedMultiplayerENet.new();
	self.server = get_node("../Server");
	self.custom_multiplayer.set_root_node(self.server);
	
	print("Connecting to '%s'..." % self.ip)
	self.network.create_client(self.ip, self.port)
	self.get_tree().set_network_peer(self.network)
	print("Created client.")
	
	self.network.connect("connection_failed", self, "_on_connection_failed")
	self.network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
	
func _on_connection_failed() -> void:
	print("Failed to connect.")

	
func _on_connection_succeeded() -> void:
	print("Connection established.")
