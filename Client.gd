extends Node


# Instance variables
var network: NetworkedMultiplayerENet
var port: int = 42069
var ip: String = "localhost"
var server


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Client tree: ", self.get_tree())
	print("Client mp: ", self.multiplayer)


# Called every frame
func _process(_delta: float) -> void:
	if not self.custom_multiplayer:
		return
	if not self.custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll();


func connectToServer() -> void:
	self.custom_multiplayer = MultiplayerAPI.new()
	self.network = NetworkedMultiplayerENet.new()
	self.custom_multiplayer.root_node = self.get_node("/root/Server")
	
	self.network.create_client(self.ip, self.port)
	self.custom_multiplayer.network_peer = self.network
	print("Client net peer: ", self.get_tree().network_peer)
	print("Connecting to '%s'..." % self.ip)
	
	var error: int = 0
	error += self.network.connect("connection_failed", self, "_on_connection_failed")
	error += self.network.connect("connection_succeeded", self, "_on_connection_succeeded")
	if error != OK:
		print("Error in client multiplayer signal connect.")


func _on_connection_failed() -> void:
	print("Failed to connect.")

	
func _on_connection_succeeded() -> void:
	print("Connection established.")
	rpc_id(1, "request_data")


remote func response_data(text: String):
	print("got from server: ", text)


func sendPlayerPosition(position: Vector2) -> void:
	if self.network.get_connection_status() == 2:
		rpc_id(1, "updatePlayerPosition", position)
	else:
		print("Not connected")
