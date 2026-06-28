class_name HealthManager
extends Control

@export var heart_ui: Array[Sprite2D]
@export var flash_color: Color = Color(0.291, 0.0, 0.011, 1.0)
@export var flash_duration: float
@export var iframes_timer: Timer
var health: int
var is_endless := false

func _ready() -> void:
	iframes_timer.wait_time = 0.6
	health = 3
	EventBus.asteroid_hit_planet.connect(decrease_health)
	EventBus.wave_ended.connect(increase_health)
	EventBus.play_endless.connect(toggle_endless)


func decrease_health() -> void:
	if health > 0 && iframes_timer.is_stopped():
		iframes_timer.start()
		var tween = create_tween()
		tween.tween_property(self, "modulate", flash_color, flash_duration)
		tween.tween_property(self, "modulate", Color.WHITE, flash_duration).set_delay(flash_duration)
		heart_ui[health - 1].visible = false
		health -= 1
		if health == 0:
			if is_endless:
				EventBus.endless_over.emit()
			else:
				EventBus.game_over.emit()


func increase_health() -> void:
	if health != 3:
		var amount_to_heal = 3 - health
		for i in range(amount_to_heal):
			heart_ui[health + i].visible = true
		health += amount_to_heal


func toggle_endless() -> void:
	is_endless = true
