extends CharacterBody3D
@onready var health_component = $Components/HealthComponent
@onready var combat = $Components/CombatComponent
@onready var movement = $Components/MovementComponent
@onready var animation_component = $Components/AnimationComponent
@onready var heal_timer: Timer = $Components/HealthComponent/Timers/heal_timer
@export var menu_button: Node3D
@onready var progress_bar = get_tree().get_nodes_in_group("healthbar")

var type = "player"
var spawn_point=Vector3.ZERO
var death = false
var can_move = true
var taking_dmg = false
var is_attacking = false
# ############################################################


@onready var anim: AnimatedSprite3D = $Visual/AnimatedSprite3D/StockModel

func _ready() -> void:
	if GameManager.has_custom_spawn:
		global_position = GameManager.spawn_position
		GameManager.has_custom_spawn = false  # сбрасываем флаг
		

	# ПОДКЛЮЧЕНИЕ ЗДОРОВЬЯ
	health_component.died.connect(_on_player_died)
	health_component.health_changed.connect(_on_health_changed)

	# ПОДКЛЮЧЕНИЕ КОЛЛАЙДЕРОВ
	combat.attack_started.connect(_on_attack_started)
	combat.attack_finished.connect(_on_attack_finished)
	$Components/CombatComponent/Area_dmg/CollisionShape3D.disabled = false
	$Components/CombatComponent/Area_dmg/CollisionShape3D2.disabled = false
	
	#Музон добавляем в игрока, тк он всегда есть на экране епт
	SoundManager.play_level_music()
	
	
	
# ############################################################
# ЛОГИКА ДЛЯ ВЗАИМОДЕЙСТВИЯ С HealthComponent
# ############################################################
func _on_player_died():
	death = true
	can_move = false
	velocity = Vector3.ZERO
	
	GameManager.save_player(self)
	animation_component.play_death()
	await animation_component.wait_for_death_animation()
	get_tree().change_scene_to_file("res://assets/menus/death_screen.tscn")
	#animation_component.play_death()
	#await animation_component.wait_for_death_animation()
	#respawn()

func _on_heal_timer_timeout():
	health_component.heal(30)

func _on_health_changed(value):
	if progress_bar.size() > 0:
		progress_bar[0].value = value

func take_dmg(dmg):
	health_component.take_damage(dmg)

func respawn():
	if spawn_point == Vector3.ZERO:
		get_tree().reload_current_scene()
		return

	global_position = spawn_point
	health_component.health = health_component.max_health
	death = false
	can_move = true


# ############################################################
# ЛОГИКА ДЛЯ ВЗАИМОДЕЙСТВИЯ С CombatComponent
# ############################################################
func _on_attack_started():
	animation_component.play_attack()
func _on_attack_finished():
	pass


func _physics_process(delta: float) -> void:
	position.z = clamp(position.z, 0, 0)
	if death or not can_move:
		return
	movement.tick(delta)
	
	if Input.is_action_just_pressed("attack"):
		combat.attack()
	if Input.is_action_just_pressed("ui_cancel"):
		print("ESC нажата!")
		var player = get_tree().get_first_node_in_group("player")
		if player:
			GameManager.save_player(player)
		get_tree().change_scene_to_file("res://assets/menus/ingamemenu.tscn")
	if Input.is_action_just_pressed("heal"):
		heal_timer.start()
	
	animation_component.update_animation()
	move_and_slide()


func set_checkpoint(pos):
	spawn_point=pos

func _on_checkpoint_body_entered(body: Node3D) -> void:
	
	set_checkpoint(global_position)
	print("chechkpoint_entered")
