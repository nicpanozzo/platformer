extends Node
class_name RunTimeLevel

@onready var level = name
var max_score = 0
var max_coins = 0

func _ready() -> void:
	GameManage.level_beaten.connect(beat_level)
	set_values()

func set_values():
	for node in get_children():
		if node is Coin:
			max_score += node.SCORE_VALUE
			max_coins += node.COINS
			
		if node is Saber or node is Cannon:
			max_score += node.SCORE_VALUE


func beat_level():
	print("BEARTEN" + level)
	LevelData.generate_level(LevelData.levels[level]["unlocks"])
	LevelData.levels[LevelData.levels[level]["unlocks"]]["unlocked"] = true
	
	LevelData.update_level(level, GameManage.score, max_score, GameManage.coins, max_coins, GameManage.damage_taken, true)
