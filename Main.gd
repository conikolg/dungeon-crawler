extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var projectile_spawner = $ProjectileSpawner
onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	GlobalSignals.connect('fireball_fired', projectile_spawner, 'spawn_fireball')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
