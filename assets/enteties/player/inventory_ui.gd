extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var hp_label: Label = $Panel/HPLabel
@onready var money_label: Label = $Panel/MoneyLabel
@onready var items_grid: GridContainer = $Panel/ItemGrid
@onready var description_label: Label = $Panel/DescriptionLabel

var player: Node = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false
	description_label.text = ""


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()

	if Input.is_action_just_pressed("ui_cancel"):
		open_pause_menu()


func toggle_inventory() -> void:
	panel.visible = !panel.visible

	if panel.visible:
		get_tree().paused = true
		update_inventory()
	else:
		get_tree().paused = false
		description_label.text = ""


func update_inventory() -> void:
	player = get_tree().get_first_node_in_group("player")

	if player and player.has_node("Components/HealthComponent"):
		var hp = player.get_node("Components/HealthComponent")
		hp_label.text = "HP: " + str(hp.health) + " / " + str(hp.max_health)
	else:
		hp_label.text = "HP: ?"

	money_label.text = "Валюта: " + str(GameManager.money)

	for child in items_grid.get_children():
		child.queue_free()

	for item in GameManager.inventory_items:
		var button := TextureButton.new()

		button.texture_normal = item.icon
		button.ignore_texture_size = true
		button.custom_minimum_size = Vector2(200, 200)
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED

		button.mouse_entered.connect(func():
			description_label.text = item.name + "\n\n" + item.description + "\nКоличество: " + str(item.count)
		)

		button.mouse_exited.connect(func():
			description_label.text = ""
		)

		items_grid.add_child(button)


func open_pause_menu() -> void:
	get_tree().paused = false

	var found_player = get_tree().get_first_node_in_group("player")
	if found_player:
		GameManager.save_player(found_player)

	get_tree().change_scene_to_file("res://assets/menus/ingamemenu.tscn")
