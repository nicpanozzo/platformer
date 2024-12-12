extends Node2D

@export var isActive = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		isActive = true
		$AnimatableBody2D/AnimationPlayer.play("Move")



func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		isActive = false

func repeatIfNecessary():
	if isActive:
		$AnimatableBody2D/AnimationPlayer.play("Move")
