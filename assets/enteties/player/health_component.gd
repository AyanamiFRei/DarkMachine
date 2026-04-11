extends Node

@export var max_health := 100
var health := 100

signal died
signal health_changed

func _ready():
	health = max_health

func take_damage(amount):
	if health <= 0:
		return

	health -= amount
	health_changed.emit(health)

	if health <= 0:
		die()

func heal(amount):
	health = min(health + amount, max_health)
	health_changed.emit(health)

func die():
	died.emit()
