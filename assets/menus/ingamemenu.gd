extends Node3D

# Ссылки на кнопки (перетащим их в инспекторе)
@export var continue_button: Node3D
@export var exit_button: Node3D
@export var verify_button: Node3D
@export var verify_button2: Node3D
@onready var happy: Sprite3D = $Sprite3D2
@onready var unhappy: Sprite3D = $Sprite3D



func _ready():
	happy.visible = false
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		print("fffffffffffffffffffffffffffff")
		GameManager.save_player(player)
	
	# Подключаем сигналы для кнопки Play
	if continue_button:
		var continue_area = continue_button.get_node("Area3D")
		if continue_area:
			continue_area.mouse_entered.connect(_on_continue_mouse_entered)
			continue_area.mouse_exited.connect(_on_continue_mouse_exited)
			continue_area.input_event.connect(_on_continue_input_event)
	
	# Подключаем сигналы для кнопки Exit
	if exit_button:
		var exit_area = exit_button.get_node("Area3D")
		if exit_area:
			exit_area.mouse_entered.connect(_on_exit_mouse_entered)
			exit_area.mouse_exited.connect(_on_exit_mouse_exited)
			exit_area.input_event.connect(_on_exit_input_event)
	
	# Подключаем сигналы для кнопки verify
	if verify_button:
		verify_button.scale = Vector3.ZERO
		verify_button.visible = false
		var verify_area = verify_button.get_node("Area3D")
		if verify_area:
			verify_area.mouse_entered.connect(_on_verify_mouse_entered)
			verify_area.mouse_exited.connect(_on_verify_mouse_exited)
			verify_area.input_event.connect(_on_verify_input_event)
	
	# ясен ... зачем код ниже
	if verify_button2:
		verify_button2.scale = Vector3.ZERO
		verify_button2.visible = false
		var verify2_area = verify_button2.get_node("Area3D")
		if verify2_area:
			verify2_area.mouse_entered.connect(_on_verify2_mouse_entered)
			verify2_area.mouse_exited.connect(_on_verify2_mouse_exited)
			verify2_area.input_event.connect(_on_verify2_input_event)

# ---------- КНОПКА continue ----------
func _on_continue_mouse_entered():
	# Навели курсор на continue
	print("Курсор на continue")
	
	# Увеличиваем кнопку
	var mesh = $Continue_button/continue_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	# Меняем цвет текста на желтый
	var label = $Continue_button/continue_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_continue_mouse_exited():
	# Убрали курсор с continue
	print("Курсор ушел с continue")
	
	# Возвращаем размер
	var mesh = $Continue_button/continue_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	# Возвращаем цвет текста на белый
	var label = $Continue_button/continue_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_continue_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	# Проверяем клик левой кнопкой мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по continue!")
		
		# Анимация нажатия (кнопка уходит вниз и возвращается)
		var mesh = $Continue_button/continue_button_mesh
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
		_continue()

# ---------- КНОПКА EXIT ----------
func _on_exit_mouse_entered():
	# Навели курсор на exit
	print("Курсор на exit")
	
	# Увеличиваем кнопку
	var mesh = $Exit_button/exit_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	# Меняем цвет текста на желтый
	var label = $Exit_button/exit_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_exit_mouse_exited():
	# Убрали курсор с exit
	print("Курсор ушел с exit")
	
	# Возвращаем размер
	var mesh = $Exit_button/exit_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	# Возвращаем цвет текста на белый
	var label = $Exit_button/exit_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_exit_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	# Проверяем клик левой кнопкой мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по exit!")
		
		# Анимация нажатия (кнопка уходит вниз и возвращается)
		var mesh = $Exit_button/exit_button_mesh
		if mesh:
			# Запоминаем позицию
			var original_y = mesh.position.y
			# Сдвигаем вниз
			mesh.position.y = original_y - 0.2
			# Ждем 0.1 секунды
			await get_tree().create_timer(0.1).timeout
			# Возвращаем обратно
			mesh.position.y = original_y
		
		# Выход из игры
		return_to_menu()

# ---------- КНОПКА verify ----------

