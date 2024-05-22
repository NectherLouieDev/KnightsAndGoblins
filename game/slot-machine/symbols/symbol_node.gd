extends Node2D

var symbol_id;

var _symbol_visual;

func init_node(new_position):
	position = new_position

func create_visual(new_symbol_id):
	var config = SlotConfig
	
	symbol_id = new_symbol_id
	
	_symbol_visual = config.SYMBOL_PRELOADS[symbol_id].instantiate()
	_symbol_visual.position = Vector2i.ZERO
	add_child(_symbol_visual)

func update_visual(new_symbol_id):
	var config = SlotConfig
	
	# remove visual
	remove_child(_symbol_visual)
	_symbol_visual = null;
	
	# add new
	create_visual(new_symbol_id)

func _process(delta):
	pass
