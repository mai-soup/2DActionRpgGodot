extends Node

signal no_health
signal health_changed(value)

export var max_health: = 1
onready var health: = max_health setget set_health

func set_health(value: int) -> void:
	health = value
	emit_signal("health_changed", health)
	
	if health <= 0:
		emit_signal("no_health")
