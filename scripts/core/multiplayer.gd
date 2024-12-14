extends Node2D

@export var Address = "127.0.0.1"
@export var port = 8910
var peer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peerConnected)
	multiplayer.peer_disconnected.connect(peerDisconnected)
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(connectionFailed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
	pass # Replace with func tion body.

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	
	if error != OK:
		print("cannot host: " + str(error))
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	print("Waiting for players!")
	
	
	GameManage.host()
func connectedToServer():
	print("Connected to server")
	sendPlayerInfo.rpc_id(1, $CanvasLayer/ColorRect/VBoxContainer/LineEdit.text, multiplayer.get_unique_id())
	
func connectionFailed(id):
	print("Couldnt connect")

func peerConnected(id):
	print("player connected " + str(id))
	
func peerDisconnected(id):
	print("player disconnected " + str(id))

func _on_host_pressed() -> void:
	hostGame()
	sendPlayerInfo( $CanvasLayer/ColorRect/VBoxContainer/LineEdit.text, multiplayer.get_unique_id())



func _on_join_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	GameManage.join()


@rpc("any_peer","call_local")
func StartGame():
	
	get_tree().change_scene_to_file("res://scenes/worldScenes/Level0.tscn")
	
	self.hide()
	


@rpc	("any_peer")
func sendPlayerInfo(name,id):
	if !MultiplayerManager.players.has(id):
		MultiplayerManager.players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	if multiplayer.is_server():
		for i in MultiplayerManager.players:
			sendPlayerInfo.rpc(MultiplayerManager.players[i].name, i)
			
func _on_start_game_pressed() -> void:
	StartGame.rpc()
	pass # Replace with function body.


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/worldScenes/menu.tscn")
