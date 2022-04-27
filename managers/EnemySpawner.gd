extends Node2D


# Instance variables
export (PackedScene) var enemy = null
export (int) var max_enemies = 6

onready var spawn_timer = $SpawnTimer

var player: Player = null
var enemy_count: int = 0

var remote_enemy_scene = preload("res://actors/RemoteEnemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(p: Player) -> void:
	self.player = p


# Called every frame
func _process(_delta: float) -> void:
	# Nothing to do if not enough states exist
	if Client.world_state_buffer.size() < 2:
		return
	
	# Get necessary data from Client
	var prev_enemy_state: Dictionary = Client.world_state_buffer[0]["enemies"]
	var future_enemy_state: Dictionary = Client.world_state_buffer[1]["enemies"]
	
	# Update for all enemies
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


func _on_SpawnTimer_timeout() -> void:
	return	# TODO: Remove? This is to prevent local spawning
	self.spawn_enemy()
	self.try_spawning()


func try_spawning() -> void:
	if self.spawn_timer.is_stopped() and self.enemy_count < self.max_enemies:
		self.spawn_timer.start()


func spawn_enemy() -> void:
	# Choose a spawn point
	var spawn_points: Array = []
	for child in self.get_children():
		if child is Position2D:
			spawn_points.append(child)	
	var spawn_point: Position2D = spawn_points[randi() % spawn_points.size()]
	
	# Create the enemy
	var enemy_object: Enemy = self.enemy.instance()
	enemy_object.global_position = spawn_point.global_position
	enemy_object.init(self.player)
	self.add_child(enemy_object)
	enemy_object.health_pool.connect("health_reached_zero", self, "enemy_died")
	
	# Increment count
	self.enemy_count += 1


func enemy_died() -> void:
	self.enemy_count -= 1
	self.try_spawning()
