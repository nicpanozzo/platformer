extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_basic_level_pressed() -> void:
	GameManage.go_to_level(0)

func _on_level_1_pressed() -> void:
	GameManage.go_to_level(1)


func _on_multiplayer_pressed() -> void:
	GameManage.go_to_multiplayer()
