class_name SpawnConfig

extends Node2D

const CHARACTER_WARRIOR = preload("res://game/characters/character_warrior.tscn")
const CHARACTER_ARCHER = preload("res://game/characters/character_archer.tscn")
const CHARACTER_TORCHER = preload("res://game/characters/character_torcher.tscn")
const CHARACTER_THROWER = preload("res://game/characters/character_thrower.tscn")

const CHARACTER_PRELOADS = {
	SlotConfig.SYMBOL_ENUM.WARRIOR: CHARACTER_WARRIOR,
	SlotConfig.SYMBOL_ENUM.ARCHER: CHARACTER_ARCHER,
	SlotConfig.SYMBOL_ENUM.TORCHER: CHARACTER_TORCHER,
	SlotConfig.SYMBOL_ENUM.THROWER: CHARACTER_THROWER
}
