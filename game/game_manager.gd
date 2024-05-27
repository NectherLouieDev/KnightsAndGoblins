class_name GameManager extends Node

const DATA_GAMEPLAY = preload("res://game/resources/gameplay/data_gameplay.tres")
@export var game_state_array: Array[BaseGameState] = []
var game_state: BaseGameState

func _ready():
	change_state(DataGameplay.GameState.LOAD)

func change_state(id: DataGameplay.GameState):
	if game_state:
		game_state.exit()
	game_state = game_state_array[id]
	game_state.id = id
	DATA_GAMEPLAY.game_state_id = game_state.id
	game_state.enter()
