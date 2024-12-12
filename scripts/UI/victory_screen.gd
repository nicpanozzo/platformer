extends Node2D


func _ready() -> void:
	GameManage.gained_coins.connect(victory_display)
	$CanvasLayer.hide()
	
func victory_display(gained_coins):
	if GameManage.coins >= 20:
		$CanvasLayer.show()
	else: 
		$CanvasLayer.hide()


func _on_button_pressed() -> void:
	$CanvasLayer.hide()
