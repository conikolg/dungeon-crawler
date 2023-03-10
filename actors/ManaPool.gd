extends Node
class_name ManaPool


# Signals
signal mana_changed(new_mana)

# Instance variables
export (int) var maximum_mana = 100
export (int) var mana_regeneration = 2
var current_mana: int
var _previous_mana: int


# Called when the node enters the scene tree for the first time.
func _ready():
	self.current_mana = self.maximum_mana
	self._previous_mana = self.current_mana


# Called every frame.
func _process(_delta: float) -> void:
	# Emit signal that mana has changed if it is different than in the last frame
	if self.current_mana != self._previous_mana:
		emit_signal("mana_changed", self.current_mana)
	self._previous_mana = self.current_mana


func _on_Timer_timeout() -> void:
	self.current_mana += self.mana_regeneration
	self.current_mana = int(clamp(self.current_mana, 0, self.maximum_mana))
