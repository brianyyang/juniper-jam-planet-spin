class_name Paddle
extends Area2D

@export var bounce_power: float
@export var spin_power: float
var angular_velocity: float

func _on_body_entered(body: Node2D) -> void:
	var normal := (global_transform.basis_xform(Vector2.UP)).normalized()
	var incoming = body.linear_velocity.normalized()
	var reflected = incoming.bounce(normal)
	var tangent := Vector2(-normal.y, normal.x)
	body.linear_velocity = Vector2.ZERO
	var angle_power := tangent * spin_power * angular_velocity
	body.linear_velocity = Vector2.ZERO
	body.apply_central_impulse((reflected * bounce_power) + angle_power)
