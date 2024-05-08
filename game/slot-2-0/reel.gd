extends Node2D

const SYMBOL_NODE = preload("res://game/slot-2-0/symbol-node.tscn")

var symbol_nodes = []

var spin_timer
var symbol_height = 128

var top_y = 0
var bot_y = 0

var totes = 0

func _ready():
	spin_timer = $"../Timer"
	var symbol_count = 3
	for i in range(symbol_count):
		var symbol_node = SYMBOL_NODE.instantiate()
		symbol_node.position.y = i * symbol_height
		add_child(symbol_node)
		symbol_nodes.append(symbol_node)
		symbol_node.init(i)
	
	top_y = 0;
	bot_y = top_y + (symbol_height * symbol_count)

func _process(delta):
	var ten = 10
	if spin_timer.time_left > 0:
		for i in range(symbol_nodes.size()):
			var symbol_node = symbol_nodes[i]
			symbol_node.position.y += symbol_height * delta * ten
			
			var distance_offset = ten * delta
			if symbol_node.position.y + distance_offset > bot_y:
				symbol_node.position.y = top_y

func _on_spin_button_button_down():
	print("start----------")
	for i in range(symbol_nodes.size()):
		var symbol_node = symbol_nodes[i]
		print("symbol_node.y: ", symbol_node.position.y)
	
	spin_timer.start()

func _on_timer_timeout():
	print("stop----------")
	spin_timer.stop()
	for i in range(symbol_nodes.size()):
		var symbol_node = symbol_nodes[i]
		print("symbol_node.y: ", symbol_node.position.y)

func get_closest_number(target: float, number1: float, number2: float) -> float:
	var diff1 = abs(target - number1)
	var diff2 = abs(target - number2)
	
	if diff1 < diff2:
		return number1
	else:
		return number2
