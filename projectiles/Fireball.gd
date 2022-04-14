extends Area2D
class_name Fireball


# Instance variables
export (int) var movement_speed = 25
export (int) var damage = 75
var direction: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


func _physics_process(_delta: float) -> void:
	if self.direction != Vector2.ZERO:
		self.global_position += self.direction.normalized() * self.movement_speed


func _on_Fireball_body_entered(body: Node) -> void:
	if "health_pool" in body:
		body.health_pool.current_health -= self.damage
	self.queue_free()


func _on_Fireball_body_exited(_body: Node) -> void:
	pass
