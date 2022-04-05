extends Area2D
class_name Fireball


# Instance variables
export (int) var movement_speed = 25
var direction: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


func _physics_process(delta: float) -> void:
	if self.direction != Vector2.ZERO:
		self.global_position += self.direction.normalized() * self.movement_speed
