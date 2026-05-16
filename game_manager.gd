extends Node

var spawn_position: Vector3 = Vector3.ZERO
var has_custom_spawn: bool = false

var saved_scene: String = ""
var saved_rotation: Vector3 = Vector3.ZERO
var inventory_items: Array[Dictionary] = []
var money: int = 0

func add_item(item_data: Dictionary) -> void:
	for item in inventory_items:
		if item.id == item_data.id:
			item.count += 1
			return

	item_data.count = 1
	inventory_items.append(item_data)
func save_player(player: Node3D):
	saved_scene = player.get_tree().current_scene.scene_file_path
	spawn_position = player.global_position
	saved_rotation = player.rotation
	has_custom_spawn = true

func save_player1(player: Node3D):
	saved_scene = player.get_tree().current_scene.scene_file_path
	spawn_position = player.global_position
	saved_rotation = player.rotation
	has_custom_spawn = true

func has_save() -> bool:
	return saved_scene != ""
