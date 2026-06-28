class_name GameOver
extends Control

func _on_retry_pressed() -> void:
	EventBus.wave_ended.emit()
	EventBus.retry_wave.emit()
