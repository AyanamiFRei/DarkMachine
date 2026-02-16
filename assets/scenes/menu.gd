extends Node3D

# Ссылки на кнопки (перетащим их в инспекторе)
@export var play_button: Node3D
@export var exit_button: Node3D

func _ready():
	
	# Подключаем сигналы для кнопки Play
	if play_button:
		var play_area = play_button.get_node("Area3D")
		if play_area:
			play_area.mouse_entered.connect(_on_play_mouse_entered)
			play_area.mouse_exited.connect(_on_play_mouse_exited)
			play_area.input_event.connect(_on_play_input_event)
	
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
	var mesh = $Play_button/play_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	# Меняем цвет текста на желтый
	var label = $Play_button/play_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_play_mouse_exited():
	# Убрали курсор с Play
	print("Курсор ушел с Play")
	
	# Возвращаем размер
	var mesh = $Play_button/play_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	# Возвращаем цвет текста на белый
	var label = $Play_button/play_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_play_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	# Проверяем клик левой кнопкой мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по Play!")
		
		# Анимация нажатия (кнопка уходит вниз и возвращается)
		var mesh = $Play_button/play_button_mesh
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
	
	var mesh = $Exit_button/exit_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	var label = $Exit_button/exit_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_exit_mouse_exited():
	# Убрали курсор с Exit
	print("Курсор ушел с Exit")
	
	var mesh = $Exit_button/exit_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	var label = $Exit_button/exit_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_exit_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по Exit!")
		
		# Анимация нажатия
		var mesh = $Exit_button/exit_button_mesh
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		
		# Выходим из игры
		quit_game()

# ---------- ДЕЙСТВИЯ ----------
func start_game():
	print("ЗАПУСК ИГРЫ!")
	get_tree().change_scene_to_file("res://main.tscn")
func quit_game():
	print("ВЫХОД ИЗ ИГРЫ!")
	get_tree().quit()
