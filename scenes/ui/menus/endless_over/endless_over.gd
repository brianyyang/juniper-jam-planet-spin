class_name EndlessOver
extends Control

@export var label: Label
@onready var timer: WaveTimer = $"../../WaveTimer"

func _ready() -> void:
	EventBus.endless_over.connect(set_text)


func _on_retry_pressed() -> void:
	EventBus.wave_ended.emit()
	EventBus.play_endless.emit()


func set_text() -> void:
	var time = timer.endless_time_saved
	var min = floor(time / 60)
	var sec = time % 60
	label.text = "Endless Over!\nYou lasted:\n\n{0} minutes, {1} seconds\n\nTry again?".format([min, sec])
