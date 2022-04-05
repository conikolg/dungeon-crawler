extends Node
class_name HealthPool


# Signals
signal health_changed(new_mana)

# Instance variables
export (int) var maximum_health = 100
export (int) var health_regeneration = 1
export (int) var health_regeneration_cutoff = 10
var current_health: int
var _previous_health: int


# Called when the node enters the scene tree for the first time.
func _ready():
	self.current_health = self.maximum_health
	self._previous_health = self.current_health


# Called every frame.
func _process(delta: float) -> void:
	# Emit signal that health has changed if it is different than in the last frame
	if self.current_health != self._previous_health:
		emit_signal("health_changed", self.current_health)
	self._previous_health = self.current_health


func _on_RegenTimer_timeout() -> void:
	if self.current_health >= self.health_regeneration_cutoff:
		return

	self.current_health += self.health_regeneration
	self.current_health = clamp(self.current_health, 0, self.maximum_health)
