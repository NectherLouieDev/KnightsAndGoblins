class_name CharacterThrower extends CharacterBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var arrow_timer = $ArrowTimer
@onready var attack_timer = $AttackTimer

var projectile: Projectile

func spawn_init(new_data_troop, new_target):
	data_troop = new_data_troop
	target = new_target
	
func play_walk():
	animated_sprite_2d.play("Walk")

func play_attack():	
	animated_sprite_2d.animation_finished.connect(_on_attack_animation_finished)
	animated_sprite_2d.play("Attack")

func _on_attack_animation_finished():
	projectile = data_troop.sceneProjectile.instantiate()
	add_child(projectile)
	projectile.launch(target)
	
	arrow_timer.timeout.connect(_on_arrow_hit)
	arrow_timer.one_shot = true
	arrow_timer.start()

func _on_arrow_hit():
	emit_signal("attack_animation_started")
	
	remove_child(projectile)
	projectile.queue_free()
	
	attack_timer.timeout.connect(_on_attack_timer_complete)
	attack_timer.one_shot = true
	attack_timer.start()
	
func _on_attack_timer_complete():
	emit_signal("attack_animation_complete")
