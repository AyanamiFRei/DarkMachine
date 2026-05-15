extends Node

var bgm_player: AudioStreamPlayer
var delay_timer: Timer

# 1. Твои два файла. Добавь сюда свои реальные пути!
var playlist: Array = [
	"res://assets/audios/music/ambientNOMUSIC.wav",
	"res://assets/audios/music/ambient1.wav"
]

var current_track_index: int = 0
@export var music_loop_delay: float = 3.0 # Пауза в секундах
@export var fade_duration: float = 1.5   # Плавное появление (сек)
@export var target_volume: float = -15.0

func _ready():
	# Настройка плеера
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	bgm_player.bus = "Music"
	
	# Подключаем сигнал: когда музыка кончится, вызовется функция _on_bgm_finished
	bgm_player.finished.connect(_on_bgm_finished)
	
	# Настройка таймера для паузы
	delay_timer = Timer.new()
	add_child(delay_timer)
	delay_timer.one_shot = true
	delay_timer.timeout.connect(_on_delay_timer_timeout)

# Эту функцию вызываем из игрока (player.gd) в _ready()
func play_level_music():
	if bgm_player.is_playing():
		return
	_play_current_track()

func _play_current_track():
	var track_path = playlist[current_track_index]
	var new_track = load(track_path)
	
	if new_track:
		bgm_player.stream = new_track
		bgm_player.volume_db = -80.0 # Начинаем с полной тишины
		bgm_player.play()
		
		var tween = create_tween()
		# Теперь меняем громкость не до 0, а до нашего target_volume
		tween.tween_property(bgm_player, "volume_db", target_volume, fade_duration)
	else:
		print("Ошибка загрузки:", track_path)
		
func _on_bgm_finished():
	# Музыка доиграла. Переключаем индекс: 0 станет 1, а 1 станет 0
	current_track_index = (current_track_index + 1) % playlist.size()
	
	# Запускаем паузу
	delay_timer.start(music_loop_delay)

func _on_delay_timer_timeout():
	# Пауза закончилась — играем следующий трек
	_play_current_track()
