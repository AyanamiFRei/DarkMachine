extends Camera3D

@export var player_path: NodePath
@export var normal_offset := Vector3(0, 0, -5)
@export var follow_smooth: float = 5.0
@export var catch_up_smooth: float = 2.0

var player: Node3D
var current_offset: Vector3


func _ready():
	player = get_node(player_path)
	current_offset = normal_offset
	global_position = player.global_position + current_offset


func _physics_process(delta):
	if player == null:
		print("PIZDEC")
		return

	global_position = Vector3(
		lerpf(global_position.x, player.global_position.x + current_offset.x, catch_up_smooth * delta),
		lerpf(global_position.y, player.global_position.y + current_offset.y, catch_up_smooth * delta),
		player.global_position.z + current_offset.z
	)
