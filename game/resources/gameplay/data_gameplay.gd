class_name DataGameplay extends Resource

signal spins_left_updated_signal()

@export var spins_left_reset: int = 100
@export var spins_left: int = 100

func decrease_spins_left() -> void:
	spins_left -= 1
	spins_left_updated_signal.emit()
	
func increase_spins_left(value) -> void:
	spins_left += value
	spins_left_updated_signal.emit()

func  get_spins_left_label() -> String:
	return str(spins_left)