func _on_verify_mouse_entered():
	# Навели курсор на verify
	print("Курсор на verify")
	
	# Увеличиваем кнопку
	var mesh = $verify_button/verify_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	# Меняем цвет текста на желтый
	var label = $verify_button/verify_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW
	if happy:
		happy.visible = true
		

func _on_verify_mouse_exited():
	# Убрали курсор с verify
	print("Курсор ушел с verify")
	
	# Возвращаем размер
	var mesh = $verify_button/verify_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	# Возвращаем цвет текста на белый
	var label = $verify_button/verify_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE
		
	if happy:
		happy.visible = false

func _on_verify_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	# Проверяем клик левой кнопкой мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по verify!")
		
		# Анимация нажатия (кнопка уходит вниз и возвращается)
		var mesh = $verify_button/verify_button_mesh
		if mesh:
			# Запоминаем позицию
			var original_y = mesh.position.y
			# Сдвигаем вниз
			mesh.position.y = original_y - 0.2
			# Ждем 0.1 секунды
			await get_tree().create_timer(0.1).timeout
			# Возвращаем обратно
			mesh.position.y = original_y
		
		# Выход из игры
		verify()
		
# ---------- КНОПКА verify2 ----------

func _on_verify2_mouse_entered():
	# Навели курсор на verify
	print("Курсор на verify2")
	
	# Увеличиваем кнопку
	var mesh = $verify_button2/verify2_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	
	# Меняем цвет текста на желтый
	var label = $verify_button2/verify2_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW
	
	if unhappy:
		unhappy.visible = true

func _on_verify2_mouse_exited():
	# Убрали курсор с verify
	print("Курсор ушел с verify2")
	
	# Возвращаем размер
	var mesh = $verify_button2/verify2_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	# Возвращаем цвет текста на белый
	var label = $verify_button2/verify2_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE
		
	if unhappy:
		unhappy.visible = false

func _on_verify2_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	# Проверяем клик левой кнопкой мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по verify2!")
		
		# Анимация нажатия (кнопка уходит вниз и возвращается)
		var mesh = $verify_button2/verify2_button_mesh
		if mesh:
			# Запоминаем позицию
			var original_y = mesh.position.y
			# Сдвигаем вниз
			mesh.position.y = original_y - 0.2
			# Ждем 0.1 секунды
			await get_tree().create_timer(0.1).timeout
			# Возвращаем обратно
			mesh.position.y = original_y
		
		# Выход из игры
		verify2()



# ---------- ДЕЙСТВИЯ ----------
func _continue():
	if GameManager.has_save():
		get_tree().change_scene_to_file(GameManager.saved_scene)
	else:
		get_tree().change_scene_to_file("res://assets/Levels/room_1.tscn")


func return_to_menu():
	print("ПЕРЕХОД В МЕНЮ!")
	show_secret_button()
	#get_tree().change_scene_to_file("res://assets/scenes/menu.tscn")


func verify():
	print("VERIFYING!")
	get_tree().change_scene_to_file("res://assets/menus/menu.tscn")


func verify2():
	print("VERIFYING2!")
	get_tree().quit()
	
func show_secret_button():
	hide_button()
	if verify_button:
		verify_button.visible = true
		
		# Анимация появления с эффектом пружинки
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(verify_button, "scale", Vector3(1, 1, 1), 1.0).from(Vector3.ZERO)
		
		# Добавляем свечение
		var label = $verify_button/verify_button_mesh/Label3D
		if label:
			tween.parallel().tween_property(label, "modulate", Color.YELLOW, 0.5).from(Color.TRANSPARENT)
	if verify_button2:
		verify_button2.visible = true
		
		# Анимация появления с эффектом пружинки
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(verify_button2, "scale", Vector3(1, 1, 1), 1.0).from(Vector3.ZERO)
		
		# Добавляем свечение
		var label = $verify_button2/verify2_button_mesh/Label3D
		if label:
			tween.parallel().tween_property(label, "modulate", Color.YELLOW, 0.5).from(Color.TRANSPARENT)


func hide_button():
	$Continue_button.visible = false
	$Exit_button.visible = false

# Показать кнопку (пока что не нужно)
#func show_button():
	#$Continue_button.visible = true
	#$Exit_button.visible = true
