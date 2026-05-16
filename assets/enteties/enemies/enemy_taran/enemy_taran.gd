extends CharacterBody3D

var agr = false
var is_cycling = false
var can_damage = false
var is_dashing = false

var direction = 1
var current_velocity_x = 0.0
var type = "enemy"

@export var SPEED = 6.0
@export var hp = 200
@export var dmg = 25

# Звуки
@export var detect_sound: AudioStream
@export var rides_sound: AudioStream

@onready var playerNode: CharacterBody3D = $"../player"
@onready var dmg_timer: Timer = $dmg_timer
@onready var anim: AnimatedSprite3D = $AnimatedSprite3D

# Текущие аудиоплееры
var prep_sfx_player: AudioStreamPlayer = null
var dash_sfx_player: AudioStreamPlayer = null

# Отбрасывание
var knockback_force = 50.0
var knockback_up = 2.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = current_velocity_x
	move_and_slide()

	if agr and not is_cycling:
		start_attack_cycle()


func start_attack_cycle() -> void:
	is_cycling = true

	# Если идет анимация обнаружения
	if anim.animation == "player_detect" and anim.is_playing():
		await anim.animation_finished

	while agr and is_inside_tree():

		print("Разгон...")
		current_velocity_x = 0

		# Поворот к игроку
		if playerNode.global_position.x > global_position.x:
			anim.flip_h = false
			direction = 1
		else:
			anim.flip_h = true
			direction = -1

		# Подготовка к рывку
		anim.play("attack_prep")

		prep_sfx_player = play_local_sfx(detect_sound)

		await get_tree().create_timer(1.2).timeout

		# Останавливаем звук подготовки
		stop_player(prep_sfx_player)
		prep_sfx_player = null

		if not is_inside_tree() or not agr:
			break

		# Рывок
		print("Рывок!")

		current_velocity_x = direction * SPEED
		can_damage = true
		is_dashing = true

		anim.play("attack")

		dash_sfx_player = play_local_sfx(rides_sound)

		var dash_timer = get_tree().create_timer(2.0)

		# Ждем окончания рывка
		while is_inside_tree() and dash_timer.time_left > 0 and is_dashing:
			await get_tree().process_frame

		end_dash()

		if not is_inside_tree():
			break

		# Отдых
		print("Отдых...")

		if randf() < 0.2:
			anim.play("smoke")
		else:
			anim.play("idle")

		await get_tree().create_timer(2.0).timeout

		if not agr:
			anim.play("idle")
			break

		if not is_inside_tree():
			break

		print("--- Цикл завершен ---")

	is_cycling = false


func end_dash() -> void:
	is_dashing = false
	can_damage = false
	current_velocity_x = 0

	stop_player(dash_sfx_player)
	dash_sfx_player = null


func play_local_sfx(sound: AudioStream, volume_db: float = 0.0):

	if sound == null:
		print("Звук не назначен!")
		return null

	var player = AudioStreamPlayer.new()
	add_child(player)

	player.stream = sound
	player.bus = "SFX"
	player.volume_db = volume_db

	player.play()

	player.finished.connect(player.queue_free)

	return player


func stop_player(player) -> void:
	if player and is_instance_valid(player):
		player.stop()
		player.queue_free()


# АГР
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
		is_cycling = false

		end_dash()

		stop_player(prep_sfx_player)
		prep_sfx_player = null

		anim.play("idle")


# УРОН
func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("player") and can_damage:

		if body.has_method("take_dmg"):
			body.take_dmg(dmg)

		var dir = 1 if body.global_position.x > global_position.x else -1

		if body is CharacterBody3D:
			body.velocity = Vector3(
				dir * knockback_force,
				knockback_up,
				0
			)

		end_dash()


# СТОЛКНОВЕНИЕ СО СТЕНОЙ
func _on_area_3d_3_body_entered(body: Node3D) -> void:

	if not body.is_in_group("player") and is_dashing:

		print("Впился в стену!")

		end_dash()


func take_dmg(amount):

	hp -= amount

	if hp <= 0:

		agr = false
		is_cycling = false

		end_dash()

		stop_player(prep_sfx_player)

		queue_free()
