class_name DataTroop extends Resource

enum TROOP_ATK_TYPE {MELEE, RANGE}

@export var symbol_id: SlotConfig.SYMBOL_ENUM = SlotConfig.SYMBOL_ENUM.WARRIOR
@export var troop_atk_type: TROOP_ATK_TYPE
@export var sceneCharacter: PackedScene
@export var sceneProjectile: PackedScene
@export var level: int = 1
@export var damage: int = 10
@export var progress_ratio: float = 1
