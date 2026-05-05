
extends CharacterBody3D


@onready var attack_healthbar_timer: Timer = $attack_healthbar_timer
@onready var progress_bar = get_tree().get_nodes_in_group("healthbar")
@onready var dmg_timer: Timer = $dmg_timer

var type = "enemy"


var playerNode: CharacterBody3D
var hp = 150

var just_hit_player = false
var target_point = CharacterBody3D

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
