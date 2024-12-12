extends Node


var levels = {
	"Level1": {
		"unlocked" : false,
		"score": 0,
		"max_score": 0,
		"coins": 0,
		"max_coins": 0,
		"damage_taken": 0,
		"unlocks": "Level2",
		"beaten": false
	}
}

func generate_level(level):
	if level not in levels:
		levels[level] = {
			"unlocked" : false,
			"score": 0,
			"max_score": 0,
			"coins": 0,
			"max_coins": 0,
			"damage_taken": 0,
			"unlocks": "Level2",
			"beaten": false
		}

func generate_level_id(level):
	var level_id = ""
	for character in level:
		if character.is_valid_int():
			level_id += character
	level_id = int(level_id) + 1
	return "Level" + str(level_id)
	
func update_level(level, score, max_score, coins, max_coins, damage_taken, beaten):
	levels[level]["score"] = score
	levels[level]["max_score"] = max_score
	levels[level]["coins"] = coins
	levels[level]["max_coins"] = max_coins
	levels[level]["damage_taken"] = damage_taken
	levels[level]["beaten"] = beaten
	print(levels)

#func _ready() -> void:
	#generate_level("Level2")
	#print(levels)	
