extends Node

# Conversion rates
const BRONZE_TO_SILVER = 100
const SILVER_TO_GOLD = 100

# Function to convert bronze, silver, and gold
func convert_currency(bronze: int, silver: int, gold: int) -> Dictionary:
	# Convert bronze to silver
	silver += bronze / BRONZE_TO_SILVER
	bronze = bronze % BRONZE_TO_SILVER
	
	# Convert silver to gold
	gold += silver / SILVER_TO_GOLD
	silver = silver % SILVER_TO_GOLD
	
	return {"gold": gold, "silver": silver, "bronze": bronze}

func _ready():
	var bronze = 2500
	var silver = 75
	var gold = 3
	
	var result = convert_currency(bronze, silver, gold)
	print("Gold: %d, Silver: %d, Bronze: %d" % [result["gold"], result["silver"], result["bronze"]])
