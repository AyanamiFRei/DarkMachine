extends CharacterBody3D


#const SPEED = 5.0

var type = "player"

var speed = 4
var speed_mult = 1
var jump_velocity = 6

var health = 100
var dmg = 100

var death = false
var can_move = true
var taking_dmg = false

var coyote_time_active := true
var jump_buffer_active := false

@onready var anim: AnimatedSprite3D = $AnimatedSprite3D

func _ready() -> void:
	anim.play("idle")

func _physics_process(delta: float) -> void:
	
	if death or not can_move:
		return
	
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
			
	if Input.is_action_just_pressed("leave") :
		get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")
	
	if health <= 0:
		_on_death()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed * speed_mult
		# velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_mult)
		# wsvelocity.z = move_toward(velocity.z, 0, SPEED)
	update_animation()
	move_and_slide()
	
func update_animation():
	if death == true:
		return
	if taking_dmg == true:
		return
	
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false
		
	# Проверяем состояние в воздухе в первую очередь
	if not is_on_floor():
		if velocity.y > 0:
			anim.play("jump")
		else:
			anim.play("fall")
	# Если на земле, тогда проверяем движение по горизонтали
	elif velocity.x:
		anim.play("run")
	else:
		anim.play("idle")
	
	if position.y < -5:
		print("out of bounds")
		_on_death()


func _on_death():
	if death:  # Если уже мертв, ничего не делаем
		return
	death = true
	can_move = false  # Отключаем возможность двигаться
	
	# Останавливаем движение
	velocity = Vector3.ZERO
	
	# Проигрываем анимацию смерти
	anim.play("death")
	
	# Ждем окончания анимации смерти
	await anim.animation_finished
	
	# Исчезаем
	self.queue_free()
	
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")


func take_dmg(dmg):
	if death or taking_dmg:  # Не получаем урон если мертвы или уже получаем
		return
	
	taking_dmg = true
	health -= dmg
	print("Получен урон: ", dmg, " Осталось здоровья: ", health)
	
	# Проигрываем анимацию получения урона
	anim.play("take_hit")
	await anim.animation_finished
	
	taking_dmg = false
	
	# Проверяем смерть ПОСЛЕ получения урона
	if health <= 0 and not death:
		_on_death()

	
func _on_coyote_timer_timeout() -> void:
	coyote_time_active = false

func jump():
	velocity.y = jump_velocity



func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer_active=false
	
