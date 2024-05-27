class_name IdleMenu extends Control

signal enter_complete_signal()
signal exit_complete_signal()

var position_tween: Tween;

func play_enter():
	position_tween = create_tween()
	position_tween.tween_property(self, "position", Vector2(position.x, 324), 0.5)
	position_tween.tween_callback(_on_enter_complete)

func _on_enter_complete():
	emit_signal("enter_complete_signal")

func play_exit():
	position_tween = create_tween()
	position_tween.tween_property(self, "position", Vector2(position.x, 324*2), 0.5)
	position_tween.tween_callback(_on_exit_complete)

func _on_exit_complete():
	emit_signal("exit_complete_signal")
