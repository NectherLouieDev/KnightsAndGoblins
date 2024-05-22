class_name HUDSpinsLeft extends Control

const DATA_GAMEPLAY = preload("res://game/resources/gameplay/data_gameplay.tres")

@onready var spins_left_value = $SpinsLeftValue

var shake = 0.3
var shake_duration = 0.1
var shake_count = 4

func _ready():
	DATA_GAMEPLAY.spins_left_updated_signal.connect(_on_spins_left_updated)

func _on_spins_left_updated():
	spins_left_value.text = DATA_GAMEPLAY.get_spins_left_label()
	
	var shake_scale = Vector2(randf_range(1-shake, 1+shake), randf_range(1-shake, 1+shake))
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(spins_left_value, "scale", Vector2(1.3, 1.3), shake_duration)
	tween.tween_property(spins_left_value, "scale", Vector2(0.8, 0.8), shake_duration)
	tween.tween_property(spins_left_value, "scale", Vector2(1, 1), shake_duration)
	
	tween.tween_callback(_on_shake_complete)

func _on_shake_complete():
	spins_left_value.scale = Vector2.ONE
