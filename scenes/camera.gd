class_name Camera
extends Camera2D

@export var shake_strength: float
@export var shake_duration: float

func _ready() -> void:
	EventBus.asteroid_hit_planet.connect(_on_asteroid_hit_planet)


func _on_asteroid_hit_planet() -> void:
	var tween := create_tween()
	var steps := 12

	for i in steps:
		var t := float(i) / steps
		var strength := shake_strength * (1.0 - t)
		var shake_offset := Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		tween.tween_property(self, "offset", shake_offset, shake_duration / steps)

	tween.tween_property(self, "offset", Vector2.ZERO, 0.05)
