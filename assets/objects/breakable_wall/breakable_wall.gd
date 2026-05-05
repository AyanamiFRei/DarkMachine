
extends CharacterBody3D
var type = "enemy"
var hp = 150
func take_dmg(dmg):
	hp -= dmg
	#var mesh = $MeshInstance3D
	#if mesh:
		#
	if hp <=0:
		queue_free()
