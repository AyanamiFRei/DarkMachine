extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 7.5
var coyote_time_active := true
var jump_buffer_active := false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if %CoyoteTimer.is_stopped():
			%CoyoteTimer.start()
	else:
		if jump_buffer_active ==true:
			jump()
			jump_buffer_active=false
		coyote_time_active = true
		%CoyoteTimer.stop()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") :
		if coyote_time_active	:
			jump()
		else:
			jump_buffer_active=true
			%JumpBufferTimer.start()
			coyote_time_active = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_coyote_timer_timeout() -> void:
	coyote_time_active = false
func jump():
	velocity.y = JUMP_VELOCITY



func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer_active=false
