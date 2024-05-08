extends Node2D

@onready var slot_config = %SlotConfig
@onready var reels_mask = $SlotBanner/ReelsMask1

var reelstrips = []
var reel_count = 5
var reel_index = 0

@onready var stagger_timer = $StaggerTimer
@onready var spin_button = $SpinButtonGroup/SpinButton

func _ready():
	reelstrips = []
	
	for i in range(reel_count):
		var reelstrip = slot_config.REELSTRIP.instantiate()
		reelstrip.position.x = (i * slot_config.SYMBOL_SIZE) + 60
		reels_mask.add_child(reelstrip)
		reelstrips.append(reelstrip)
		if i == reel_count - 1:
			reelstrip.connect("spin_complete", _on_spin_complete)
	
	# create strips and symbols
	for i in range(reelstrips.size()):
		var reelstrip = reelstrips[i]
		reelstrip.init(slot_config, i)
		reelstrip.create_symbols()
	
	spin_button.disabled = false

func _on_spin_button_pressed():
	spin_button.disabled = true
	stagger_timer.start()

func _on_spin_complete():
	print("_on_spin_complete()->")
	spin_button.disabled = false
	
func _on_timer_timeout():
	var reelstrip = reelstrips[reel_index]
	reelstrip.start_spin()
	reel_index += 1
	
	if (reel_index >= reelstrips.size()):
		reel_index = 0
		stagger_timer.stop()
