class_name Planet
extends AnimatableBody2D

@export var rotation_speed: float  # radians/sec
@export var acceleration: float
@export var damping: float

var angular_velocity: float = 0

func _physics_process(delta: float) -> void:
	var input := Input.get_axis("rotate_counter_clockwise", "rotate_clockwise")

	if input != 0.0:
		angular_velocity += input * acceleration * delta
		angular_velocity = clamp(angular_velocity, -rotation_speed, rotation_speed)
	else:
		angular_velocity = move_toward(angular_velocity, 0.0, damping * delta)

	rotation += angular_velocity * delta
