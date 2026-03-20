extends Node3D
#@onready var player: CharacterBody3D= $player
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" or body is CharacterBody3D:
		call_deferred("change_lvl")
		body.set_checkpoint(Vector3(0.222,-0.01,-0.5))
func change_lvl():
	get_tree().change_scene_to_file("res://Levels/room_1.tscn")
	
	#player.global_position = Vector3(0.222,-0.01,-0.5)
