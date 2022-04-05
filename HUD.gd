extends CanvasLayer


# Instance variables
onready var health_bar = $MarginContainer/Rows/HealthMana/Health
onready var mana_bar = $MarginContainer/Rows/HealthMana/Mana
onready var mana_tween = $MarginContainer/Rows/HealthMana/ManaTween
var player: Player


func set_player(player: Player):
	self.player = player
	self.player.mana_pool.connect("mana_changed", self, "set_mana")
	self.set_mana(self.player.mana_pool.current_mana)


func set_health(new_health: int) -> void:
	self.health_bar.value = new_health
	
	
func set_mana(new_mana: int) -> void:
	self.mana_tween.interpolate_property(
		self.mana_bar, "value", 				# What to interpolate
		self.mana_bar.value, new_mana, 0.1,		# From what to what over how long
		Tween.TRANS_LINEAR, Tween.EASE_IN)		# Transition algorithms
	self.mana_tween.start()
	
	#self.mana_bar.value = new_mana
