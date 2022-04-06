extends KinematicBody2D
class_name Player


# Instance variables
export (int) var movement_speed = 150
onready var weapon = $FireballWeapon
onready var mana_pool = $ManaPool
onready var health_pool = $HealthPool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.weapon.initialize(mana_pool)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta: float) -> void:
	# Move in the direction chosen
	var movement_dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("up"):
		movement_dir += Vector2.UP
	if Input.is_action_pressed("down"):
		movement_dir += Vector2.DOWN
	if Input.is_action_pressed("left"):
		movement_dir += Vector2.LEFT
	if Input.is_action_pressed("right"):
		movement_dir += Vector2.RIGHT
	self.move_and_slide(movement_dir.normalized() * self.movement_speed)
	
	# Turn towards where the mouse is pointing at all times
	var mouse_position: Vector2 = get_global_mouse_position()
	self.look_at(mouse_position)


# This function will handle one-off input events
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('shoot'):
		self.weapon.shoot()
