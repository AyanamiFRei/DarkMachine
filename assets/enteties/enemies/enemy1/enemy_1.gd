extends CharacterBody3D


@onready var attack_healthbar_timer: Timer = $attack_healthbar_timer
@onready var progress_bar = get_tree().get_nodes_in_group("healthbar")
@onready var dmg_timer: Timer = $dmg_timer
@onready var anim: AnimatedSprite3D = $AnimatedSprite3D
var type = "enemy"
const SPEED = 0.5
const JUMP_VELOCITY = -400.0
var playerNode: CharacterBody3D
var hp = 100
var dmg = 25

var target_point = CharacterBody3D 

func _ready() -> void:
	anim.play("idle")

func set_target_point(target):
	target_point = target
	
func _on_area_3d_2_body_entered(body) -> void:
	print(",kzzz")
	if body.is_in_group("player"):
		playerNode = body
		var direction = (playerNode.global_position - global_position).normalized()
		velocity.x = direction.x * SPEED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if playerNode != null:
		var direction = (playerNode.global_position - global_position).normalized()
		velocity.x = direction.x * SPEED
		
	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true
	
	move_and_slide()
	



func _on_area_3d_body_entered(body) -> void:
	if body.has_method("take_dmg") and body.is_in_group("player"):
		dmg_timer.start()
		body.take_dmg(dmg)
		playerNode = body
		attack_healthbar_timer.start()
		


func _on_dmg_timer_timeout() -> void:
	if playerNode:
		playerNode.take_dmg(dmg)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_method("take_dmg") and body.type == "player":
		dmg_timer.stop()
		
func take_dmg(dmg):
	hp -= dmg
	#var mesh = $MeshInstance3D
	#if mesh:
		#
	if hp <=0:
		queue_free()


#func _on_attack_healthbar_timer_timeout() -> void:
	#if progress_bar.size() > 0:
		#progress_bar[0].value -= 25


func _on_attack_healthbar_timer_timeout() -> void:
	pass # Replace with function body.
