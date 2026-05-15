extends Node

@export var hit_sparks_scene: PackedScene

@onready var area_dmg: Area3D = $Area_dmg
@onready var cooldown_timer: Timer = $Timers/Attack_CoolDown_Timer

var can_attack = true
var dmg = 50

signal attack_started
signal attack_finished

func attack():
	if not can_attack:
		return

	can_attack = false
	attack_started.emit()
	attack_action()
	cooldown_timer.start()

func attack_action():
	var overlapping_bodies = area_dmg.get_overlapping_bodies()

	for body in overlapping_bodies:
		if body.has_method("take_dmg") and "type" in body and body.type == "enemy":
			body.take_dmg(dmg)
			spawn_hit_sparks(body)

func spawn_hit_sparks(enemy: Node3D) -> void:
	if hit_sparks_scene == null:
		return

	var sparks = hit_sparks_scene.instantiate()
	get_tree().current_scene.add_child(sparks)

	# Позиция между игроком и врагом
	var hit_pos = owner.global_position.lerp(enemy.global_position, 0.5)

	# Небольшое смещение вверх
	hit_pos.y += 0.0

	# Для 2.5D
	hit_pos.z = 0

	sparks.global_position = hit_pos

func _on_attack_cool_down_timer_timeout():
	can_attack = true
	attack_finished.emit()

func _ready():
	cooldown_timer.timeout.connect(_on_attack_cool_down_timer_timeout)
