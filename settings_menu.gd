extends Node3D

@export var volumeup_button: Node3D
@export var volumedown_button: Node3D
@export var display_button: Node3D
@export var menu_button: Node3D

var master_vol = 1.0
const SAVE_PATH = "user://settings.cfg"

func _ready():
	load_settings()

	if volumeup_button:
		var area = volumeup_button.get_node("Area3D")
		if area:
			area.mouse_entered.connect(_on_volumeup_mouse_entered)
			area.mouse_exited.connect(_on_volumeup_mouse_exited)
			area.input_event.connect(_on_volumeup_input_event)

	if volumedown_button:
		var area = volumedown_button.get_node("Area3D")
		if area:
			area.mouse_entered.connect(_on_volumedown_mouse_entered)
			area.mouse_exited.connect(_on_volumedown_mouse_exited)
			area.input_event.connect(_on_volumedown_input_event)

	if display_button:
		var area = display_button.get_node("Area3D")
		if area:
			area.mouse_entered.connect(_on_display_mouse_entered)
			area.mouse_exited.connect(_on_display_mouse_exited)
			area.input_event.connect(_on_display_input_event)

	if menu_button:
		var area = menu_button.get_node("Area3D")
		if area:
			area.mouse_entered.connect(_on_menu_mouse_entered)
			area.mouse_exited.connect(_on_menu_mouse_exited)
			area.input_event.connect(_on_menu_input_event)

# ---------- КНОПКА volumeup ----------
func _on_volumeup_mouse_entered():
	var mesh = $volumeup_button/volumeup_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	var label = $volumeup_button/volumeup_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_volumeup_mouse_exited():
	var mesh = $volumeup_button/volumeup_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	var label = $volumeup_button/volumeup_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_volumeup_input_event(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mesh = $volumeup_button/volumeup_button_mesh
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		volume_up()

# ---------- КНОПКА volumedown ----------
func _on_volumedown_mouse_entered():
	var mesh = $volumedown_button/volumedown_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	var label = $volumedown_button/volumedown_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_volumedown_mouse_exited():
	var mesh = $volumedown_button/volumedown_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	var label = $volumedown_button/volumedown_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_volumedown_input_event(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mesh = $volumedown_button/volumedown_button_mesh
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		volume_down()

# ---------- КНОПКА display ----------
func _on_display_mouse_entered():
	var mesh = $display_button/display_button_mesh
	if mesh:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
	var label = $display_button/display_button_mesh/Label3D
	if label:
		label.modulate = Color.YELLOW

func _on_display_mouse_exited():
	var mesh = $display_button/display_button_mesh
	if mesh:
		mesh.scale = Vector3(1.0, 1.0, 1.0)
	var label = $display_button/display_button_mesh/Label3D
	if label:
		label.modulate = Color.WHITE

func _on_display_input_event(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mesh = $display_button/display_button_mesh
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		toggle_fullscreen()

# ---------- КНОПКА menu ----------
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

func _on_menu_input_event(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mesh = $menu_button/menu_button_mesh
		if mesh:
			var original_y = mesh.position.y
			mesh.position.y = original_y - 0.2
			await get_tree().create_timer(0.1).timeout
			mesh.position.y = original_y
		save_settings()
		return_to_menu()

# ---------- ДЕЙСТВИЯ ----------
func volume_up():
	master_vol = clamp(master_vol + 0.1, 0.0, 1.0)
	_apply_volume()

func volume_down():
	master_vol = clamp(master_vol - 0.1, 0.0, 1.0)
	_apply_volume()

func _apply_volume():
	var idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(idx, linear_to_db(master_vol))
	# показываем % на кнопках
	var label_up = $volumeup_button/volumeup_button_mesh/Label3D
	if label_up:
		label_up.text = "+ %d%%" % int(master_vol * 100)
	var label_down = $volumedown_button/volumedown_button_mesh/Label3D
	if label_down:
		label_down.text = "- %d%%" % int(master_vol * 100)

func toggle_fullscreen():
	var label = $display_button/display_button_mesh/Label3D
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		if label:
			label.text = "Fullscreen: OFF"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if label:
			label.text = "Fullscreen: ON"

func save_settings():
	var cfg = ConfigFile.new()
	cfg.set_value("audio", "master", master_vol)
	cfg.set_value("display", "fullscreen", DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	cfg.save(SAVE_PATH)

func load_settings():
	var cfg = ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	master_vol = cfg.get_value("audio", "master", 1.0)
	var is_fullscreen = cfg.get_value("display", "fullscreen", false)
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_apply_volume()

func return_to_menu():
	get_tree().change_scene_to_file("res://assets/menus/menu.tscn")
