extends StaticBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var area: Area3D = $Area3D
@onready var dmg_timer: Timer = $dmg_timer
@onready var active_timer: Timer = $active_timer
@onready var inactive_timer: Timer = $inactive_timer

var is_active := false
var playerNode: Node3D = null

var dmg := 25
var damage_interval := 1.0
var knockback_force := 50.0
var knockback_up := 2.0

var steam_sounds = "res://assets/audios/sfx/steam.wav"

# дистаниция ожидания
@export var activation_distance := 15.0 

func _ready():
	_set_steam_state(false)
	dmg_timer.wait_time = damage_interval
	inactive_timer.start()

func _on_inactive_timer_timeout():
	var player = get_tree().get_first_node_in_group("player")
	
	# если игрок далеко,ждем еще один цикл
	if player and global_position.distance_to(player.global_position) > activation_distance:
		inactive_timer.start() 
		return
	_set_steam_state(true)
	active_timer.start()
	SoundManager.play_sfx(steam_sounds)

func _on_active_timer_timeout():
	_set_steam_state(false)
	inactive_timer.start()

func _set_steam_state(active: bool):
	is_active = active
	mesh.visible = active
	area.set_deferred("monitoring", active)
	if not active:
		playerNode = null
		dmg_timer.stop()

func _on_area_3d_body_entered(body):
	if is_active and body.is_in_group("player") and body.has_method("take_dmg"):
		playerNode = body
		_damage_player()
		dmg_timer.start()

func _on_area_3d_body_exited(body):
	if body == playerNode:
		playerNode = null
		dmg_timer.stop()

func _on_dmg_timer_timeout():
	if is_active and is_instance_valid(playerNode):
		_damage_player()
	else:
		dmg_timer.stop()

func _damage_player():
	if not is_instance_valid(playerNode):
		return

	var dir := 1
	if playerNode.global_position.x < global_position.x:
		dir = -1

	var push_vector := Vector3(dir * knockback_force, knockback_up, 0)
	if playerNode is CharacterBody3D:
		playerNode.velocity = push_vector

	playerNode.take_dmg(dmg)
