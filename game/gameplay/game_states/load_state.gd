class_name Loadstate extends BaseGameState

# view properties
enum task_bar_type {L, M, S}
const task_bar_sizes = [72, 48, 32]

# slot
@export var slot_machine: SlotMachine

func enter():
	super.enter()
	
	get_tree().get_root().set_transparent_background(true)
	
	var main_screen_index = DisplayServer.get_primary_screen()
	var main_screen_size = DisplayServer.screen_get_size(main_screen_index)
	var main_screen_position = DisplayServer.screen_get_position((main_screen_index))
	
	var window = get_window();
	#var game_window_size = window.size
	window.position.x = main_screen_position.x
	window.position.y = main_screen_position.y + (main_screen_size.y - window.size.y - task_bar_sizes[task_bar_type.M])
	
	# create slot
	slot_machine.create_slot_machine()
	slot_machine.disable_spin_button()
	
	# change to idle
	game_manager.change_state(DataGameplay.GameState.IDLE)
	
func exit():
	super.exit()
