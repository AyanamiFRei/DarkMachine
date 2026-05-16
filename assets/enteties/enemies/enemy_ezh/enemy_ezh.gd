extends CharacterBody3D

@onready var ray_cast_right: RayCast3D = $RayCastRight
@onready var ray_cast_left: RayCast3D = $RayCastLeft
@onready var dmg_timer: Timer = $dmg_timer
@onready var anim: Sprite3D = $Sprite3D
@onready var gg: CharacterBody3D = $"../player"

var type = "enemy"

var SPEED = 1.3
var hp = 100
var dmg = 25

var player_in_area: CharacterBody3D = null
var can_attack := true

# Отбрасывание
var knockback_force = 90.0
var knockback_up = 4.0


func _physics_process(delta: float) -> void:

	position.z = 0

	# Гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Движение
	var direction = Vector3.LEFT
	velocity.x = direction.x * SPEED * (-1)

	# Разворот перед краем платформы
	if (not ray_cast_left.is_colliding()) and (SPEED > 0):
		SPEED *= -1

	if (not ray_cast_right.is_colliding()) and (SPEED < 0):
		SPEED *= -1

	move_and_slide()

	# Поворот спрайта
	if velocity.x > 0:
		anim.flip_h = false

	elif velocity.x < 0:
		anim.flip_h = true


# Игрок вошёл в зону атаки
func _on_damage_area_body_entered(body: Node3D) -> void:

	if body.has_method("take_dmg") and body.is_in_group("player"):

		player_in_area = body

		attack_player()


# Игрок вышел из зоны атаки
func _on_damage_area_body_exited(body: Node3D) -> void:

	if body == player_in_area:
		player_in_area = null


# Атака
func attack_player() -> void:
	if not can_attack:
		return

	if not is_instance_valid(player_in_area):
		player_in_area = null
		return

	var player := player_in_area

	if not player.is_inside_tree():
		player_in_area = null
		return

	if not is_inside_tree():
		return

	can_attack = false

	player.take_dmg(dmg)

	if not is_instance_valid(player):
		player_in_area = null
		return

	if not player.is_inside_tree():
		player_in_area = null
		return

	var dir = 1

	if player.global_position.x < global_position.x:
		dir = -1

	var push_vector = Vector3(
		dir * knockback_force,
		knockback_up,
		0
	)

	player.velocity = push_vector

	if is_inside_tree() and is_instance_valid(dmg_timer):
		dmg_timer.start()


# Кулдаун атаки
func _on_dmg_timer_timeout() -> void:
	can_attack = true

	if is_instance_valid(player_in_area) and player_in_area.is_inside_tree():
		attack_player()
	else:
		player_in_area = null


# Получение урона врагом
func take_dmg(damage: int) -> void:

	hp -= damage

	if hp <= 0:
		call_deferred("queue_free")
