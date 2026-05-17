extends Node3D

@export var respawn_button: Node3D
@export var menu_button: Node3D

func _ready():
	
	#var player = get_tree().get_first_node_in_group("player")
	#if player:
		#print("fffffffffffffffffffffffffffff")
		#GameManager.save_player(player)
	
	if respawn_button:
		var respawn_area = respawn_button.get_node("Area3D")
		if respawn_area:
			respawn_area.mouse_entered.connect(_on_respawn_mouse_entered)
			respawn_area.mouse_exited.connect(_on_respawn_mouse_exited)
			respawn_area.input_event.connect(_on_respawn_input_event)

	if menu_button:
		var menu_area = menu_button.get_node("Area3D")
		if menu_area:
			menu_area.mouse_entered.connect(_on_menu_mouse_entered)
			menu_area.mouse_exited.connect(_on_menu_mouse_exited)
			menu_area.input_event.connect(_on_menu_input_event)

# ---------- КНОПКА RESPAWN ----------
func _on_respawn_mouse_entered():
	var mesh = $respawn_button/respawn_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	var label = $respawn_button/respawn_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_respawn_mouse_exited():
	var mesh = $respawn_button/respawn_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	var label = $respawn_button/respawn_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_respawn_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mesh = $respawn_button/respawn_button_mesh
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		respawn()

# ---------- КНОПКА MENU ----------
func _on_menu_mouse_entered():
	var mesh = $menu_button/menu_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	var label = $menu_button/menu_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_menu_mouse_exited():
	var mesh = $menu_button/menu_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	var label = $menu_button/menu_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_menu_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mesh = $menu_button/menu_button_mesh
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		return_to_menu()

# ---------- ДЕЙСТВИЯ ----------
func respawn():
	GameManager.coming_from_death = true  # ← ключевой флаг
	GameManager.has_custom_spawn = false  # ← явно сбрасываем ESC-позицию
	if GameManager.has_respawn_point:
		print("[Death] → чекпоинт: ", GameManager.respawn_scene)
		get_tree().change_scene_to_file(GameManager.respawn_scene)
	elif GameManager.has_save():
		print("[Death] → текущий уровень: ", GameManager.current_game_scene)
		get_tree().change_scene_to_file(GameManager.current_game_scene)
	else:
		print("[Death] → room_1 (нет сохранения)")
		get_tree().change_scene_to_file("res://assets/Levels/room_1.tscn")

func return_to_menu():
	get_tree().change_scene_to_file("res://assets/menus/menu.tscn")
