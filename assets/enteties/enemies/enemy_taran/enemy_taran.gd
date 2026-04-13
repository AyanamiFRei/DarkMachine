extends CharacterBody3D

var agr = false
var is_cycling = false
var direction = 1
@onready var playerNode: CharacterBody3D = $"../player"
@onready var dmg_timer: Timer = $dmg_timer
@onready var anim: AnimatedSprite3D = $AnimatedSprite3D
var SPEED = 6.0 # Скорость рывка
var hp = 200
var dmg = 25
var current_velocity_x = 0.0
var type = "enemy"
#Для отбрасывания {
var knockback_force = 50.0 
var knockback_up = 2.0  
var dir = 1
var push_vector = Vector3(dir * knockback_force, knockback_up, 0)
#}
func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	

	velocity.x = current_velocity_x
	move_and_slide()


	if agr and not is_cycling:
		start_attack_cycle()

func start_attack_cycle():
	is_cycling = true
	

	while agr and is_inside_tree():
		

		print("Разгон...")
		current_velocity_x = 0
		

		if playerNode.global_position.x > global_position.x:
			anim.flip_h = false
			direction = 1 
		else:
			anim.flip_h = true
			direction=-1
		
		
		if not is_inside_tree(): break
		await get_tree().create_timer(1.0).timeout
		
		
		if not is_inside_tree() or not agr: break

		
		print("Рывок!")
		current_velocity_x = direction * SPEED
		
		
		if not is_inside_tree(): break
		var dash_timer = get_tree().create_timer(2.0)
		
	
		while is_inside_tree() and dash_timer.time_left > 0:
			if current_velocity_x == 0: 
				break
			await get_tree().process_frame
		
		if not is_inside_tree(): break

	
		print("Отдых...")
		current_velocity_x = 0
		
		if not is_inside_tree(): break
		await get_tree().create_timer(2.0).timeout
		
		if not is_inside_tree(): break
		print("--- Цикл завершен, перезапуск ---")


func _on_area_3d_2_body_entered(body) -> void:
	if body.is_in_group("player"):
		agr = true


func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_dmg"):
			body.take_dmg(dmg)
		
		if body.global_position.x > global_position.x:
			dir=1
		else:
			dir=-1
		if "velocity" in body:
			if body is CharacterBody3D:
				body.velocity = push_vector 
				
				
				body.move_and_slide() 
		current_velocity_x = 0

func take_dmg(amount):
	hp -= amount

	
	if hp <= 0:
		agr = false
		is_cycling = false
		
		queue_free()


func _on_dmg_timer_timeout() -> void:
	if playerNode:
		playerNode.take_dmg(dmg)
