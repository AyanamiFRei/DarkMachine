extends Node3D

func _ready():
	# Рекурсивно обойдём всех детей в сцене
	for child in get_tree().get_nodes_in_group("csg_blocks"):
		if child is CSGShape3D and child.use_collision:
			child.collision_layer = child.collision_layer
