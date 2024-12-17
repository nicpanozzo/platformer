extends CanvasLayer


func _ready() -> void:
	GameManage.gained_coins.connect(update_coin_display)
	#GameManage.player.health_signal.connect(update_health)
	
	GameManage.pause_menu = $PauseMenu
	GameManage.win_screen = $WinScreen
	GameManage.score_label = $WinScreen/Label
	MultiplayerManager.players_label = $players
	MultiplayerManager.update_players_label()
	#$players.text = MultiplayerManager.players_list()
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManage.pause_play()
		get_tree().paused = GameManage.pause
		
	
func update_coin_display(gained_coins):
	$CoinDisplay.text = str(GameManage.coins)

func update_health(health):
	$HealthDisplay.text = str(GameManage.player.health)


func _on_resume_pressed() -> void:
	GameManage.resume()

func _on_restart_pressed() -> void:
	GameManage.restart()


func _on_world_map_pressed() -> void:
	GameManage.worldMap()


func _on_quit_pressed() -> void:
	GameManage.quit()


func _on_finish_level_pressed() -> void:
	GameManage.worldMap()
