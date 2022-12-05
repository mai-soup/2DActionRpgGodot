extends Control

onready var label = $Label

var hearts: = 4 setget set_hearts
var max_hearts: = 4 setget set_max_hearts

func set_hearts(value: int) -> void:
	hearts = clamp(value, 0, max_hearts)
	
	if label != null:
		label.text = "HP = " + str(hearts)

func set_max_hearts(value: int) -> void:
	# max hearts can never be < 0
	max_hearts = max(value, 1)

func _ready() -> void:
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
