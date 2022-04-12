extends Node


# Instance variables
var network: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var ip: String = "127.0.0.1"
var port: int = 42069


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connectToServer()


func connectToServer() -> void:
	self.network.create_client(self.ip, self.port)
	self.get_tree().set_network_peer(self.network)
	print("Created client...")
	
	self.network.connect("connection_failed", self, "_on_connection_failed")
	self.network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
	
func _on_connection_failed() -> void:
	print("Failed to connect.")

	
func _on_connection_succeeded() -> void:
	print("Connection established.")
