class_name GameWon
extends Control

func _on_play_endless_pressed() -> void:
	EventBus.play_endless.emit()
