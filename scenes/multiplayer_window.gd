extends Control
@onready var mp_key_label: Label = $MP_key_label
@onready var multiplayer_window: Control = $"."
var connection_string = "temp"
func _on_start_server_key_pressed() -> void:
	var server := IrohServer.start()
	multiplayer.multiplayer_peer = server
	
	mp_key_label.text = connection_string
	connection_string = server.connection_string()
	print("server started")

func _on_multiplayer_key_edit_text_submitted(new_text: String) -> void:
	var client = IrohClient.connect(new_text)
	multiplayer.multiplayer_peer = client
	#print(client.ConnectionStatus)
	print("Connected")
	


func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(connection_string)
