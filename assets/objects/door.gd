extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" or body is CharacterBody3D:
		call_deferred("change_lvl")
		
func change_lvl():
	get_tree().change_scene_to_file("res://assets/Levels/room_2.tscn")
