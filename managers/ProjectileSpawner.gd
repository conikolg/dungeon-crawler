extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn_fireball(fireball_object: Fireball, position: Vector2, direction: Vector2) -> void:
	fireball_object.global_position = position
	fireball_object.direction = direction
	fireball_object.rotation = direction.angle()
	self.add_child(fireball_object)
