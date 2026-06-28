class_name Planet
extends AnimatableBody2D

@export var rotation_speed: float
@export var paddle: Paddle

@export_group("Sprite")
@export var sprite: Sprite2D
@export var hit_color: Color
@export var hit_duration: float
@export var iframes_timer: Timer

var angular_velocity: float = 0
var prev_rotation: float = 0

func _ready() -> void:
	iframes_timer.wait_time = 0.6
	EventBus.asteroid_hit_planet.connect(_on_asteroid_hit)


func _physics_process(delta: float) -> void:
	var input := Input.get_axis("rotate_counter_clockwise", "rotate_clockwise")
	rotation += input * rotation_speed * delta
	
	angular_velocity = (rotation - prev_rotation) / delta
	prev_rotation = rotation
	paddle.angular_velocity = angular_velocity
	handle_paddle_direction(input)


func _on_asteroid_hit() -> void:
	if iframes_timer.is_stopped():
		iframes_timer.start()
		var tween := create_tween()
		tween.tween_property($Sprite2D, "modulate", hit_color, hit_duration)
		tween.tween_property($Sprite2D, "modulate", Color.WHITE, hit_duration)
		tween.tween_property($Sprite2D, "modulate", hit_color, hit_duration)
		tween.tween_property($Sprite2D, "modulate", Color.WHITE, hit_duration)
		tween.tween_property($Sprite2D, "modulate", hit_color, hit_duration)
		tween.tween_property($Sprite2D, "modulate", Color.WHITE, hit_duration)


func handle_paddle_direction(input: float) -> void:
	if input == 0:
		paddle.direction = "none"
	elif input > 0:
		paddle.direction = "clockwise"
	elif input < 0:
		paddle.direction = "counter_clockwise"
