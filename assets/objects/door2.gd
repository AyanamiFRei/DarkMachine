extends Node3D
var target_scene: String = "res://assets/Levels/room_2.tscn"
var spawn_point: Vector3 = Vector3(-0.371, -0.496, -0.011)

var can_trigger: bool = false  # ← по умолчанию выключена!

func _ready() -> void:
	# Включаем дверь через 0.5 сек после загрузки сцены
	await get_tree().create_timer(0.5).timeout
	can_trigger = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not can_trigger:
		return  # ← игнорируем если кулдаун не прошёл
	if body.name == "Player" or body is CharacterBody3D:
		call_deferred("change_lvl")

func change_lvl():
	print("spawn_point двери: ", spawn_point)
	GameManager.spawn_position = spawn_point
	GameManager.has_custom_spawn = true
	get_tree().change_scene_to_file(target_scene)
