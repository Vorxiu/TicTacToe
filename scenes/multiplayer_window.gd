extends Control
@onready var mp_key_label: Label = $MP_key_label
@onready var multiplayer_window: Control = $"."
@onready var player_joined_label: Label = $playerJoined_label

var connection_string = "temp"
func _on_start_server_key_pressed() -> void:
	var server := IrohServer.start()
	multiplayer.multiplayer_peer = server
	connection_string = server.connection_string()
	mp_key_label.text = connection_string
	
	multiplayer.multiplayer_peer.peer_connected.connect(

		func(pid):
			player_joined_label.text = ("Player joined " + str(pid))
			print ("Player joined " + str(pid))
			
	)

func _on_multiplayer_key_edit_text_submitted(new_text: String) -> void:
	var client = IrohClient.connect(new_text)
	multiplayer.multiplayer_peer = client
	print("Connected")

func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(connection_string)
