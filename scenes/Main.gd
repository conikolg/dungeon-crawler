extends Node2D


# Instance variables
onready var projectile_spawner = $ProjectileSpawner
onready var enemy_spawner = $EnemySpawner
onready var player: Player = $Player
onready var hud = $HUD


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	GlobalSignals.connect('fireball_fired', projectile_spawner, 'spawn_fireball')
	self.enemy_spawner.init(self.player)
	self.hud.set_player(self.player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
