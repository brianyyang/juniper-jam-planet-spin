class_name MusicPlayer
extends AudioStreamPlayer2D

@export var intro_song: AudioStream
@export var loop_song: AudioStream

func _ready() -> void:
	stream = intro_song
	finished.connect(_on_intro_finished)
	play()


func _on_intro_finished() -> void:
	stream = loop_song
	play(0.05)
