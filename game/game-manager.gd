class_name GameManager

extends Node2D

# view properties
enum task_bar_type {L, M, S}
const task_bar_sizes = [72, 48, 32]

@onready var slot_machine = $SlotMachine as SlotMachine
@onready var result_area = $ResultArea
@onready var dummy = $ResultArea/Dummy

# Spawn stuff
@onready var spawn_stagger_timer = $ResultArea/SpawnStaggerTimer
const SPAWN_EFFECT = preload("res://game/characters/spawn_effect.tscn")
const SPAWN_POINT = preload("res://game/result/spawn_point.tscn")
var spawn_points: Array = []
var spawn_index = 0
var spawn_z = 0

var result: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_view()
	slot_machine.spin_complete_signal.connect(_on_spin_complete)
	slot_machine.create_slot_machine()
	
func _setup_view():
	get_tree().get_root().set_transparent_background(true)
	
	var main_screen_index = DisplayServer.get_primary_screen()
	var main_screen_size = DisplayServer.screen_get_size(main_screen_index)
	var main_screen_position = DisplayServer.screen_get_position((main_screen_index))
	
	var window = get_window();
	#var game_window_size = window.size
	window.position.x = main_screen_position.x
	window.position.y = main_screen_position.y + (main_screen_size.y - window.size.y - task_bar_sizes[task_bar_type.M])

func _on_spin_complete():
	print("_on_spin_complete()->")
	print(slot_machine.get_spin_result())
	
	result = slot_machine.get_spin_result()
	spawn_z = result.size() * 3
	for i in range(result.size()):
		var spawn_point = SPAWN_POINT.instantiate()
		spawn_points.append(spawn_point)
		result_area.add_child(spawn_point)
	
	spawn_index = 0
	spawn_stagger_timer.start()
	
	print("spawn_points size->", spawn_points.size())

func _on_attack_complete():
	spawn_points = []
	
func _hit_dummy():
	dummy.play_hit()

func _on_spawn_stagger_timer_timeout():
	var i = spawn_index
	var spawn_point = spawn_points[i] as SpawnPoint
	spawn_point.position.y -= (i * 10)
	spawn_point.position.x = sin(i) * randi_range(10, 50)
	spawn_z -= 1
	if spawn_z <= 1:
		spawn_z = 2
	spawn_point.z_index = spawn_z
	
	if i == spawn_points.size()-1:
		spawn_point.attack_complete_signal.connect(_on_attack_complete)
		spawn_index = 0
		spawn_stagger_timer.stop()
		
	spawn_point.attack_started_signal.connect(_hit_dummy)
	#var type = SlotConfig.SYMBOL_ENUM.TORCHER
	var type = result[i]
	spawn_point.spawn(i, type, dummy)
	
	var fx = SPAWN_EFFECT.instantiate()
	fx.z_index = spawn_z
	spawn_point.add_child(fx)
	
	spawn_index += 1
