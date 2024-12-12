extends Node2D
class_name Checkpoint

@export var spawnpoint = false
@export var win_condition = false

var activated = false

func _ready() -> void:
	if spawnpoint:
		activate()

func activate():
	
	if win_condition:
		GameManage.win()
	
	GameManage.current_checkpoint = self
	activated = true
	
	$AnimationPlayer.play("Activated")
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and !activated:
		activate()
