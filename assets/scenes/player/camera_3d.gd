extends Camera3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	$".".global_position.x = clamp($".".global_position.x, -8, 20)
	#$".".global_position.z = clamp($".".global_position.z, -2, -2)
	$".".global_position.y = clamp($".".global_position.y, -5, 5)
