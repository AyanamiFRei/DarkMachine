extends Node3D


@onready var interact_area: Area3D = $InteractArea
@onready var interact_key: Sprite3D = $InteractionKey
var current_item =null
func _ready():
	interact_key.hide()
func _process(_delta: float) -> void:
	
	if current_item !=null and  Input.is_action_just_pressed("interact"):
		
		current_item.interact()
		current_item=null
		
		#var bodies = interact_area.get_overlapping_bodies()
		#print(bodies[0])
		#if interact_area:
			#print("фаыфывавфыаыфвафвыавыа")
		


func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.has_method("interact"):
		interact_key.show()
		current_item=body
		
		
			
	print("зашел в зону")


func _on_interact_area_body_exited(body: Node3D) -> void:
	interact_key.hide()
	if body==current_item:
		current_item=null
	print("вышел из зоны")
	
