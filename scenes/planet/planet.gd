class_name Planet
extends AnimatableBody2D

@export var rotation_speed: float
@export var paddle: Paddle

var angular_velocity: float = 0
var prev_rotation: float = 0

func _physics_process(delta: float) -> void:
	var input := Input.get_axis("rotate_counter_clockwise", "rotate_clockwise")
	rotation += input * rotation_speed * delta
	
	angular_velocity = (rotation - prev_rotation) / delta
	prev_rotation = rotation
	paddle.angular_velocity = angular_velocity
	
