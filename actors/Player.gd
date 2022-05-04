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


func _physics_process(_delta: float) -> void:
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
	
	# Send player state to the server
	Client.send_server_player_state(self.serialize())


# Called every frame
func _process(_delta: float) -> void:
	# Nothing to do if not enough states exist
	if Client.world_state_buffer.size() < 2:
		return
	
	# Get necessary data from Client
	var prev_player_state: Dictionary = Client.world_state_buffer[0]["players"]
	var local_player_state: Dictionary = prev_player_state[str(Client.multiplayer.get_network_unique_id())]
	# Set local player health to update from server.
	# TODO: only do this when update is applied, not every frame between world state updates
	self.health_pool.current_health = local_player_state["hp"]["health"]
	

# This function will handle one-off input events
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('shoot'):
		self.weapon.shoot()


func serialize() -> Dictionary:
	return {
		"pos": self.global_position,
		"rot": self.rotation
	}
