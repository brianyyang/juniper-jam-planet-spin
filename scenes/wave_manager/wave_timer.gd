class_name WaveTimer
extends Label

@export var wave_manager: WaveManager
var endless := false
var time_left := 0
var endless_time_saved := 0

func _ready() -> void:
	EventBus.play_endless.connect(toggle_endless)
	EventBus.endless_over.connect(save_endless_time)


func _process(_delta: float) -> void:
	if endless:
		time_left = wave_manager.ENDLESS_TIME - ceil(wave_manager.wave_timer.time_left)
		text = "Endless\n{0}".format([time_left]) 
	else:
		time_left = ceil(wave_manager.wave_timer.time_left)
		if time_left != 0:
			text = "Wave {0}\n{1}".format([wave_manager.current_wave, time_left])
		else:
			text = ""


func toggle_endless() -> void:
	endless = true


func save_endless_time() -> void:
	endless_time_saved = wave_manager.ENDLESS_TIME - ceil(wave_manager.wave_timer.time_left)
