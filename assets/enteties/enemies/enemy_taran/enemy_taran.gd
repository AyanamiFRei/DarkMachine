extends CharacterBody3D

var agr = false
var is_cycling = false
var can_damage = false
var is_dashing = false # Флаг активного рывка для прерывания стенкой
var direction = 1
@onready var playerNode: CharacterBody3D = $"../player"
@onready var dmg_timer: Timer = $dmg_timer
@onready var anim: AnimatedSprite3D = $AnimatedSprite3D
var SPEED = 6.0 
var hp = 200
var dmg = 25
var current_velocity_x = 0.0
var type = "enemy"

var detect_sound = "res://assets/enteties/enemies/enemy_taran/audio/omaewa.wav"
var rides_sound = "res://assets/enteties/enemies/enemy_taran/audio/taranrides.wav"

# Для отбрасывания
var knockback_force = 50.0 
var knockback_up = 2.0  
var dir = 1
var push_vector = Vector3(dir * knockback_force, knockback_up, 0)

func _physics_process(delta: float) -> void:
	# Шанс на дым перенесем лучше в покой, чтобы не дергать каждый кадр
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = current_velocity_x
	move_and_slide()

	if agr and not is_cycling:
		start_attack_cycle()

func start_attack_cycle():
	is_cycling = true
	
	# Ждем окончания анимации обнаружения, если она идет
	if anim.animation == "player_detect" and anim.is_playing():
		await anim.animation_finished

	while agr and is_inside_tree():
		print("Разгон...")
		current_velocity_x = 0
		
		if playerNode.global_position.x > global_position.x:
			anim.flip_h = false
			direction = 1 
			
		else:
			anim.flip_h = true
			direction = -1
		
		anim.play("attack_prep")
		SoundManager.play_sfx(detect_sound)
		await get_tree().create_timer(1.2).timeout
		if not is_inside_tree() or not agr: break

		print("Рывок!")
		current_velocity_x = direction * SPEED
		can_damage = true
		is_dashing = true # ВКЛЮЧАЕМ рывок
		anim.play("attack")
		SoundManager.play_sfx(rides_sound)
		
		var dash_timer = get_tree().create_timer(2.0)
		
		# Ждем 2 секунды ИЛИ пока флаг is_dashing не станет false (от стены или игрока)
		while is_inside_tree() and dash_timer.time_left > 0 and is_dashing:
			await get_tree().process_frame
		
		# Конец фазы движения
		is_dashing = false 
		SoundManager.stop_sfx(rides_sound)
		can_damage = false
		current_velocity_x = 0
		
		if not is_inside_tree(): break

		print("Отдых...")
		# С некоторым шансом играем "smoke" вместо обычного покоя
		if randf() < 0.2:
			anim.play("smoke")
		else:
			anim.play("idle") # Убедись, что есть анимация idle или аналогичная
			
		await get_tree().create_timer(2.0).timeout
		if not agr: 
			anim.play("idle") # Включаем покой
			break 
		if not is_inside_tree(): break
		print("--- Цикл завершен ---")

# Сигнал АГРА
func _on_area_3d_2_body_entered(body) -> void:
	if body.is_in_group("player") and not agr:
		if playerNode.global_position.x > global_position.x:
			anim.flip_h = false
		
		else:
			anim.flip_h = true
		
		anim.play("player_detect")
		agr = true
func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Игрок ушел, теряю интерес...")
		agr = false
		is_cycling = false # Позволяет циклу корректно завершиться
# Сигнал УРОНА (на теле врага)
func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("player") and can_damage:
		if body.has_method("take_dmg"):
			body.take_dmg(dmg)
			can_damage = false # Не бьем дважды за рывок
			is_dashing = false # Останавливаемся при попадании
			SoundManager.stop_sfx(rides_sound)
			
		# Логика отбрасывания
		dir = 1 if body.global_position.x > global_position.x else -1
		if body is CharacterBody3D:
			body.velocity = Vector3(dir * knockback_force, knockback_up, 0)
			body.move_and_slide()

# Сигнал СТЕНЫ (отдельная Area3D или та же самая)
func _on_area_3d_3_body_entered(body: Node3D) -> void:
	# Если это не игрок и мы сейчас в рывке
	if not body.is_in_group("player") and is_dashing:
		print("Впился в стену!")
		is_dashing = false # Это мгновенно прерывает цикл while в start_attack_cycle
		SoundManager.stop_sfx(rides_sound)
		current_velocity_x = 0

func take_dmg(amount):
	hp -= amount
	if hp <= 0:
		agr = false
		is_cycling = false
		queue_free()
