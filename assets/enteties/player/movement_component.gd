extends Node3D

@onready var collision: CollisionShape3D = $"../../CollisionShape3D"
@onready var player: CharacterBody3D = $"../.."

@onready var ledge_wall_ray: RayCast3D = $LedgeWallRay
@onready var ledge_clear_ray: RayCast3D = $LedgeClearRay
@onready var ledge_top_ray: RayCast3D = $LedgeTopRay

@export var speed := 3.5
@export var crouch_speed := 1.5
@export var jump_velocity := 10.0
@export var gravity := 20.0
@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12
@export var short_jump_multiplier := 0.5
@export var crouch_height := 0.3

@export var ledge_hang_x_offset := 0.12
@export var ledge_hang_y_offset := 0.15
@export var ledge_climb_x_offset := 0.12
@export var ledge_climb_y_offset := 0.15

var stand_height := 0.0
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var was_on_floor := false
var is_crouching := false

var facing_x := 1.0
var is_hanging := false
var ledge_climb_position := Vector3.ZERO
var ledge_cooldown := 0.0

var jump_sound: AudioStreamPlayer
var land_sound: AudioStreamPlayer
var step_sounds: Array[AudioStreamPlayer] = []
var step_timer: float = 0.0
var step_interval: float = 0.4


func _ready() -> void:
	randomize()

	var shape := collision.shape as CapsuleShape3D
	if shape:
		stand_height = shape.height

	var jump_file = load("res://assets/enteties/player/audios/jump.wav")
	if jump_file:
		jump_sound = AudioStreamPlayer.new()
		jump_sound.stream = jump_file
		jump_sound.volume_db = -16.0
		add_child(jump_sound)

	var land_file = load("res://assets/enteties/player/audios/landing.wav")
	if land_file:
		land_sound = AudioStreamPlayer.new()
		land_sound.stream = land_file
		land_sound.volume_db = -16.0
		add_child(land_sound)

	var step_files = [
		"res://assets/enteties/player/audios/run1.wav",
		"res://assets/enteties/player/audios/run5.wav",
		"res://assets/enteties/player/audios/run6.wav",
		"res://assets/enteties/player/audios/run7.wav",
		"res://assets/enteties/player/audios/run2.wav",
		"res://assets/enteties/player/audios/run3.wav",
		"res://assets/enteties/player/audios/run4.wav"
	]

	for file_path in step_files:
		var file = load(file_path)
		if file:
			var sound_player = AudioStreamPlayer.new()
			sound_player.stream = file
			sound_player.volume_db = -16.0
			add_child(sound_player)
			step_sounds.append(sound_player)


func tick(delta: float) -> void:
	if ledge_cooldown > 0.0:
		ledge_cooldown -= delta

	if is_hanging:
		handle_ledge_hang()
		return

	var on_floor := player.is_on_floor()

	if not was_on_floor and on_floor:
		if land_sound:
			land_sound.play()

	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta

	if coyote_timer > 0.0:
		coyote_timer -= delta

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time

	var move_speed := crouch_speed if is_crouching else speed
	var input_dir := Input.get_axis("ui_left", "ui_right")

	player.velocity.x = input_dir * move_speed * -1

	if on_floor and not is_hanging and abs(player.velocity.x) > 0.05:
		var step_freq: float = 0.65
		step_timer -= delta

		if step_timer <= 0.0:
			if step_sounds.size() > 0:
				var random_step = step_sounds[randi() % step_sounds.size()]
				random_step.play()
			step_timer = step_freq
	else:
		step_timer = 0.0

	if abs(player.velocity.x) > 0.05:
		facing_x = sign(player.velocity.x)
		update_ledge_rays_direction()

	if on_floor:
		coyote_timer = coyote_time
		if player.velocity.y < 0:
			player.velocity.y = 0
	else:
		if was_on_floor:
			coyote_timer = coyote_time

		player.velocity.y -= gravity * delta

		if player.velocity.y < 0 and ledge_cooldown <= 0.0:
			check_ledge_grab()

	if jump_buffer_timer > 0.0 and (on_floor or coyote_timer > 0.0):
		player.velocity.y = jump_velocity
		if jump_sound:
			jump_sound.play()
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	if Input.is_action_just_released("ui_accept") and player.velocity.y > 0:
		player.velocity.y *= short_jump_multiplier
		
	if Input.is_action_just_pressed("Crouch"):
		if on_floor:
			is_crouching = true
			collision.scale = Vector3(0.1, 0.05, 0.1)
	
	if Input.is_action_just_released("Crouch"):
		if is_crouching:
			is_crouching = false
			collision.scale = Vector3(0.1, 0.1, 0.1)

	was_on_floor = on_floor


func update_ledge_rays_direction() -> void:
	ledge_wall_ray.target_position.x = abs(ledge_wall_ray.target_position.x) * facing_x
	ledge_clear_ray.target_position.x = abs(ledge_clear_ray.target_position.x) * facing_x
	ledge_top_ray.position.x = abs(ledge_top_ray.position.x) * facing_x


func check_ledge_grab() -> void:
	ledge_wall_ray.force_raycast_update()
	ledge_clear_ray.force_raycast_update()
	ledge_top_ray.force_raycast_update()

	var wall_detected := ledge_wall_ray.is_colliding()
	var head_clear := not ledge_clear_ray.is_colliding()
	var top_detected := ledge_top_ray.is_colliding()

	if not wall_detected:
		return

	if not head_clear:
		return

	if not top_detected:
		return

	start_ledge_hang(ledge_top_ray.get_collision_point())


func start_ledge_hang(ledge_top_position: Vector3) -> void:
	is_hanging = true
	player.velocity = Vector3.ZERO

	var edge_x := ledge_wall_ray.get_collision_point().x
	var top_y := ledge_top_position.y

	player.global_position = Vector3(
		edge_x - facing_x * ledge_hang_x_offset,
		top_y - ledge_hang_y_offset,
		player.global_position.z
	)

	ledge_climb_position = Vector3(
		edge_x + facing_x * ledge_climb_x_offset,
		top_y + ledge_climb_y_offset,
		player.global_position.z
	)


func handle_ledge_hang() -> void:
	player.velocity = Vector3.ZERO

	# S / Crouch — отпустить уступ и упасть вниз
	if Input.is_action_just_pressed("Crouch"):
		drop_from_ledge()
		return

	# Прыжок / вверх — залезть на уступ
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		climb_ledge()


func drop_from_ledge() -> void:
	is_hanging = false
	ledge_cooldown = 0.25

	# Отодвигаем игрока от стены, чтобы он сразу снова не зацепился
	player.global_position.x -= facing_x * 0.12

	# Даём небольшое падение вниз
	player.velocity = Vector3(0, -2.0, 0)


func climb_ledge() -> void:
	is_hanging = false
	ledge_cooldown = 0.25
	player.global_position = ledge_climb_position
	player.velocity = Vector3.ZERO
