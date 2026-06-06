extends Node3D

@export var max_health := 100
var health := 100

var hit_sound: AudioStreamPlayer

signal died
signal health_changed

func _ready():
	health = max_health
	
	var hit_file = load("res://assets/enteties/player/audios/hit.wav")
	if hit_file:
		hit_sound = AudioStreamPlayer.new()
		hit_sound.stream = hit_file
		hit_sound.volume_db = -16.0
		add_child(hit_sound)

func take_damage(amount):
	if health <= 0:
		return

	health -= amount
	hit_sound.play()
	health_changed.emit(health)
	

	if health <= 0:
		die()

func heal(amount):
	health = min(health + amount, max_health)
	health_changed.emit(health)

func die():
	died.emit()
	GameManager.save_player(self)
	get_tree().change_scene_to_file("res://deathscene.tscn")
	
func update_healthbar():
	var bars = get_tree().get_nodes_in_group("healthbar")
	if bars.size() > 0:
		bars[0].value = health
	
func _on_health_changed(new_health):
	var bars = get_tree().get_nodes_in_group("healthbar")
	if bars.size() > 0:
		bars[0].value = health
