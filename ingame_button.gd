extends Node3D
#@export var menu_button: Node3D
#func _ready():
	## Подключаем сигналы для кнопки menu
	#if menu_button:
		#var menu_area = menu_button.get_node("Area3D")
		#if menu_area:
			#menu_area.mouse_entered.connect(_on_menu_mouse_entered)
			#menu_area.mouse_exited.connect(_on_menu_mouse_exited)
			#menu_area.input_event.connect(_on_menu_input_event)
		#self.visible = false
#
#
## ---------- КНОПКА menu ----------
#func _on_menu_mouse_entered():
	## Навели курсор на menu
	#print("Курсор на menu")
#
	## Увеличиваем кнопку
	#var mesh = $MeshInstance3D
	#if mesh:
		#mesh.scale = Vector3(1.2, 1.2, 1.2)
#
	## Меняем цвет текста на желтый
	#var label = $MeshInstance3D/Label3D
	#if label:
		#label.modulate = Color.YELLOW
#func _on_menu_mouse_exited():
	## Убрали курсор с menu
	#print("Курсор ушел с menu")
#
	## Возвращаем размер
	#var mesh = $MeshInstance3D
	#if mesh:
		#mesh.scale = Vector3(1.0, 1.0, 1.0)
#
	## Возвращаем цвет текста на белый
	#var label = $MeshInstance3D/Label3D
	#if label:
		#label.modulate = Color.WHITE
#func _on_menu_input_event(_camera: Camera3D, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	## Проверяем клик левой кнопкой мыши
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#print("Клик по menu!")
#
		## Анимация нажатия (кнопка уходит вниз и возвращается)
		#var mesh = $MeshInstance3D
		#if mesh:
			## Запоминаем позицию
			#var original_y = mesh.position.y
			## Сдвигаем вниз
			#mesh.position.y = original_y - 0.2
			## Ждем 0.1 секунды
			#await get_tree().create_timer(0.1).timeout
			## Возвращаем обратно
			#mesh.position.y = original_y
#
		## Запускаем игру
		#_menu()
#
#func _menu():
	#get_tree().change_scene_to_file("res://assets/scenes/ingamemenu.tscn")
##Спрятать кнопку
#func hide_button():
	#self.visible = false
## Показать кнопку 
#func show_button():
	#print("fff")
	#self.visible = true
