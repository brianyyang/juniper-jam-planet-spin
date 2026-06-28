class_name TrickyAsteroid
extends RigidBody2D

@export var rotation_speed: float
@export var explosion_sprite: Sprite2D
@export var orbit_speed: float      
@export var spiral_speed: float
var spin_direction: int
var deflected: bool = false
var is_exploded: bool = false
var spiral_angle: float = 0.0
var radius: float = 0.0
var planet_position: Vector2 = Vector2.ZERO
var regular_speed: float = 0.0
var regular: bool = true
var has_tricked_already := false
var target_spiral_position: Vector2

func _ready() -> void:
	spin_direction = [-1, 1].pick_random()
	angular_velocity = spin_direction * rotation_speed
	explosion_sprite.rotation = randf_range(0, TAU)
	EventBus.wave_ended.connect(queue_free)


func _physics_process(delta: float) -> void:
	if is_exploded || deflected:
		return
	if regular:
		radius = global_position.distance_to(planet_position)
		if radius <= 200 && !has_tricked_already:
			get_tricky()
	else: 
		if radius < 150:
			return_to_regular()
		else:
			spiral_angle += orbit_speed * delta
			radius -= spiral_speed * delta
			var offset := Vector2(cos(spiral_angle), sin(spiral_angle)) * radius
			target_spiral_position = planet_position + offset


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !regular and target_spiral_position:
		state.transform = Transform2D(state.transform.get_rotation(), target_spiral_position)


func launch(from: Vector2, target: Vector2, speed: float) -> void:
	global_position = from
	planet_position = target
	spiral_angle = (global_position - planet_position).angle()
	radius = from.distance_to(target)
	regular_speed = speed
	linear_velocity = (planet_position - global_position).normalized() * regular_speed


func get_tricky() -> void:
	regular = false
	has_tricked_already = true
	linear_velocity = Vector2.ZERO
	var offset := global_position - planet_position
	spiral_angle = offset.angle()
	radius = offset.length()


func return_to_regular():
	regular = true
	var offset := global_position - planet_position
	spiral_angle = offset.angle()
	radius = offset.length()
	linear_velocity = (planet_position - global_position).normalized() * regular_speed


func _on_body_entered(body: Node) -> void:
	if is_exploded:
		return
	if deflected && body.get_collision_layer_value(Collision.ASTEROIDS):
		explode(1)
		body.explode(1)
	elif deflected && body.get_collision_layer_value(Collision.BIG_ASTEROIDS):
		explode(1)
	elif body.get_collision_layer_value(Collision.PLANET):
		EventBus.asteroid_hit_planet.emit()
		explode(0.5)


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
