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
	multiplayer.multiplayer_peer.peer_connected.connect(
		func(id):
			multiplayer_connected(id)
			Global.multiplayer_PlayerSymbol = Global.player1
	)

func _on_multiplayer_key_edit_text_submitted(new_text: String) -> void:
	var client = IrohClient.connect(new_text)
	multiplayer.multiplayer_peer = client
	multiplayer.multiplayer_peer.peer_connected.connect(
			func(id):
				multiplayer_connected(id)
				Global.multiplayer_PlayerSymbol = Global.player2
	)
	print("Connected")

func multiplayer_connected(id):
	player_joined_label.text = ("Server Connected id:" + str(id))
	print ("Connected id " + str(id))
	Global.is_multiplayer = true
	Global.multiplayer_PlayerSymbol = Global.player2
	Global.multiplayer_opponentID = id
	Global.clear_grid()

func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(connection_string)
