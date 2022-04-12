extends Node


# Instance variables - client and server
var network: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()

# Instance variables - server
var max_players: int = 100
var port: int = 42069

# Instance variables - client
var ip: String = "127.0.0.1"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func connectToServer() -> void:
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


func startServer() -> void:
	self.network.create_server(self.port, self.max_players)
	self.get_tree().set_network_peer(self.network)
	print("Server has started...")
	
	self.network.connect("peer_connected", self, "_on_peer_connected")
	self.network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(peer_id: int) -> void:
	print("Peer with id=%s connected." % peer_id)
	

func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer with id=%s disconnected." % peer_id)
