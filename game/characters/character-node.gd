class_name CharacterNode

extends Node

signal attack_animation_started()
signal attack_animation_complete()

var troop_type = SpawnConfig.TROOP_TYPE.MELEE

func get_troop_type() -> int:
	return troop_type

func set_troop_type(new_troop_type) -> void:
	troop_type = new_troop_type

func spawn_init(new_target):
	set_troop_type(SpawnConfig.TROOP_TYPE.MELEE)
