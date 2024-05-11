extends Node2D

@onready var path_1 = $Path1/PathFollow2D
@onready var path_2 = $Path2/PathFollow2D
@onready var path_3 = $Path3/PathFollow2D

@onready var timer_1 = $Path1/Timer
@onready var timer_2 = $Path2/Timer
@onready var timer_3 = $Path3/Timer

var paths = []
var timers = []

const CHARACTER_WARRIOR = preload("res://game/characters/character_warrior.tscn")
var chars = [];

func _ready():
	paths = [
		path_1,
		path_2,
		path_3
	]
	
	timers = [
		timer_1,
		timer_2,
		timer_3
	]

func spawn(index)->void:
	print("spawn()->")
	
	chars.append(CHARACTER_WARRIOR.instantiate())
	
	var timer = timers[index] as Timer
	timer.timeout.connect(_on_timer.bind(index))
	timer.one_shot = true
	timer.wait_time = randf_range(0.5, 1.5)
	timer.start()
	
	var path = paths[index] as PathFollow2D
	path.add_child(chars[index])

var can_walk = [false, false, false]

func _on_timer(index):
	var char = chars[index] as CharacterWarrior
	char.play_walk()
	
	can_walk[index] = true
	
func _process(delta):
		
	var speed := 140.0
	for i in range(paths.size()):
		var path = paths[i] as PathFollow2D
		
		if can_walk[i] == true:
			path.progress += speed * delta
			
			if path.progress_ratio >= 1:
				var child = path.get_child(0) as CharacterWarrior
				child.attack_animation_complete.connect(_attack_complete.bind(i, path, child))
				child.play_attack()

func _attack_complete(index, path, child):
	path.progress_ratio = 0
	path.remove_child(child)
	child.queue_free()
	
	can_walk[index] = false
	if not can_walk.has(true):
		chars.clear()
