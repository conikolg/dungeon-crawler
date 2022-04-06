extends KinematicBody2D
class_name Enemy


enum EnemyState {
	IDLING,
	CHASING,
	ATTACKING
}

# Instance variables
export (int) var movement_speed = 75
export (int) var attack_damage = 5
export (float) var attack_speed = 2
onready var attack_timer = $AttackTimer
var target: Player = null
var state: int = -1 setget set_state


# Attack state instance variables
var base_atk_dir: Vector2 = Vector2.ZERO
var right_punch: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.state = EnemyState.IDLING


func init(player: Player) -> void:
	self.target = player


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta: float) -> void:
	match self.state:
		EnemyState.IDLING:
			_physics_process_idling(delta)
		EnemyState.CHASING:
			_physics_process_chasing(delta)
		EnemyState.ATTACKING:
			_physics_process_attacking(delta)


func set_state(new_state: int) -> void:
	if new_state == self.state:
		return
		
	if new_state == EnemyState.ATTACKING:
		self.right_punch = true
		self.base_atk_dir = self.target.global_position - self.global_position
	
	state = new_state


func _physics_process_idling(delta: float) -> void:
	if self.target:
		self.state = EnemyState.CHASING


func _physics_process_chasing(delta: float) -> void:
	self.look_at(self.target.global_position)
	var direction: Vector2 = self.global_position.direction_to(self.target.global_position)
	var movement: Vector2 = direction * self.movement_speed
	self.move_and_slide(movement)


func _physics_process_attacking(delta: float) -> void:
	if self.attack_timer.is_stopped():
		# Do an alternating left or right punch
		if self.right_punch:
			var new_dir: float = self.base_atk_dir.angle() - PI / 6
			self.rotation = new_dir
		else:
			var new_dir: float = self.base_atk_dir.angle() + PI / 6
			self.rotation = new_dir
		self.right_punch = !self.right_punch
		
		# Attack the target
		self.target.health_pool.current_health -= self.attack_damage
		
		# Set attack speed, start the timer
		self.attack_timer.wait_time = 1 / self.attack_speed
		self.attack_timer.start()
	

func _on_Area2D_body_entered(body: Node) -> void:
	# Ignore body if it isn't the target
	if body != self.target:
		return
		
	self.state = EnemyState.ATTACKING


func _on_Area2D_body_exited(body: Node) -> void:
	# Ignore body if it isn't the target
	if body != self.target:
		return
		
	self.state = EnemyState.CHASING
