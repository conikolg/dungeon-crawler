extends Node
class_name ManaPool


export (int) var maximum_mana = 100
export (int) var mana_regeneration = 2

var current_mana: int


# Called when the node enters the scene tree for the first time.
func _ready():
	self.current_mana = self.maximum_mana


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout() -> void:
	var before = self.current_mana
	# Regain mana
	self.current_mana += self.mana_regeneration
	# Stay in bounds
	self.current_mana = clamp(self.current_mana, 0, self.maximum_mana)
