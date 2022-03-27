extends KinematicBody2D
class_name Fireball

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var movement_speed = 300

var direction: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if self.direction != Vector2.ZERO:
		self.move_and_slide(self.direction.normalized() * self.movement_speed)
