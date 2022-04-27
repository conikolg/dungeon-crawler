extends Node2D


var remote_player_scene = preload("res://actors/RemotePlayer.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame
func _process(_delta: float) -> void:
	# Nothing to do if not enough states exist
	if Client.world_state_buffer.size() < 2:
		return
	
	# Get necessary data from Client
	var prev_player_state: Dictionary = Client.world_state_buffer[0]["players"]
	var future_player_state: Dictionary = Client.world_state_buffer[1]["players"]
	
	# Delete players that do not exist anymore
	for child in self.get_children():
		var child_peer_id: String = child.name.substr("Player".length())
		if !(child_peer_id in prev_player_state.keys()):
			self.remove_child(self.get_node(child.get_path()))
			child.queue_free()
	
	# Update for all players
	for peer_id in future_player_state.keys():
		# Can't lerp if nonexistent previously
		if not prev_player_state.has(peer_id):
			continue
		
		# Get player's node
		var player_node = self.get_node_or_null("Player%s" % peer_id)
		# Player doesn't exist - spawn them in
		if player_node == null:
			player_node = remote_player_scene.instance()
			player_node.name = "Player%s" % peer_id
			self.add_child(player_node)
		# Lerp player position and rotation
		var pos: Vector2 = lerp(prev_player_state[peer_id]["pos"], future_player_state[peer_id]["pos"], Client.lerp_factor)
		var rot: float = lerp_angle(prev_player_state[peer_id]["rot"], future_player_state[peer_id]["rot"], Client.lerp_factor)
		player_node.global_position = pos
		player_node.rotation = rot
