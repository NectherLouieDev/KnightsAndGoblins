class_name IdleState extends BaseGameState

@export_group("Statics")
const DATA_GAMEPLAY = preload("res://game/resources/gameplay/data_gameplay.tres")
@export var slot_machine: SlotMachine
@export var result_area: Node2D
@export var dummy: Dummy

@export_group("Spawning")
@export var spawn_stagger_timer: Timer
const SPAWN_EFFECT = preload("res://game/characters/spawn_effect.tscn")
const SPAWN_POINT = preload("res://game/gameplay/spawn_point.tscn")
var spawn_points: Array = []
var spawn_index = 0
var spawn_z = 0

# result stuff
var result: Array = []
const TROOPS_MODEL = preload("res://game/resources/troops_model.tres")

@export_group("Idle Menu")
@export var idle_menu: IdleMenu
@export var new_button: TextureButton
@export var continue_button: TextureButton
@export var quit_button: TextureButton

func enter():
	super.enter()
	
	slot_machine.spin_started_signal.connect(_on_spin_started)
	slot_machine.spin_complete_signal.connect(_on_spin_complete)
	
	spawn_stagger_timer.timeout.connect(_on_spawn_stagger_timer_timeout)
	
	idle_menu.enter_complete_signal.connect(_on_idle_menu_enter)
	idle_menu.play_enter()
	
func _on_idle_menu_enter():
	idle_menu.enter_complete_signal.disconnect(_on_idle_menu_enter)
	slot_machine.enable_spin_button()

func exit():
	super.exit()
	
	slot_machine.spin_started_signal.disconnect(_on_spin_started)
	slot_machine.spin_complete_signal.disconnect(_on_spin_complete)
	
	spawn_stagger_timer.timeout.disconnect(_on_spawn_stagger_timer_timeout)

func _on_spin_started():
	slot_machine.disable_spin_button()
	#DATA_GAMEPLAY.decrease_spins_left()

func _on_spin_complete():
	print("_on_spin_complete()->")
	
	result = slot_machine.get_spin_result()
	print(result)
	
	spawn_z = result.size() * 3
	for i in range(result.size()):
		var spawn_point = SPAWN_POINT.instantiate()
		spawn_points.append(spawn_point)
		result_area.add_child(spawn_point)
	
	spawn_index = 0
	spawn_stagger_timer.start()
	
	print("spawn_points size->", spawn_points.size())

func _hit_dummy(spawn_index, troop_type):
	var dmg = TROOPS_MODEL.troops[troop_type].damage
	dummy.play_hit(dmg)

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
	#var type = SlotConfig.SYMBOL_ENUM.ARCHER
	var type = result[i]
	spawn_point.spawn(i, type, dummy)
	
	var fx = SPAWN_EFFECT.instantiate()
	fx.z_index = spawn_z
	spawn_point.add_child(fx)
	
	spawn_index += 1

func _on_attack_complete(spawn_point):
	print("_on_attack_complete()->", spawn_point)
	#for point in spawn_points:
		#point.attack_started_signal.disconnect(_hit_dummy)
		#point.attack_complete_signal.disconnect(_on_attack_complete)
	
	spawn_points = []
	slot_machine.enable_spin_button()


func _on_new_button_pressed():
	# reset slot to default
	slot_machine.disable_spin_button()
	
	idle_menu.exit_complete_signal.connect(_on_idle_menu_exit)
	idle_menu.play_exit()
	
func _on_idle_menu_exit():
	idle_menu.exit_complete_signal.disconnect(_on_idle_menu_exit)
	dummy.visible = false
	game_manager.change_state(DataGameplay.GameState.PLAY)
