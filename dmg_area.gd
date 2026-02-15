extends Node3D

func _on_amg_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" or body is CharacterBody3D:
		if body.has_method("_on_death"):
			body._on_death()
