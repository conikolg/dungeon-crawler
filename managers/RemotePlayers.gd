extends Node2D


var remote_player_scene = preload("res://actors/RemotePlayer.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_players(player_states: Dictionary) -> void:
	# Delete players that do not exist in player_states
	for child in self.get_children():
		var child_peer_id: String = child.name.substr("Player".length())
		if !(child_peer_id in player_states.keys()):
			self.remove_child(self.get_node(child.get_path()))
			child.queue_free()
	
	# Set new global position and rotation for each remote player
	for peer_id in player_states:
		# Get remote player node
		var player_node = self.get_node_or_null("Player%s" % peer_id)
		# Create remote player if necessary
		if player_node == null:
			player_node = remote_player_scene.instance()
			player_node.name = "Player%s" % peer_id
			self.add_child(player_node)
		# Update global position
		var player_state: Dictionary = player_states[peer_id]
		player_node.global_position = player_state["pos"]
		player_node.rotation = player_state["rot"]
