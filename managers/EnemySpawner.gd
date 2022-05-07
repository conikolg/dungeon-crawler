extends Node


var remote_enemy_scene = preload("res://actors/RemoteEnemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame
func _process(_delta: float) -> void:
	# Nothing to do if not enough states exist
	if Client.world_state_buffer.size() < 2:
		return
	
	# Get necessary data from Client
	var prev_enemy_state: Dictionary = Client.world_state_buffer[0]["enemies"]
	var future_enemy_state: Dictionary = Client.world_state_buffer[1]["enemies"]
	
	# Remove enemies that are missing
	for enemy_node in self.get_children():
		if not prev_enemy_state.has(enemy_node.name):
			self.remove_child(enemy_node)
			enemy_node.queue_free()
	
	# Update all enemies from server
	for enemy_name in future_enemy_state.keys():
		# Can't lerp if nonexistent previously
		if not prev_enemy_state.has(enemy_name):
			continue
		
		# Get enemy's node
		var enemy_node = self.get_node_or_null(str(enemy_name))
		# Enemy doesn't exist - spawn them in
		if enemy_node == null:
			enemy_node = remote_enemy_scene.instance()
			enemy_node.name = str(enemy_name)
			self.add_child(enemy_node)
		# Lerp player position and rotation
		var pos: Vector2 = lerp(prev_enemy_state[enemy_name]["pos"], future_enemy_state[enemy_name]["pos"], Client.lerp_factor)
		var rot: float = lerp_angle(prev_enemy_state[enemy_name]["rot"], future_enemy_state[enemy_name]["rot"], Client.lerp_factor)
		enemy_node.global_position = pos
		enemy_node.rotation = rot
