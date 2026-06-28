class_name DialogueManager
extends Control

@export var label: Label

var lines_to_display: Array
var advance: Callable
var line_index := 0

func _ready() -> void:
	hide()


func show_lines(lines: Array, callback: Callable) -> void:
	lines_to_display = lines
	advance = callback
	line_index = 0
	label.text = ""
	show()
	show_next_line()


func show_next_line() -> void:
	if line_index >= lines_to_display.size():
		hide()
		advance.call()
		return
	if line_index > 0:
		label.text += "\n"
	var full_text: String = lines_to_display[line_index]
	line_index += 1
	# type out character by character
	var tween := create_tween()
	for i in full_text.length():
		tween.tween_callback(func(): label.text += full_text[i]).set_delay(0.04)
	tween.tween_interval(2)  # pause before advancing
	tween.tween_callback(show_next_line)
