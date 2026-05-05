extends Node

var spawn_position: Vector3 = Vector3.ZERO
var has_custom_spawn: bool = false

var saved_scene: String = ""
var saved_rotation: Vector3 = Vector3.ZERO

func save_player(player: Node3D):
	saved_scene = player.get_tree().current_scene.scene_file_path
	spawn_position = player.global_position
	saved_rotation = player.rotation
	has_custom_spawn = true

func has_save() -> bool:
	return saved_scene != ""
