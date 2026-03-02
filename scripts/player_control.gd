extends CharacterBody3D

@export var menu_button: Node3D
@onready var progress_bar = get_tree().get_nodes_in_group("healthbar")
@onready var area_dmg: Area3D = $Area_dmg
@onready var attack_cool_down_timer: Timer = $Attack_CoolDown_Timer
@onready var heal_timer: Timer = $heal_timer


var can_attack = true
var attack = false
var attack_animations = ["attack1", "attack2"]

var type = "player"

var speed = 4
var speed_mult = 1
var jump_velocity = 6

var health = 100
var dmg = 50

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
	position.z = clamp(position.y, 0, 0)
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
			
	if Input.is_action_just_pressed("ui_cancel"):
		print("ESC нажата!")
		#print("menu_button = ", menu_button)
		get_tree().change_scene_to_file("res://assets/scenes/ingamemenu.tscn")
		#if menu_button:
			#menu_button.show_button()
			#can_move = false
			##get_tree().paused = true  # Опционально: игра на паузу
			#print("show_button() вызван")
		#else:
			#print("ОШИБКА: menu_button = null")
	
	#if attack:
		#if not anim.is_playing():
			#attack = false
		#else:
			#return
	var random_attack = attack_animations.pick_random()
	if Input.is_action_just_pressed("attack") and is_on_floor() and can_attack == true:
		can_attack = false
		attack = true
		anim.play(random_attack)
		await anim.animation_finished
		attack_action()
		attack_cool_down_timer.start(1)
		attack = false
		
				#if anim.is_playing() and anim.animation == random_attack:
			#return
		#else:
	
	if Input.is_action_just_pressed("heal"):
		heal_timer.start()
	
	
	
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
	if attack == true:
		return

	
	if velocity.x > 0:
		anim.flip_h = true
	elif velocity.x < 0:
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
	heal_timer.stop()
	if death or taking_dmg:  # Не получаем урон если мертвы или уже получаем
		return
	if progress_bar.size() > 0:
		progress_bar[0].value -= dmg
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
	
func attack_action():
	var overlapping_bodies = area_dmg.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.has_method("take_dmg") and body.type == "enemy":
			body.take_dmg(dmg)
	

func _on_attack_cool_down_timer_timeout() -> void:
	can_attack = true


func _on_heal_timer_timeout() -> void:
	if progress_bar.size() > 0:
		progress_bar[0].value += 30
	health += 30
