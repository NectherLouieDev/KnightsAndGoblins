class_name SlotMachine

extends Node2D

signal  spin_started_signal()
signal  spin_complete_signal()

@export var reels_mask: Control

var reelstrips: Array = []
var reel_count = 5
var reel_index = 0

@export var stagger_timer: Timer
@export var spin_button: Button

func create_slot_machine():
	reelstrips = []
	
	for i in range(reel_count):
		var reelstrip = SlotConfig.REELSTRIP.instantiate()
		reelstrip.position.x = (i * SlotConfig.SYMBOL_SIZE) + 60
		reels_mask.add_child(reelstrip)
		reelstrips.append(reelstrip)
		if i == reel_count - 1:
			reelstrip.connect("spin_complete", _on_spin_complete)
	
	# create strips and symbols
	for i in range(reelstrips.size()):
		var reelstrip = reelstrips[i]
		reelstrip.init(i)
		reelstrip.create_symbols()

func _on_spin_button_pressed():
	emit_signal("spin_started_signal")
	stagger_timer.start()

func _on_spin_complete():
	emit_signal("spin_complete_signal")

func enable_spin_button():
	spin_button.disabled = false

func disable_spin_button():
	spin_button.disabled = true
	
func _on_timer_timeout():
	var reelstrip = reelstrips[reel_index]
	reelstrip.start_spin()
	reel_index += 1
	
	if (reel_index >= reelstrips.size()):
		reel_index = 0
		stagger_timer.stop()

func get_spin_result()->Array:
	var output: Array = []
	for i in range(reelstrips.size()):
		var reelstrip = reelstrips[i] as Reelstrip
		output.append(reelstrip.get_result())
	
	return output
