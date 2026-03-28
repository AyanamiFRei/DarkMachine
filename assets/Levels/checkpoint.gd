extends Area3D
func _on_body_entered(body: Node3D) ->void:
	print("checkpoint enter")
	if body.is_in_group("player"):	
		if body.has_method("set_checkpoint"):
			body.set_checkpoint(global_position)
			print("checkpoint set")
