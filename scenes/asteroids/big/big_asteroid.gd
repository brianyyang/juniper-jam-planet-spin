class_name BigAsteroid
extends RigidBody2D

@export var rotation_speed: float
@export var explosion_sprite: Sprite2D
var spin_direction: int
var deflected: bool = false
var is_exploded: bool = false

func _ready() -> void:
	spin_direction = [-1, 1].pick_random()
	angular_velocity = spin_direction * rotation_speed
	explosion_sprite.rotation = randf_range(0, TAU)
	EventBus.wave_ended.connect(queue_free)


func launch(from: Vector2, target: Vector2, speed: float) -> void:
	global_position = from
	linear_velocity = (target - from).normalized() * speed


func _on_body_entered(body: Node) -> void:
	if body.get_collision_layer_value(Collision.PLANET):
		EventBus.asteroid_hit_planet.emit()
		explode(0.5)
	elif deflected && body.get_collision_layer_value(Collision.ASTEROIDS):
		explode(2)
		body.explode(2)
	elif deflected && body.get_collision_layer_value(Collision.BIG_ASTEROIDS):
		explode(2)
		body.explode(2)


func explode(linger_duration: float) -> void:
	is_exploded = true
	explosion_sprite.visible = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	set_collision_layer_value(Collision.ASTEROIDS, false)
	set_collision_layer_value(Collision.BIG_ASTEROIDS, false)
	set_collision_mask_value(Collision.ASTEROIDS, false)
	set_collision_mask_value(Collision.PLANET, false)
	set_collision_mask_value(Collision.PADDLES, false)
	var timer := get_tree().create_timer(linger_duration)
	timer.timeout.connect(queue_free)
