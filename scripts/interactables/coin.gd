extends Node2D
class_name Coin

var SCORE_VALUE = 10
var COINS = 1

var starting_pos

var scene = preload("res://scenes/Interactable/coin.tscn")
var parent_node  # To store the parent node before removing


func _ready() -> void:
	$AnimationPlayer.play("Idle")
	starting_pos = global_position
	parent_node = get_parent()  

func _on_area_2d_area_entered(area: Area2D) -> void:

	if area.get_parent() is PlayerMulti && is_visible_in_tree():
		var player_id = area.get_parent().name 
		MultiplayerManager.update_coins(player_id, COINS)
		pickup_item()
	GameManage.gain_coins(COINS)
	GameManage.score += SCORE_VALUE


func pickup_item():
	queue_free()
	#await get_tree().create_timer(10).timeout  # Wait for respawn_time
	#respawn_item()

func respawn_item():
	var new_item = scene.instantiate()  # Instantiate a new copy of the item
	parent_node.add_child(new_item)  # Add it back to the parent
	new_item.global_position = self.starting_pos   
	
	
