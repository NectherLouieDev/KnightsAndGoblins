extends Node2D

signal spin_complete()

var _reel_properties = {
	"symbol_size": 128,
	"reel_size": 3,
	"top_position": Vector2i.ZERO,
	"bottom_position": Vector2i.ZERO,
	"top_index": -1,
	"bottom_index": -1,
	"next_strip_index": -1
}

@onready var spin_timer = $SpinTimer

var symbol_nodes = []
var result_symbol_nodes = [];
var speed = 10

enum spin_stages { idle, start, spin, end, snap }
var current_spin_stage = spin_stages.idle

var _slot_config;
var _reelstrip_model;
var _index = -1

var _has_processed_snap = false
var _has_process_start = false

func _process(delta):
	var dt = delta
	match current_spin_stage:
		spin_stages.idle:
			return
		spin_stages.start:
			_process_spin_start(dt)
		spin_stages.spin:
			_process_spin(dt)
		spin_stages.end:
			_process_spin_end(dt)
		spin_stages.snap:
			_process_snap(dt)

func init(new_slot_config, new_index):
	_slot_config = new_slot_config
	_reelstrip_model = _slot_config.REELSTRIP_MODEL.duplicate()
	_reelstrip_model.shuffle()
	
	_index = new_index
	
	var props = _reel_properties
	props.symbol_size = _slot_config.SYMBOL_SIZE
	props.top_position.y = 0
	props.bottom_position.y = props.top_position.y + (props.reel_size * props.symbol_size)

func create_symbols():
	var props = _reel_properties
	var slot_config = _slot_config
	
	for i in range(props.reel_size):
		var new_symbol_node = slot_config.SYMBOL_NODE.instantiate()
		var new_position = Vector2i(props.top_position.x, props.top_position.y + (props.symbol_size * i))
		
		# init
		new_symbol_node.init_node(slot_config, new_position)
		
		# create
		new_symbol_node.create_visual(_reelstrip_model[i])
		
		# add to scene
		add_child(new_symbol_node)
		symbol_nodes.push_back(new_symbol_node)
	
	props.top_index = 0
	props.bottom_index = symbol_nodes.size() - 1
	
	props.next_strip_index = props.reel_size - 1;

func start_spin():
	result_symbol_nodes = []
	_has_processed_snap = false
	_has_process_start = false
	current_spin_stage = spin_stages.start

func stop_spin():
	current_spin_stage = spin_stages.end

func _process_spin_start(delta):
	if _has_process_start:
		return
	
	var props = _reel_properties
	
	for i in range(symbol_nodes.size()):
		var symbol_node = symbol_nodes[i]
		
		var tween = create_tween()
		tween.tween_property(symbol_node, "position", Vector2(symbol_node.position.x, symbol_node.position.y - 8), 0.1)
		
		if i == symbol_nodes.size() - 1:
			tween.tween_callback(_on_spin_start_complete)
	
	_has_process_start = true

func _on_spin_start_complete():
	spin_timer.start()
	current_spin_stage = spin_stages.spin
	
func _process_spin(delta):
	if spin_timer.time_left > 0:
		var props = _reel_properties
		for symbol_node in symbol_nodes:
			var distance = props.symbol_size * speed * delta
			var distance_offset = speed * delta
			
			symbol_node.position.y += distance
			
			if symbol_node.position.y + distance_offset > props.bottom_position.y:
				_update_symbol_visual(symbol_node, distance)
	else:
		current_spin_stage = spin_stages.snap
	
func _process_spin_end(delta):
	var props = _reel_properties
	
	# slow down here?
	for i in range(symbol_nodes.size()):
		var symbol_node = symbol_nodes[i]
	
	current_spin_stage = spin_stages.snap

func _process_snap(delta):
	if _has_processed_snap:
		return
	
	var props = _reel_properties
	
	var start_index = props.top_index
	for i in range(symbol_nodes.size()):
		var index = (start_index + i) % symbol_nodes.size()
		var symbol_node = symbol_nodes[index]
		
		var target_position = i * props.symbol_size
		var position_snap_offset = props.symbol_size * 0.25
		symbol_node.position.y = target_position + position_snap_offset
		
		result_symbol_nodes.append(symbol_node)
		
		var tween = create_tween()
		tween.tween_property(symbol_node, "position", Vector2(symbol_node.position.x, target_position), 0.15)
		if i == symbol_nodes.size() - 1:
			tween.tween_callback(_on_snap_complete)
	
	_has_processed_snap = true
		
func _on_snap_complete():
	emit_signal("spin_complete")
	current_spin_stage = spin_stages.idle

func _update_symbol_visual(symbol_node, distance):
	var props = _reel_properties;
	
	# reposition bottom node to top
	symbol_node.position.y = props.top_position.y + distance
	
	# get next index from strip data
	props.next_strip_index += 1;
	if props.next_strip_index > _reelstrip_model.size() - 1:
		props.next_strip_index = 0
	
	# change visual
	symbol_node.update_visual(_reelstrip_model[props.next_strip_index])
	
	# update top and bottom indices
	props.top_index = props.bottom_index
	props.bottom_index = props.top_index - 1
	if props.bottom_index < 0:
		props.bottom_index = symbol_nodes.size() - 1

func _get_reset_y_position(index)->int:
	var props = _reel_properties
	
	var row_index = index + props.top_index - 1
	if row_index > props.reel_size - 1:
		row_index = 0
		
	var target_position = props.symbol_size * row_index
	
	return target_position

func _on_spin_timer_timeout():
	spin_timer.stop()

func get_result()->int:
	return result_symbol_nodes[1].symbol_id
