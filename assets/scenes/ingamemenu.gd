extends Node3D

# Ссылки на кнопки (перетащим их в инспекторе)
@export var continue_button: Node3D
@export var exit_button: Node3D
@export var verify_button: Node3D
@export var verify_button2: Node3D

func _ready():
	# Подключаем сигналы для кнопки Play
	if continue_button:
		var continue_area = continue_button.get_node("Area3D")
		if continue_area:
			continue_area.mouse_entered.connect(_on_play_mouse_entered)
			continue_area.mouse_exited.connect(_on_play_mouse_exited)
			continue_area.input_event.connect(_on_play_input_event)
	
	# Подключаем сигналы для кнопки Exit
	if exit_button:
		var exit_area = exit_button.get_node("Area3D")
		if exit_area:
			exit_area.mouse_entered.connect(_on_exit_mouse_entered)
			exit_area.mouse_exited.connect(_on_exit_mouse_exited)
			exit_area.input_event.connect(_on_exit_input_event)

# ---------- КНОПКА PLAY ----------
func _on_play_mouse_entered():
	# Навели курсор на Play
	print("Курсор на Play")
	
	# Увеличиваем кнопку
	var mesh = continue_button.get_node("MeshInstance3D")
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	# Меняем цвет текста на желтый
	var label = continue_button.get_node("Label3D")
	if label:
		label.modulate = Color.YELLOW

func _on_play_mouse_exited():
	# Убрали курсор с Play
	print("Курсор ушел с Play")
	
	# Возвращаем размер
	var mesh = continue_button.get_node("MeshInstance3D")
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	# Возвращаем цвет текста на белый
	var label = continue_button.get_node("Label3D")
	if label:
		label.modulate = Color.WHITE

func _on_play_input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	# Проверяем клик левой кнопкой мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по continue!")
		
		# Анимация нажатия (кнопка уходит вниз и возвращается)
		var mesh = continue_button.get_node("MeshInstance3D")
		if mesh:
			# Запоминаем позицию
			var original_y = mesh.position.y
			# Сдвигаем вниз
			mesh.position.y = original_y - 0.2
			# Ждем 0.1 секунды
			await get_tree().create_timer(0.1).timeout
			# Возвращаем обратно
			mesh.position.y = original_y
		
		# Запускаем игру
		start_game()

# ---------- КНОПКА EXIT ----------
func _on_exit_mouse_entered():
	# Навели курсор на Exit
	print("Курсор на Exit")
	
	var mesh = exit_button.get_node("MeshInstance3D")
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	var label = exit_button.get_node("Label3D")
	if label:
		label.modulate = Color.YELLOW

func _on_exit_mouse_exited():
	# Убрали курсор с Exit
	print("Курсор ушел с Exit")
	
	var mesh = exit_button.get_node("MeshInstance3D")
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	var label = exit_button.get_node("Label3D")
	if label:
		label.modulate = Color.WHITE

func _on_exit_input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по Exit!")
		
		# Анимация нажатия
		var mesh = exit_button.get_node("MeshInstance3D")
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		
		# Выходим из игры
		return_to_menu()

# ---------- КНОПКА verify ----------
func _on_verify_mouse_entered():
	# Навели курсор на Exit
	print("Курсор на verify")
	
	var mesh = exit_button.get_node("MeshInstance3D")
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	var label = exit_button.get_node("Label3D")
	if label:
		label.modulate = Color.YELLOW

func _on_verify_mouse_exited():
	# Убрали курсор с Exit
	print("Курсор ушел с verify")
	
	var mesh = exit_button.get_node("MeshInstance3D")
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	var label = exit_button.get_node("Label3D")
	if label:
		label.modulate = Color.WHITE

func _on_verify_input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по verify!")
		
		# Анимация нажатия
		var mesh = exit_button.get_node("MeshInstance3D")
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		
		# Выходим из игры
		verify()

# ---------- КНОПКА verify2 ----------
func _on_verify2_mouse_entered():
	# Навели курсор на Exit
	print("Курсор на verify")
	
	var mesh = verify_button.get_node("MeshInstance3D")
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	var label = verify_button.get_node("Label3D")
	if label:
		label.modulate = Color.YELLOW

func _on_verify2_mouse_exited():
	# Убрали курсор с Exit
	print("Курсор ушел с verify")
	
	var mesh = verify_button.get_node("MeshInstance3D")
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	var label = verify_button.get_node("Label3D")
	if label:
		label.modulate = Color.WHITE

func _on_verify2_input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по verify!")
		
		# Анимация нажатия
		var mesh = verify_button.get_node("MeshInstance3D")
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		
		# Выходим из игры
		verify2()


# ---------- ДЕЙСТВИЯ ----------
func start_game():
	print("ЗАПУСК ИГРЫ!")
	get_tree().change_scene_to_file("res://main.tscn")
func return_to_menu():
	print("ПЕРЕХОД В МЕНЮ!")
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")
	
func verify():
	print("VERIFYING!")
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")
	
func verify2():
	print("VERIFYING2!")
	get_tree().quit()
	
