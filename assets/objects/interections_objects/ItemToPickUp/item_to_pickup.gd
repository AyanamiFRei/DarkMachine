extends StaticBody3D

@export var item_id: String = "blue_crystal"
@export var item_name: String = "Синий кристалл"
@export_multiline var description: String = "Красивый синий кристалл."
@export var icon: Texture2D

func interact():
	GameManager.add_item({
		"id": item_id,
		"name": item_name,
		"description": description,
		"icon": icon
	})

	queue_free()
