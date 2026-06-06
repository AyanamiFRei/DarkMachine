extends Node3D

@export var target_scene: String
@export var spawn_point: Vector3

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
	var player = get_tree().get_first_node_in_group("player")
	if player:
		print("[Door] HP перед сохранением: ", player.get_node("Components/HealthComponent").health)
		GameManager.save_player(player)
		print("[Door] GameManager.saved_health после save: ", GameManager.saved_health)
		GameManager.spawn_position = spawn_point
		GameManager.current_game_scene = target_scene
		GameManager.has_custom_spawn = true
	get_tree().change_scene_to_file(target_scene)
