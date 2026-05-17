extends Node

# Текущий уровень (всегда актуален)
var current_game_scene: String = ""

# ESC / пауза
var spawn_position: Vector3 = Vector3.ZERO
var saved_scene: String = ""
var saved_rotation: Vector3 = Vector3.ZERO
var has_custom_spawn: bool = false

# Чекпоинт
var respawn_position: Vector3 = Vector3.ZERO
var respawn_scene: String = ""
var has_respawn_point: bool = false

# Флаг: загрузка произошла после нажатия "Respawn" (не дверь, не пауза)
var coming_from_death: bool = false

var inventory_items: Array[Dictionary] = []
var money: int = 0

func save_player(player: Node3D) -> void:
	var scene := player.get_tree().current_scene.scene_file_path
	saved_scene = scene
	current_game_scene = scene
	spawn_position = player.global_position
	saved_rotation = player.rotation
	has_custom_spawn = true

func set_respawn_point(pos: Vector3, scene_path: String) -> void:
	respawn_position = pos
	respawn_scene = scene_path
	has_respawn_point = true

func has_save() -> bool:
	return current_game_scene != ""

func add_item(item_data: Dictionary) -> void:
	for item in inventory_items:
		if item.id == item_data.id:
			item.count += 1
			return
	item_data.count = 1
	inventory_items.append(item_data)
