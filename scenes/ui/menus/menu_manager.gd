class_name MenuManager
extends Control

@export var game_over: Control
@export var game_won: Control
@export var endless_over: Control

func _ready() -> void:
	hide_all()
	EventBus.game_over.connect(show_game_over)
	EventBus.game_won.connect(show_game_won)
	EventBus.retry_wave.connect(hide_all)
	EventBus.play_endless.connect(hide_all)
	EventBus.endless_over.connect(show_endless_over)


func show_game_over() -> void:
	get_tree().paused = true
	visible = true
	game_over.visible = true


func show_game_won() -> void:
	get_tree().paused = true
	visible = true
	game_won.visible = true


func show_endless_over() -> void:
	get_tree().paused = true
	visible = true
	endless_over.visible = true


func hide_all() -> void:
	visible = false
	game_over.visible = false
	game_won.visible = false
	endless_over.visible = false
