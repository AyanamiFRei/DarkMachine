extends Node3D
@onready var player: CharacterBody3D = $"../.."
@onready var anim: AnimatedSprite3D = $"../../Visual/AnimatedSprite3D/StockModel"
@onready var right_hitbox: CollisionShape3D = $"../CombatComponent/Area_dmg/CollisionShape3D"
@onready var left_hitbox: CollisionShape3D = $"../CombatComponent/Area_dmg/CollisionShape3D2"

var is_attacking = false
var is_dead := false

func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	if anim.animation == "attack1":
		is_attacking = false

func update_animation() -> void:
	if is_dead:
		return
	if is_attacking:
		return
	
	var input_dir := Input.get_axis("ui_left", "ui_right")
	if input_dir > 0:
		anim.flip_h = false
		right_hitbox.disabled = true
		left_hitbox.disabled = false
	elif input_dir < 0:
		anim.flip_h = true
		right_hitbox.disabled = false
		left_hitbox.disabled = true

	if not player.is_on_floor():
		if player.velocity.y > 0:
			anim.play("jump")
		else:
			anim.play("fall")
	elif player.velocity.x != 0:
		anim.play("run")
	else:
		anim.play("idle")

func play_attack():
	is_attacking = true
	anim.play("attack1")
func stop_attack():
	is_attacking = false

func play_death() -> void:
	is_dead = true
	anim.play("death")
func wait_for_death_animation() -> void:
	await anim.animation_finished
