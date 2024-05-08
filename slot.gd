extends Node2D

# Define the symbols for each reel
var reel1_symbols = [1, 2, 3]

# Define the winning combinations
var winning_combinations = [
	[[1, 1, 1], 100],  # Example winning combination: 3 of symbol 1 gives a win of 100
	[[2, 2, 2], 200],  # Example winning combination: 3 of symbol 2 gives a win of 200
	# Add more winning combinations here...
]

# Reference to the reel nodes
var reel1_node

# Timer reference for spinning animation
var spin_timer

# Animation parameters
var spin_duration = 1.5  # Duration of the spinning animation in seconds
var symbol_height = 64  # Height of each symbol
var symbols_per_second = 2.007 #3.345(5)-Base #2.007(3) # # Number of symbols to show per second during spinning
# to calculate symbols per second
# base_sps=3.345, base_len=5, target_len=n
# target_sps = (base_sps * target_len) / base_len
var speed = 3

# Variables to keep track of the animation progress
var reel1_position = 0.0
var total_distance = 0.0
var target_distance = 0.0

var ICON1 = load("res://game/assets/user-interface/02.png")
var ICON2 = load("res://game/assets/user-interface/05.png") 
var ICON3 = load("res://game/assets/user-interface/01.png")

var reel1_initial_positions = []
func _ready():
	# Get references to the reel nodes
	reel1_node = $Reel1

	# Get reference to the timer
	spin_timer = $Timer
	
	var txs = [ICON1, ICON2, ICON3]
	
	# Create child nodes for each symbol in each reel
	for symbol_index in range(reel1_symbols.size()):
		var symbol_node = Sprite2D.new()
		var v = txs[randi() % txs.size()]
		symbol_node.texture = v
		symbol_node.position.y = symbol_index * symbol_height
		reel1_node.add_child(symbol_node)

	# Calculate the total distance to complete the animation
	total_distance = symbol_height * symbols_per_second * spin_duration
	
	# Store the initial positions of the symbol nodes
	for child in reel1_node.get_children():
		reel1_initial_positions.append(child.position.y)

# Function to start the spin animation
func start_spin():
	# Calculate the target distance for each reel
	var t = randi() % reel1_symbols.size()
	print("t: ", t)
	target_distance = [
		symbol_height * (t),
	]
	
	# Reset the positions
	reel1_position = 0.0
	
	# Start the spinning animation
	spin_timer.start()

# Function called on each frame during the spinning animation
func _process(delta):
	if spin_timer.time_left > 0:
		# Calculate the positions for each reel based on the animation progress
		reel1_position += (symbol_height * symbols_per_second * delta) * speed
		
		# Update the positions of the symbol nodes
		for i in range(reel1_node.get_child_count()):
			var child = reel1_node.get_child(i)
			child.position.y = fmod(reel1_initial_positions[i] + reel1_position, total_distance)

# Function to stop the spin animation and display the final results
func stop_spin():
	spin_timer.stop()
	
	# Calculate the final symbol index for each reel
	#var reel1_index = int(reel1_position / symbol_height) % reel1_symbols.size()

	# Set the final symbol texture for each reel sprite
	#var reel1_sprite = reel1_node.get_child(reel1_index)

	# Display the final symbols
	#reel1_sprite.visible = true
	
	# Calculate the line win
	#var win_amount = calculate_line_win(reel1_symbols[reel1_index], reel2_symbols[reel2_index], reel3_symbols[reel3_index])
	
	#if win_amount > 0:
		## Handle the win
		#handle_win(win_amount)

# Function to calculate a line win
func calculate_line_win(symbol1, symbol2, symbol3):
	var win_amount = 0

	for combination in winning_combinations:
		if symbol1 == combination[0][0] and symbol2 == combination[0][1] and symbol3 == combination[0][2]:
			win_amount = combination[1]
			break

	return win_amount

# Function to handle a win
#func handle_win(win_amount):
	# Updatethe code to handle the win can vary depending on your game's requirements. Here's a simple example of how you can update the `handle_win` function to display the win amount:

#```gdscript
func handle_win(win_amount):
	# Update the code based on your game's requirements
	print("Congratulations! You won: $" + str(win_amount))


func _on_start_button_pressed():
	start_spin()


func _on_stop_button_pressed():
	stop_spin()

func _on_timer_timeout():
	print("_on_Timer_timeout")
	stop_spin()
