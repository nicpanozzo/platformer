extends Node2D

@export var speed = 160.0

var current_speed = 0.0

@onready var spawn_position = global_position



func _physics_process(delta: float) -> void:
	position.y += current_speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		$AnimationPlayer.play("Shake")
		
func fall():
	current_speed = speed
	await get_tree().create_timer(2).timeout
	position = spawn_position
	current_speed = 0

		

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		var player: Player = area.get_parent()
		player.take_damage(2)
