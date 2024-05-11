extends Node2D

enum task_bar_type {L, M, S}
const task_bar_sizes = [72, 48, 32]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().set_transparent_background(true)
	
	var main_screen_index = DisplayServer.get_primary_screen()
	var main_screen_size = DisplayServer.screen_get_size(main_screen_index)
	var main_screen_position = DisplayServer.screen_get_position((main_screen_index))
	
	var window = get_window();
	var game_window_size = window.size
	window.position.x = main_screen_position.x
	window.position.y = main_screen_position.y + (main_screen_size.y - window.size.y - task_bar_sizes[task_bar_type.M])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
