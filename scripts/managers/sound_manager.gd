extends Node

var bgm_player: AudioStreamPlayer
var delay_timer: Timer

var playlist: Array = [
	"res://assets/audios/music/ambientNOMUSIC.wav",
	"res://assets/audios/music/ambient1.wav"
]

var steam_pipe: Array = [
	"res://assets/audios/sfx/steam.wav"
]

var current_track_index: int = 0
@export var music_loop_delay: float = 3.0
@export var fade_duration: float = 1.5
@export var target_volume: float = -15.0

func _ready():
	# Настройка плеера
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	bgm_player.bus = "Music"
	

	bgm_player.finished.connect(_on_bgm_finished)
	
	#таймер
	delay_timer = Timer.new()
	add_child(delay_timer)
	delay_timer.one_shot = true
	delay_timer.timeout.connect(_on_delay_timer_timeout)

func play_level_music():
	if bgm_player.is_playing():
		return
	_play_current_track()

func _play_current_track():
	var track_path = playlist[current_track_index]
	var new_track = load(track_path)
	
	if new_track:
		bgm_player.stream = new_track
		bgm_player.volume_db = -80.0
		bgm_player.play()
		
		var tween = create_tween()
		tween.tween_property(bgm_player, "volume_db", target_volume, fade_duration)
	else:
		print("Ошибка загрузки:", track_path)
		
func _on_bgm_finished():
	# Музыка доиграла
	current_track_index = (current_track_index + 1) % playlist.size()
	delay_timer.start(music_loop_delay)

func _on_delay_timer_timeout():
	_play_current_track()

func play_sfx(sound_input, volume_db: float = 0.0):
	var final_path: String = ""

	if typeof(sound_input) == TYPE_ARRAY:
		final_path = sound_input[randi() % sound_input.size()]
	elif typeof(sound_input) == TYPE_STRING:
		final_path = sound_input
	else:
		return null

	var sound = load(final_path)
	if not sound:
		print("Ошибка загрузки звука:", final_path)
		return null

	var sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

	sfx_player.stream = sound
	sfx_player.bus = "SFX"
	sfx_player.volume_db = volume_db
	sfx_player.play()

	sfx_player.finished.connect(sfx_player.queue_free)

	return sfx_player
func stop_sfx(sound_path: String):
	for child in get_children():
		if child is AudioStreamPlayer and child.stream:
			if child.stream.resource_path == sound_path:
				child.stop()
				child.queue_free()
				return
