extends Node


var fireball_scene = preload("res://projectiles/Fireball.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame
func _process(_delta: float) -> void:
	# Nothing to do if not enough states exist
	if Client.world_state_buffer.size() < 2:
		return
	
	# Get necessary data from Client
	var prev_projectile_state: Dictionary = Client.world_state_buffer[0]["projectiles"]
	var future_projectile_state: Dictionary = Client.world_state_buffer[1]["projectiles"]
	
	# Remove enemies that are missing
	for projectile in self.get_children():
		if not prev_projectile_state.has(projectile.name):
			self.remove_child(projectile)
			projectile.queue_free()
	
	# Update all enemies from server
	for projectile_name in future_projectile_state.keys():
		# Can't lerp if nonexistent previously
		if not prev_projectile_state.has(projectile_name):
			continue
		
		# Get enemy's node
		var projectile_node = self.get_node_or_null(str(projectile_name))
		# Enemy doesn't exist - spawn them in
		if projectile_node == null:
			projectile_node = self.fireball_scene.instance()
			projectile_node.name = str(projectile_name)
			self.add_child(projectile_node)
		# Lerp player position and rotation
		var pos: Vector2 = lerp(prev_projectile_state[projectile_name]["pos"], future_projectile_state[projectile_name]["pos"], Client.lerp_factor)
		var rot: float = lerp_angle(prev_projectile_state[projectile_name]["rot"], future_projectile_state[projectile_name]["rot"], Client.lerp_factor)
		projectile_node.global_position = pos
		projectile_node.rotation = rot
