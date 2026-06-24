class_name AsteroidSpawner
extends Node2D

@export var timer: Timer
@export var asteroid_scene: PackedScene
@export var speed: float
@export var spawn_interval: float

@onready var container := $"../Asteroids"
var screen_width: float
var screen_height: float

func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn)
	var viewport := get_viewport_rect()
	screen_width = viewport.size.x
	screen_height = viewport.size.y


func spawn() -> void:
	var spawn_point := get_random_screen_edge_position()
	var aim_offset := Vector2(576.0, 320.0)

	var asteroid := asteroid_scene.instantiate()
	container.add_child(asteroid)
	asteroid.launch(spawn_point, aim_offset, speed)


func get_random_screen_edge_position() -> Vector2:
	var side := randi() % 4
	var pos := Vector2.ZERO
	
	match side:
		0: pos = Vector2(randf_range(0, screen_width), 0)
		1: pos = Vector2(screen_width, randf_range(0, screen_height))
		2: pos = Vector2(randf_range(0, screen_width), screen_height)
		3: pos = Vector2(0, randf_range(0, screen_height))
	
	# Convert from screen space to world space
	return get_viewport().get_canvas_transform().affine_inverse() * pos
