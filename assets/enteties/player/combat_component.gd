extends Node
@onready var area_dmg: Area3D = $Area_dmg
@onready var cooldown_timer: Timer = $Timers/Attack_CoolDown_Timer

var can_attack = true
var dmg = 50

var attack_sound =["res://assets/enteties/player/audios/attack1.wav",
					"res://assets/enteties/player/audios/attack2.wav",
					"res://assets/enteties/player/audios/attack3.wav",
					"res://assets/enteties/player/audios/attack4.wav",
]
signal attack_started
signal attack_finished

func attack():
	if not can_attack:
		return
	can_attack = false
	attack_started.emit()
	attack_action()
	cooldown_timer.start()
	SoundManager.play_sfx(attack_sound, -10)

func attack_action():
	var overlapping_bodies = area_dmg.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.has_method("take_dmg") and body.type == "enemy":
			body.take_dmg(dmg)

func _on_attack_cool_down_timer_timeout():
	can_attack = true
	attack_finished.emit()
	
func _ready():
	cooldown_timer.timeout.connect(_on_attack_cool_down_timer_timeout)
