extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().set_transparent_background(true)
	print(DisplayServer.screen_get_size())
	print(get_window().size)
	var t = DisplayServer.screen_get_size()
	get_window().position.x = 1080
	get_window().position.y = 557 + (t.y - 256 - 48) #L72, M48, S32
	print(DisplayServer.get_screen_count())
	print(DisplayServer.get_primary_screen())
	#DisplayServer.window_set_position(DisplayServer.screen_get_position(1), 1)
	print(DisplayServer.screen_get_position(0))
	print(DisplayServer.screen_get_position(1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
