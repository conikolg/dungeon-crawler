extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var Fireball


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func shoot() -> void:
	if self.Fireball == null:
		return
	
	var fireball_instance = Fireball.instance()
	var direction: Vector2 = (get_global_mouse_position() - self.global_position).normalized()
	GlobalSignals.emit_signal('fireball_fired', fireball_instance, self.global_position, direction)
