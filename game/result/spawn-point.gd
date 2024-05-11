class_name SpawnPoint

extends Node2D

signal attack_complete_signal()

@onready var path = $Path2D/PathFollow2D
@onready var timer = $Path2D/Timer

var char: CharacterNode;

var can_walk = false

func spawn(index, type)->void:
	print("spawn()index->", index)
	print("spawn()type->", type)
	
	path = $Path2D/PathFollow2D
	timer = $Path2D/Timer
	
	char = SpawnConfig.CHARACTER_PRELOADS[type].instantiate()
	
	timer.timeout.connect(_on_timer.bind(index))
	timer.one_shot = true
	timer.wait_time = randf_range(0.1, 2.0)
	timer.start()
	
	path.add_child(char)

func _on_timer(index):
	char.play_walk()
	can_walk = true
	
func _process(delta):
	
	var speed := 140.0
	if can_walk == true:
		path.progress += speed * delta
		
		if path.progress_ratio >= 1:
			var child = path.get_child(0) as CharacterNode
			child.attack_animation_complete.connect(_attack_complete.bind(path, child))
			child.play_attack()

func _attack_complete(path, child):
	path.progress_ratio = 0
	path.remove_child(child)
	child.queue_free()
	
	can_walk = false
	char = null
	
	emit_signal("attack_complete_signal")
	queue_free()
