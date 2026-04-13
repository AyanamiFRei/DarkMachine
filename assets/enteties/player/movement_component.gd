extends Node3D
@onready var collision: CollisionShape3D = $"../../CollisionShape3D"
@onready var player: CharacterBody3D = $"../.."

@export var speed := 3.5
@export var crouch_speed := 1.5
@export var jump_velocity := 7.0
@export var gravity := 20.0
@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12
@export var short_jump_multiplier := 0.5
@export var crouch_height := 0.3
var stand_height := 0.0

var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var was_on_floor := false
var is_crouching := false


func _ready() -> void:
	var shape := collision.shape as CapsuleShape3D
	if shape:
		stand_height = shape.height
		
func tick(delta: float) -> void:
	var on_floor := player.is_on_floor()
	
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta
	if coyote_timer > 0.0:
		coyote_timer -= delta
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	
	# Без реализации анимаций не работает
	#is_crouching = Input.is_action_pressed("Crouch") and player.is_on_floor()
	#var shape := collision.shape as CapsuleShape3D
	#if shape:
		#shape.height = crouch_height if is_crouching else stand_height

	var move_speed := crouch_speed if is_crouching else speed
	var input_dir := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = (input_dir * move_speed) * -1

	if on_floor:
		coyote_timer = coyote_time
		if player.velocity.y < 0:
			player.velocity.y = 0
	else:
		if was_on_floor:
			coyote_timer = coyote_time
		player.velocity.y -= gravity * delta

	if jump_buffer_timer > 0.0 and (on_floor or coyote_timer > 0.0):
		player.velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	if Input.is_action_just_released("ui_accept") and player.velocity.y > 0:
		player.velocity.y *= short_jump_multiplier

	was_on_floor = on_floor
