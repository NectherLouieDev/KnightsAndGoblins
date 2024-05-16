class_name CharacterTorcher

extends CharacterNode

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hit_timer = $HitTimer
@onready var attack_timer = $AttackTimer

func spawn_init(new_target):
	set_troop_type(SpawnConfig.TROOP_TYPE.MELEE)
	
func play_walk():
	animated_sprite_2d.play("Walk")

func play_attack():
	attack_timer.timeout.connect(_on_attack_animation_finished)
	attack_timer.one_shot = true
	attack_timer.start()
	
	hit_timer.timeout.connect(_on_hit_timer_complete)
	hit_timer.one_shot = true
	hit_timer.start()
	
	#animated_sprite_2d.animation_finished.connect(_on_attack_animation_finished)
	animated_sprite_2d.play("Attack")

func _on_hit_timer_complete():
	emit_signal("attack_animation_started")
	
func _on_attack_animation_finished():
	emit_signal("attack_animation_complete")
