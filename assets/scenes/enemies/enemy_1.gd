extends CharacterBody3D

@onready var dmg_timer: Timer = $dmg_timer
var type = "enemy"
const SPEED = 2
const JUMP_VELOCITY = -400.0
var playerNode: CharacterBody3D
var hp = 10
var dmg = 25

var target_point = CharacterBody3D

func set_target_point(target):
	target_point = target

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if playerNode != null:
		var direction = (playerNode.global_position - global_position).normalized()
		velocity.x = direction.x * SPEED
	
	move_and_slide()
	



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("take_dmg") and body.type == "player":
		dmg_timer.start()
		body.take_dmg(dmg)
		playerNode = body


func _on_dmg_timer_timeout() -> void:
	if playerNode:
		playerNode.take_dmg(dmg)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_method("take_dmg") and body.type == "player":
		dmg_timer.stop()
