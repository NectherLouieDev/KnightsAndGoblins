class_name BaseGameState extends Node

@onready var game_manager: GameManager = %GameManager

var id: DataGameplay.GameState

func enter():
	print("GameState enter()->", id)
	pass
	
func exit():
	print("GameState exit()->", id)
	pass
