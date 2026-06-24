class_name Asteroid
extends RigidBody2D


func launch(from: Vector2, target: Vector2, speed: float) -> void:
	global_position = from
	linear_velocity = (target - from).normalized() * speed
