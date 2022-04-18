extends Node2D


var remote_player_scene = preload("res://actors/RemotePlayer.tscn")

var player_state_buffer: Array = []
var render_time_offest: int = 50	# Render the world 50ms in the past


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame
func _process(_delta: float) -> void:
	# Skip rendering if no diff is available
	if self.player_state_buffer.size() < 2:
		return
	
	# Render the players at this timestamp
	var render_time: int = OS.get_system_time_msecs() - self.render_time_offest
	# Advance buffer so that only the first (oldest) state is in the past
	while self.player_state_buffer.size() > 2 and self.player_state_buffer[1]["time"] < render_time:
		self.player_state_buffer.remove(0)
	# Render in the right location
	var interpolation: float = float(render_time - self.player_state_buffer[0]["time"]) / float(self.player_state_buffer[1]["time"] - self.player_state_buffer[0]["time"])
	for peer_id in self.player_state_buffer[1].keys():
		if str(peer_id) == "time":
			continue	# Not actually a player
		if not self.player_state_buffer[0].has(peer_id):
			continue	# Can't lerp if nonexistent previously
		
		# Get player's node
		var player_node = self.get_node_or_null("Player%s" % peer_id)
		# Player doesn't exist - spawn them in
		if player_node == null:
			player_node = remote_player_scene.instance()
			player_node.name = "Player%s" % peer_id
			self.add_child(player_node)
		# Lerp player position and rotation
		var pos: Vector2 = lerp(self.player_state_buffer[0][peer_id]["pos"], self.player_state_buffer[1][peer_id]["pos"], interpolation)
		var rot: float = lerp_angle(self.player_state_buffer[0][peer_id]["rot"], self.player_state_buffer[1][peer_id]["rot"], interpolation)
		player_node.global_position = pos
		player_node.rotation = rot


func update_players(player_state: Dictionary) -> void:
	# Add the new state to the buffer
	self.player_state_buffer.append(player_state)
	
	# Delete players that do not exist in player_state
	for child in self.get_children():
		var child_peer_id: String = child.name.substr("Player".length())
		if !(child_peer_id in player_state.keys()):
			self.remove_child(self.get_node(child.get_path()))
			child.queue_free()
