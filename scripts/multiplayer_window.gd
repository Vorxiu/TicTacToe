extends Control
@onready var mp_key_label: Label = $MP_key_label
@onready var multiplayer_window: Control = $"."
@onready var player_joined_label: Label = $playerJoined_label
@onready var button_press: AudioStreamPlayer2D = $"../../button_press"
@onready var player_joined: AudioStreamPlayer2D = $player_joined
@onready var server_started: AudioStreamPlayer2D = $server_started
@onready var gridwindow: Control = $"../../Gridwindow"
@onready var option_menu_animation: AnimationPlayer = $"../Option_menu_animation"
@onready var ttt_header: Label = $"../../header/ttt_header"
@onready var multiplayer_status: Label = $"../../multiplayer_status/Multiplayer_status"
var connection_string = "Couldn't connect"

func _ready() -> void:
	#multiplayer.connection_failed.connect(_on_connection_failed)
	#multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
func _on_server_disconnected():
	Global.connection_status = "disconnected"
	print(Global.connection_status)
	Global.is_multiplayer = false

func _on_start_server_key_pressed() -> void:
	button_press.pitch_scale = randf_range(0.9, 1.2)
	button_press.play()
	var server := IrohServer.start() 
	multiplayer.multiplayer_peer = server
	connection_string = server.connection_string()
	mp_key_label.text = connection_string
	if server == null:
		player_joined_label.text = "Failed to initialize server"
	else:
		player_joined_label.text = "Started Server"
		DisplayServer.clipboard_set(connection_string)
	multiplayer.multiplayer_peer.peer_connected.connect(
		func(id):
			player_joined_label.text = "Server hosted with id" + str(id)
			multiplayer_connected(id)
			Global.multiplayer_PlayerSymbol = Global.player1
	)

func _on_multiplayer_key_edit_text_submitted(new_text: String) -> void:
	button_press.pitch_scale = randf_range(1.1, 1.2)
	button_press.play()
	var client = IrohClient.connect(new_text)
	multiplayer.multiplayer_peer = client
	player_joined_label.text = "Joining Server"
	if client == null:
		player_joined_label.text = "Failed to intialize client"
	multiplayer.connection_failed.connect(func():
		player_joined_label.text = "Connection error: "+ str(client.connection_error())
		Global.is_multiplayer = false
		)
	multiplayer.multiplayer_peer.peer_connected.connect(
			func(id):
				player_joined_label.text = "Player connected with id" + str(id)
				multiplayer_connected(id)
				Global.multiplayer_PlayerSymbol = Global.player2
	)

func multiplayer_connected(id):
	Global.clear_grid()

	if id == 1:
		player_joined_label.text = ("Player Connected id: " + str(id))
		
		server_started.play()
	else:
		player_joined_label.text = ("Server Connected id: " + str(id))
		player_joined.play()
	print ("Connected id " + str(id))
	Global.is_multiplayer = true
	#Global.multiplayer_opponentID = id
	Global.tictactoe_mode = 0
	gridwindow.visible = true
	multiplayer_window.visible = false
	get_tree().paused = false
	option_menu_animation.play_backwards("option")
	ttt_header.visible = true
	Global.connection_status = "Connected"

func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(connection_string)
	button_press.play()
