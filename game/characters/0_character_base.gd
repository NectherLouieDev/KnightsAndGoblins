class_name CharacterBase

extends Node

signal attack_animation_started()
signal attack_animation_complete()

var data_troop: DataTroop
var target

func spawn_init(new_data_troop, new_target):
	data_troop = new_data_troop

func get_troop_type() -> int:
	return data_troop.troop_atk_type

func get_target():
	return target


