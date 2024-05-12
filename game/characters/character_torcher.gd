class_name CharacterTorcher

extends CharacterNode

@onready var animated_sprite_2d = $AnimatedSprite2D

func play_walk():
	animated_sprite_2d.play("Walk")

func play_attack():
	emit_signal("attack_animation_started")
	animated_sprite_2d.animation_finished.connect(_on_attack_animation_finished)
	animated_sprite_2d.play("Attack")

func _on_attack_animation_finished():
	emit_signal("attack_animation_complete")
