extends Node
class_name GameManager

var current_checkpoint: Checkpoint
var player: Player

var pause_menu

signal gained_coins(int)
signal level_beaten()
var coins = 0
var damage_taken = 0

var pause = false
var win_screen
var score_label

var score: int	
	
func respawn_player():
	if current_checkpoint != null:
		player.healt = player.max_healt
		player.position = current_checkpoint.position


func gain_coins(coins_gained: int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	print(coins)


func win():
	print("WIN")
	win_screen.visible = true
	emit_signal("level_beaten")
	score_label.text = "Score: " + str(score)
	


func pause_play():
	pause = !pause
	pause_menu.visible = pause
	
	
func resume():
	get_tree().paused = false
	pause_play()

func restart():
	coins = 0
	score = 0
	current_checkpoint = null
	get_tree().reload_current_scene()
	pass
	
func worldMap():
	get_tree().change_scene_to_file("res://scenes/worldScenes/menu.tscn")

func go_to_level(n: int):
	var levelName = "res://scenes/worldScenes/Level" + str(n) +".tscn"
	get_tree().change_scene_to_file(levelName)

func go_to_multiplayer():
	var levelName = "res://scenes/worldScenes/multiplayer.tscn"
	get_tree().change_scene_to_file(levelName)
	

func host():
	pass
	
func join():
	pass
	
func go_to_lobby():
	pass

	
func quit():
	get_tree().quit()
	pass
