extends Node

var players_label

var players = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_score(player_id, value)->void:
	print(player_id, value)
	for i in players:
		if str(players[i].id) == str(player_id):
			players[i].score += value
	print(players)

func update_players_label():
	if players_label is Node:
		players_label.text = players_list()

func update_coins(player_name, coins):
	
	update_score(player_name,coins)
	update_players_label()
	#pass

func players_list() -> String:
	var players_list = ""
	print("PP")
	for id in players:
		players_list += str(players[id].name) + " " + str(players[id].score) + "\n"
	return players_list
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func peerDisconnected(id):
	print("player disconnected " + str(id))
	players.erase(id)
	print(players)
	removePlayer(str(id))
	update_players_label()

func removePlayer(name: String):
	var playersNodes = get_tree().get_nodes_in_group("Player")
	for player in playersNodes:
		if player.name == name:
			player.queue_free()
