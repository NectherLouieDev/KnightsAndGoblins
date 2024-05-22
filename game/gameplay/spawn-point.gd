class_name SpawnPoint

extends Node2D

signal attack_started_signal(index, type)
signal attack_complete_signal()

const TROOPS_MODEL = preload("res://game/resources/troops_model.tres")

@onready var path = $Path2D/PathFollow2D
@onready var timer = $Path2D/Timer

var char: CharacterBase
var char_data: DataTroop

var can_walk = false
var _speed := 140
var _progress_ratio_target := 1.0

var _spawn_index
var _troop_type

func spawn(index, type, target)->void:
	print("spawn()index->", index)
	print("spawn()type->", type)
	
	_spawn_index = index
	_troop_type = type
	
	path = $Path2D/PathFollow2D
	timer = $Path2D/Timer
	
	char_data = TROOPS_MODEL.troops[type]
	char = char_data.sceneCharacter.instantiate() as CharacterBase
	char.spawn_init(char_data, target)
	
	_progress_ratio_target = char_data.progress_ratio
	
	print("_progress_ratio_target->", _progress_ratio_target)
	
	timer.timeout.connect(_on_timer.bind(index))
	timer.one_shot = true
	timer.wait_time = randf_range(0.1, 2.0)
	timer.start()
	
	path.add_child(char)

func _on_timer(index):
	char.play_walk()
	can_walk = true
	
func _process(delta):
	if can_walk == true:
		path.progress += _speed * delta
		
		if path.progress_ratio >= _progress_ratio_target:
			can_walk = false
			
			var child = path.get_child(0)
			child.attack_animation_started.connect(_attack_started)
			child.attack_animation_complete.connect(_attack_complete.bind(path, child))
			child.play_attack()

func _attack_started():
	emit_signal("attack_started_signal", _spawn_index, _troop_type)
	
func _attack_complete(path, child):
	path.progress_ratio = 0
	path.remove_child(child)
	child.queue_free()
	
	can_walk = false
	char = null
	
	emit_signal("attack_complete_signal")
	queue_free()
