extends Area2D
class_name Fireball


# Attributes
export (int) var movement_speed = 30
var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if self.direction != Vector2.ZERO:
		self.global_position += self.direction.normalized() * self.movement_speed
