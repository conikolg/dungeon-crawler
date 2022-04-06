extends Node2D


# Instance variables
onready var projectile_spawner = $ProjectileSpawner
onready var player: Player = $Player
onready var enemy: Enemy = $Enemy
onready var hud = $HUD


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	GlobalSignals.connect('fireball_fired', projectile_spawner, 'spawn_fireball')
	self.hud.set_player(self.player)
	self.enemy.init(self.player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
