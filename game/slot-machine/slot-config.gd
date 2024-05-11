class_name SlotConfig

extends Node2D

# Symbols
enum SYMBOL_ENUM {
	WARRIOR, ARCHER, TORCHER, THROWER
}
const SYMBOL_NODE = preload("res://game/slot-machine/symbols/symbol_node.tscn")
const SYMBOL_WARRIOR = preload("res://game/slot-machine/symbols/symbol_warrior.tscn")
const SYMBOL_ARCHER = preload("res://game/slot-machine/symbols/symbol_archer.tscn")
const SYMBOL_TORCHER = preload("res://game/slot-machine/symbols/symbol_torcher.tscn")
const SYMBOL_THROWER = preload("res://game/slot-machine/symbols/symbol_thrower.tscn")

const SYMBOL_PRELOADS = {
	SYMBOL_ENUM.WARRIOR: SYMBOL_WARRIOR,
	SYMBOL_ENUM.ARCHER: SYMBOL_ARCHER,
	SYMBOL_ENUM.TORCHER: SYMBOL_TORCHER,
	SYMBOL_ENUM.THROWER: SYMBOL_THROWER
}

# Reelstrip
const SYMBOL_SIZE = 128
const REELSTRIP = preload("res://game/slot-machine/reelstrip.tscn")
const REELSTRIP_MODEL = [
	SYMBOL_ENUM.ARCHER,
	SYMBOL_ENUM.ARCHER,
	SYMBOL_ENUM.ARCHER,
	SYMBOL_ENUM.ARCHER,
	SYMBOL_ENUM.WARRIOR,
	SYMBOL_ENUM.WARRIOR,
	SYMBOL_ENUM.WARRIOR,
	SYMBOL_ENUM.WARRIOR,
	SYMBOL_ENUM.TORCHER,
	SYMBOL_ENUM.TORCHER,
	SYMBOL_ENUM.TORCHER,
	SYMBOL_ENUM.THROWER,
	SYMBOL_ENUM.THROWER
]
