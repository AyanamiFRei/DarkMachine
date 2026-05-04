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


func _ready():
	mesh.visible = false
	area.monitoring = false

	dmg_timer.wait_time = damage_interval
	dmg_timer.one_shot = false

	# стартуем с выключенного состояния
	inactive_timer.start()



func _on_inactive_timer_timeout():
	is_active = true
	mesh.visible = true
	area.monitoring = true

	active_timer.start()



func _on_active_timer_timeout():
	is_active = false
	mesh.visible = false
	area.monitoring = false
	dmg_timer.stop()

	active_timer.stop()
	inactive_timer.start()


func _on_area_3d_body_entered(body):
	if not is_active:
		return

	if not body.has_method("take_dmg"):
		return

	if not body.is_in_group("player"):
		return

	playerNode = body
	_damage_player()
	dmg_timer.start()


func _on_area_3d_body_exited(body):
	if body == playerNode:
		playerNode = null
		dmg_timer.stop()


func _on_dmg_timer_timeout():
	if is_active and playerNode:
		_damage_player()


func _damage_player():
	if not is_instance_valid(playerNode):
		playerNode = null
		dmg_timer.stop()
		return

	var dir := 1
	if playerNode.global_position.x < global_position.x:
		dir = -1

	var push_vector := Vector3(dir * knockback_force, knockback_up, 0)

	if playerNode is CharacterBody3D:
		playerNode.velocity = push_vector

	playerNode.take_dmg(dmg)
