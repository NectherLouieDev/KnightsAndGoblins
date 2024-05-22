class_name Dummy

extends Node2D

var shake = 0.3
var shake_duration = 0.05
var shake_count = 2

@onready var hit_sprite = $HitSprite
const DAMAGE_NUMBER = preload("res://game/gameplay/damage_number.tscn")

func play_hit(new_damage_value):
	var dmg = DAMAGE_NUMBER.instantiate()
	add_child(dmg)
	dmg.spawn(new_damage_value)

	var tween = create_tween()
	
	if tween.is_running():
		tween.kill()
		tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	for i in range(shake_count):
		tween.tween_property(self, "rotation", randf_range(-shake, shake), shake_duration)
		
	tween.tween_callback(_on_shake_complete)
	
	hit_sprite.visible = true;

func _on_shake_complete():
	rotation = 0
	hit_sprite.visible = false;
