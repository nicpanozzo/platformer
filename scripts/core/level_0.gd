extends Node2D

@export var playerScene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index= 0
	for i in MultiplayerManager.players:
		var currentPlayer = playerScene.instantiate()
		currentPlayer.name = str(MultiplayerManager.players[i].id)
		
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
