extends Node2D


# Instance variables
onready var player: Player = $Player
onready var hud = $HUD


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	self.hud.set_player(self.player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
