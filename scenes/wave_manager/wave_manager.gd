class_name WaveManager
extends Node

@export var wave_timer: Timer
@export var spawners: Array[AsteroidSpawner]
@export var dialogue_manager: DialogueManager

const WAVE_LENGTH := 45
const FINAL_WAVE_LENGTH := 30
const ENDLESS_TIME := 1000000000

var current_wave := 0

func start_game(wave: int) -> void:
	get_tree().paused = false
	current_wave = wave
	wave_timer.wait_time = WAVE_LENGTH
	wave_timer.stop()
	show_dialogue_then_advance()
	

func advance() -> void:
	handle_wave_spawners()
	wave_timer.start()


func _on_wave_timer_timeout() -> void:
	EventBus.wave_ended.emit()
	current_wave += 1
	if current_wave > WaveData.WAVES.size():
		EventBus.game_won.emit()
		return
	show_dialogue_then_advance()


func show_dialogue_then_advance() -> void:
	var data = WaveData.WAVES[current_wave - 1]
	dialogue_manager.show_lines(data.dialogue, advance)


func handle_wave_spawners() -> void:
	# endless mode
	if current_wave == -1:
		for wave_number in range(spawners.size()):
			spawners[wave_number].activate()
	elif current_wave == spawners.size() + 1:
		wave_timer.wait_time = FINAL_WAVE_LENGTH
		for wave_number in range(current_wave - 1):
			spawners[wave_number].activate()
	else:
		spawners[0].activate()
		if current_wave > 1:
			spawners[current_wave - 1].activate()


func start_endless() -> void:
	current_wave = -1
	get_tree().paused = false
	wave_timer.wait_time = ENDLESS_TIME
	wave_timer.stop()
	advance()
