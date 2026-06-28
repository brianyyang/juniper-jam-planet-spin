class_name Main
extends Node

@export var wave_manager: WaveManager

func _ready() -> void:
	EventBus.retry_wave.connect(retry_wave)
	EventBus.play_endless.connect(play_endless)
	wave_manager.start_game(1)


func retry_wave() -> void:
	wave_manager.start_game(wave_manager.current_wave)


func play_endless() -> void:
	wave_manager.start_endless()
	
