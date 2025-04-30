extends Control
@onready var mp_key_label: Label = $MP_key_label
@onready var multiplayer_window: Control = $"."
@onready var player_joined_label: Label = $playerJoined_label

var connection_string = "Couldn't connect"
func _on_start_server_key_pressed() -> void:
	
	var server := IrohServer.start()
	multiplayer.multiplayer_peer = server
	connection_string = server.connection_string()
	mp_key_label.text = connection_string
	player_joined_label.text = "Starting server"
	if server == null:
		player_joined_label.text = "Failed to initialize server"
	multiplayer.multiplayer_peer.peer_connected.connect(
		func(id):
			player_joined_label.text = "Server hosted with id" + str(id)
			multiplayer_connected(id)
			Global.multiplayer_PlayerSymbol = Global.player1
	)

func _on_multiplayer_key_edit_text_submitted(new_text: String) -> void:
	var client = IrohClient.connect(new_text)
	multiplayer.multiplayer_peer = client
	player_joined_label.text = "Joining Server"
	if client == null:
		player_joined_label.text = "Failed to intialize client"
	multiplayer.connection_failed.connect(func():
		player_joined_label.text = "Connection error: "+ str(client.connection_error())
		)
	multiplayer.multiplayer_peer.peer_connected.connect(
			func(id):
				player_joined_label.text = "Player connected with id" + str(id)
				multiplayer_connected(id)
				Global.multiplayer_PlayerSymbol = Global.player2
	)

func multiplayer_connected(id):
	if id == 1:
		player_joined_label.text = ("Server Connected id: " + str(id))
	else:
		player_joined_label.text = ("Player Connected id: " + str(id))
	print ("Connected id " + str(id))
	Global.is_multiplayer = true
	#Global.multiplayer_opponentID = id
	Global.clear_grid()

func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(connection_string)
