extends Node2D

class_name DamageNumber
@onready var label = $Label

func spawn(new_damage_value):
	label.text = str(new_damage_value)
	
	label.add_theme_color_override("font_color", Color.RED)
	
	var _fromX = randf_range(position.x - 64, position.x + 64)
	var _fromY = randf_range(position.y - 64, position.y - 128)
	var _toX = _fromX
	var _toY = _fromY - 128
	
	position.x = _fromX
	position.y = _fromY
	
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(_toX, _toY), 1)
	tween.tween_callback(_on_position_complete)
	
func _on_position_complete():
	queue_free()
