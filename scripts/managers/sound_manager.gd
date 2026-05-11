extends Node

var bgm_player: AudioStreamPlayer

func _ready():
	#плеер
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	bgm_player.bus = "Music"

func play_level_music(music_path: String):
	var new_track = load(music_path)
	
	if bgm_player.stream == new_track:
		return
		
	bgm_player.stream = new_track
	bgm_player.play()
