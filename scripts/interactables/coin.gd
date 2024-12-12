extends Node2D
class_name Coin

var SCORE_VALUE = 10
var COINS = 1

func _ready() -> void:
	$AnimationPlayer.play("Idle")

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManage.gain_coins(COINS)
	GameManage.score += SCORE_VALUE
	queue_free()
