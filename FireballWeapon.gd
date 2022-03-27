extends Node2D


# Attributes
export (PackedScene) var Fireball
export (int) var mana_cost = 25

var mana_pool: ManaPool = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func initialize(mana_pool: ManaPool) -> void:
	self.mana_pool = mana_pool

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func shoot() -> void:
	# Make sure there is something to shoot.
	if self.Fireball == null:
		print('FireballWeapon: self.Fireball is null, nothing to shoot')
		return
	
	# Make sure mana is available
	if self.mana_pool == null:
		print('FireballWeapon: self.mana_pool is null, cannot cast spell')
		return
	if self.mana_pool.current_mana < self.mana_cost:
		return
	
	# Cast fireball
	self.mana_pool.current_mana -= self.mana_cost
	var fireball_instance = Fireball.instance()
	var direction: Vector2 = (get_global_mouse_position() - self.global_position).normalized()
	GlobalSignals.emit_signal('fireball_fired', fireball_instance, self.global_position, direction)
