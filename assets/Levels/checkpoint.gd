extends Node3D

@onready var anim: AnimatedSprite3D = $AnimatedSprite3D

# Смещение точки спавна относительно чекпоинта (настраивается в инспекторе)
@export var spawn_offset: Vector3 = Vector3(0, 0.5, 0)

# Можно вручную задать точку спавна через инспектор (если пусто — берём позицию чекпоинта)
@export var override_spawn_position: Vector3 = Vector3.ZERO
@export var use_override: bool = false

func _ready() -> void:
	anim.play("idle")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	var spawn_pos: Vector3
	if use_override:
		spawn_pos = override_spawn_position
	else:
		spawn_pos = global_position + spawn_offset

	var scene_path = get_tree().current_scene.scene_file_path
	GameManager.set_respawn_point(spawn_pos, scene_path)

	print("Checkpoint saved: ", spawn_pos)
	anim.play("save")
