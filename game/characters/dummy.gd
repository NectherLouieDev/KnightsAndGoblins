class_name Dummy

extends Node2D

var shake = 0.3
var shake_duration = 0.05
var shake_count = 2

func play_hit():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	for i in range(shake_count):
		tween.tween_property(self, "rotation", randf_range(-shake, shake), shake_duration)
		
	tween.tween_callback(_on_shake_complete)

func _on_shake_complete():
	rotation = 0
