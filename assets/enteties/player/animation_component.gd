extends Node3D

@onready var player: CharacterBody3D = $"../.."
@onready var anim: AnimatedSprite3D = $"../../Visual/AnimatedSprite3D/StockModel"
@onready var right_hitbox: CollisionShape3D = $"../CombatComponent/Area_dmg/CollisionShape3D"
@onready var left_hitbox: CollisionShape3D = $"../CombatComponent/Area_dmg/CollisionShape3D2"
@onready var movement = $"../MovementComponent"

var is_attacking := false
var is_dead := false
var crawl_offset := 100
var default_offset := 0

func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)

	movement.ledge_grab_started.connect(_on_ledge_grab_started)
	movement.ledge_hold_started.connect(_on_ledge_hold_started)
	movement.ledge_climb_started.connect(_on_ledge_climb_started)


func _on_animation_finished() -> void:
	if anim.animation == "attack1":
		is_attacking = false

	elif anim.animation == "grabs ledge":
		movement.finish_ledge_grab()

	elif anim.animation == "pulls on ledge":
		movement.finish_ledge_climb()


func update_animation() -> void:
	if is_dead:
		return

	if is_attacking:
		return

	if movement.ledge_state == "climbing":
		return

	if movement.is_hanging:
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
		return

	if movement.is_crouching:
		anim.offset.y = crawl_offset
		anim.play("crawl")
		return
	else:
		anim.offset.y = default_offset

	if abs(player.velocity.x) > 0.05:
		anim.play("run")
	else:
		anim.play("idle")


func _on_ledge_grab_started() -> void:
	is_attacking = false
	if anim.animation != "grabs ledge":
		anim.play("grabs ledge")


func _on_ledge_hold_started() -> void:
	if anim.animation != "holds on ledge":
		anim.play("holds on ledge")


func _on_ledge_climb_started() -> void:
	if anim.animation != "pulls on ledge":
		anim.play("pulls on ledge")


func play_attack() -> void:
	if movement.is_hanging:
		return

	if movement.is_crouching:
		return

	is_attacking = true
	anim.play("attack1")


func stop_attack() -> void:
	is_attacking = false


func play_death() -> void:
	is_dead = true
	anim.play("death")


func wait_for_death_animation() -> void:
	await anim.animation_finished
