extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d_2 = $AnimatedSprite2D2
@onready var animated_sprite_2d_3 = $AnimatedSprite2D3

func init(index)->void:
	var symbols = [
		animated_sprite_2d,
		animated_sprite_2d_2,
		animated_sprite_2d_3
	]
	
	for s in symbols:
		s.visible = false
	
	symbols[min(2, index)].visible = true
