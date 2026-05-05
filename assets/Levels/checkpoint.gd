extends Node3D

@onready var anim: AnimatedSprite3D = $AnimatedSprite3D

func _ready() -> void:
	anim.play("idle")

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("checkpoint enter")
	if body.is_in_group("player"):
		if body.has_method("set_checkpoint"):
			body.set_checkpoint(global_position)
			print("checkpoint set")
			anim.play("save")
