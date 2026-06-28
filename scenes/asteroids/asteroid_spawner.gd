class_name AsteroidSpawner
extends Node2D

@export var timer: Timer
@export var asteroid_scene: PackedScene
@export var speed: float
@export var spawn_interval: float
@export var spawn_offset: float

@onready var container := $"../../Asteroids"
var screen_width: float
var screen_height: float

func _ready() -> void:
	var viewport := get_viewport_rect()
	screen_width = viewport.size.x
	screen_height = viewport.size.y
	timer.timeout.connect(spawn)
	timer.stop()
	EventBus.wave_ended.connect(stop_spawner)


func activate() -> void:
	await get_tree().create_timer(spawn_offset).timeout
	timer.wait_time = spawn_interval
	timer.start()


func spawn() -> void:
	var spawn_point := get_random_screen_edge_position()
	var aim_offset := Vector2(screen_width / 2, screen_height / 2)

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
	
	return get_viewport().get_canvas_transform().affine_inverse() * pos


func stop_spawner() -> void:
	timer.stop()
