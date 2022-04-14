extends Node2D


# Instance variables
export (PackedScene) var enemy = null
export (int) var max_enemies = 6
onready var spawn_timer = $SpawnTimer
var player: Player = null
var enemy_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(p: Player) -> void:
	self.player = p


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout() -> void:
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
