class_name HUDSpinsLeft extends Control

signal enter_complete_signal()
signal exit_complete_signal()

var position_tween: Tween;

const DATA_GAMEPLAY = preload("res://game/resources/gameplay/data_gameplay.tres")

@export var spins_left_value: Label;

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

func play_enter():
	position_tween = create_tween()
	position_tween.tween_property(self, "position", Vector2(position.x, 298), 0.5)
	position_tween.tween_callback(_on_enter_complete)

func _on_enter_complete():
	emit_signal("enter_complete_signal")

func play_exit():
	position_tween = create_tween()
	position_tween.tween_property(self, "position", Vector2(position.x, 324*2), 0.5)
	position_tween.tween_callback(_on_exit_complete)

func _on_exit_complete():
	emit_signal("exit_complete_signal")
