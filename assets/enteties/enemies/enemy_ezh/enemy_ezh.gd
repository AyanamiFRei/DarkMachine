extends CharacterBody3D

@onready var ray_cast_right: RayCast3D = $RayCastRight
@onready var ray_cast_left: RayCast3D = $RayCastLeft
@onready var attack_healthbar_timer: Timer = $attack_healthbar_timer
@onready var progress_bar = get_tree().get_nodes_in_group("healthbar")
@onready var dmg_timer: Timer = $dmg_timer
@onready var gg: CharacterBody3D = $"../player"
@onready var anim: Sprite3D = $Sprite3D
var type = "enemy"
var SPEED = 0.5
const JUMP_VELOCITY = -400.0
var playerNode: CharacterBody3D
var hp = 100
var dmg = 25
var just_hit_player = false
var target_point = CharacterBody3D
#Для отбрасывания {
var knockback_force = 30.0 
var knockback_up = 1.0  
var dir = 1
var push_vector = Vector3(dir * knockback_force, knockback_up, 0)
#}

func set_target_point(target):
	target_point = target

func _physics_process(delta: float) -> void:
	var direction_to_player = gg.global_position.x - global_position.x
	position.z = clamp(position.z, 0, 0)
	#if ray_cast_right.is_colliding():
		#print("право")
	#if ray_cast_left.is_colliding():
		#print("лево")
	if not is_on_floor():
		velocity += get_gravity() * delta
	
		
	var direction = Vector3.LEFT
	velocity.x = direction.x * SPEED*(-1)
	
		
			
		#print(SPEED)
	if just_hit_player:
		SPEED=0
		await get_tree().create_timer(1.0).timeout
		just_hit_player=false
		if direction_to_player>0:
			
			SPEED=-1.3
		if direction_to_player<0:
			
			SPEED=1.3
	
	if (not ray_cast_left.is_colliding()) and (SPEED > 0) :
		
	
		SPEED = SPEED*(-1)
		
	if (not ray_cast_right.is_colliding()) and (SPEED < 0):
		SPEED = SPEED*(-1)
			
		#print(SPEED)
		
			
	
			
		#var direction = (playerNode.global_position - global_position).normalized()
		#velocity.x = direction.x * SPEED
	
	move_and_slide()
	


	if velocity.x > 0:
		anim.flip_h = false
		
		
	elif velocity.x < 0:
		anim.flip_h = true
		
		
func _on_area_3d_body_entered(body) -> void:
	if body.has_method("take_dmg") and body.is_in_group("player"):
		dmg_timer.start()
		body.take_dmg(dmg)
		playerNode = body
		just_hit_player = true
		attack_healthbar_timer.start()
		if body.global_position.x > global_position.x:
			dir=1
		else:
			dir=-1
		if "velocity" in body:
			if body is CharacterBody3D:
				body.velocity = push_vector 
				
				
				body.move_and_slide() 
	
		


func _on_dmg_timer_timeout() -> void:
	if playerNode:
		playerNode.take_dmg(dmg)
		


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_method("take_dmg") and body.type == "player":
		dmg_timer.stop()
	
		
	#if direction_to_player > 0:
		#print("лево")
	#if direction_to_player > 0:
		#print("право")
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
