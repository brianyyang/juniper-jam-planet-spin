class_name Paddle
extends Area2D

@export var sprite: Sprite2D
@export var fire: Sprite2D
@export var bounce_power: float
@export var spin_power: float
var angular_velocity: float
var direction: String = "none"

func _on_body_entered(body: Node2D) -> void:
	var normal := (global_transform.basis_xform(Vector2.UP)).normalized()
	var incoming = body.linear_velocity.normalized()
	var reflected = incoming.bounce(normal)
	var tangent := Vector2(-normal.y, normal.x)
	body.linear_velocity = Vector2.ZERO
	var angle_power := tangent * spin_power * angular_velocity
	body.linear_velocity = Vector2.ZERO
	body.apply_central_impulse((reflected * bounce_power) + angle_power)
	body.deflected = true
	body.set_collision_mask_value(Collision.ASTEROIDS, true)
	body.set_collision_mask_value(Collision.BIG_ASTEROIDS, true)


func _process(_delta: float) -> void:
	if direction == "none":
		fire.visible = false
	elif direction == "clockwise":
		fire.visible = true
		fire.flip_h = true
		fire.position.x = -12
		sprite.flip_h = true
	elif direction == "counter_clockwise":
		fire.visible = true
		fire.flip_h = false
		fire.position.x = 12
		sprite.flip_h = false
