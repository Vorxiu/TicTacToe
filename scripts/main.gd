extends Control

@onready var grid_button_1: TouchScreenButton = $gridButton_1
@onready var grid_button_2: TouchScreenButton = $gridButton_2
@onready var grid_button_3: TouchScreenButton = $gridButton_3
@onready var grid_button_4: TouchScreenButton = $gridButton_4
@onready var grid_button_5: TouchScreenButton = $gridButton_5
@onready var grid_button_6: TouchScreenButton = $gridButton_6
@onready var grid_button_7: TouchScreenButton = $gridButton_7
@onready var grid_button_8: TouchScreenButton = $gridButton_8
@onready var grid_button_9: TouchScreenButton = $gridButton_9

@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var label_5: Label = $Label5
@onready var label_6: Label = $Label6
@onready var label_7: Label = $Label7
@onready var label_8: Label = $Label8
@onready var label_9: Label = $Label9

#UI
@onready var ttt_header: Label = $"../../header/ttt_header"
@onready var turn_display: Label = $"../../header/turn_display"
@onready var score_display: Label = $"../../score_display"
@onready var reload_button: TouchScreenButton = $reload_button
@onready var gridwindow: Control = $".."
# Audio
@onready var button_press: AudioStreamPlayer2D = $"../../button_press"
@onready var insert_sound: AudioStreamPlayer2D = $"../../insert_sound"

# Options menu
@onready var game_options: Control = $"../../changemode/game_options"
@onready var game_options_window: Control = $"../../changemode/game_options"
@onready var option_window: ColorRect = $"../../changemode/game_options/Option_window"
@onready var game_options_labels: Label = $"../../changemode/game_options/Option_window/GameOptions"
@onready var button_game_options: TouchScreenButton = $"../../changemode/button_gameOptions"
@onready var option_menu_animation: AnimationPlayer = $"../../changemode/Option_menu_animation"

# Game mode buttons
@onready var h_slider: HSlider = $"../../changemode/game_options/Option_window/HSlider"
@onready var pvp_button: Button = $"../../changemode/game_options/Option_window/pvp_button"
@onready var easy_button: Button = $"../../changemode/game_options/Option_window/easy_button"
@onready var bot_button: Button = $"../../changemode/game_options/Option_window/bot_button"
@onready var expert_button: Button = $"../../changemode/game_options/Option_window/expert_button"
@onready var resume: Button = $"../../changemode/game_options/Option_window/resume"

@onready var multiplayer_window: Control = $"../../changemode/multiplayer_window"

var bot_script = preload("res://scripts/bots.gd")
var bot = bot_script.new()

func _ready() -> void:
	var tween = get_tree().create_tween()
	Global.load_game()
	Global.clear_grid()
	Global.grid_updated.connect(_on_tictactoe_mainwindow_grid_updated)
	update_grid()
	Global.turn_count = 1
	score_display.visible = false
	game_options.visible = false
	gridwindow.visible = true
	reload_button.visible = false
	multiplayer_window.visible = false
	tween.tween_property(ttt_header, "visible_ratio", 1.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	Global.Player_turn = Global.player1
	set_turnLabeltext("Player " + str(Global.Player_turn) + " turn")

# signal for when grid is changed 
func _on_tictactoe_mainwindow_grid_updated() -> void:
	insert_sound.pitch_scale = randf_range(0.9, 1.2)
	insert_sound.play()
	update_grid()
	if !get_tree().paused and Global.turn_count > 5:
		get_winner()

func _on_grid_button_1_released() -> void:
	play_turn(0, 0)

func _on_grid_button_2_released() -> void:
	play_turn(0, 1)

func _on_grid_button_3_released() -> void:
	play_turn(0, 2)

func _on_grid_button_4_released() -> void:
	play_turn(1, 0)

func _on_grid_button_5_released() -> void:
	play_turn(1, 1)

func _on_grid_button_6_released() -> void:
	play_turn(1, 2)

func _on_grid_button_7_released() -> void:
	play_turn(2, 0)

func _on_grid_button_8_released() -> void:
	play_turn(2, 1)

func _on_grid_button_9_released() -> void:
	play_turn(2, 2)

# starting ui buttons
func _on_reload_button_released() -> void:
	get_tree().paused = false
	score_display.visible = false
	get_tree().reload_current_scene()

func _on_button_game_options_pressed() -> void:
	button_press.play()
	game_options.visible = true
	gridwindow.visible = false
	get_tree().paused = true
	ttt_header.visible = false
	option_menu_animation.play("option")

# Options menu h
func _on_pvp_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 0
		button_press.pitch_scale = randf_range(0.9, 1.2)
		button_press.play()

func _on_easy_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 1
		button_press.pitch_scale = randf_range(0.9, 1.2)
		button_press.play()

func _on_bot_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 2
		button_press.pitch_scale = randf_range(0.9, 1.2)
		button_press.play()

func _on_expert_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 3
		button_press.pitch_scale = randf_range(0.9, 1.2)
		button_press.play()

func _on_resume_pressed() -> void:
	gridwindow.visible = true
	multiplayer_window.visible = false
	get_tree().paused = false
	Global.save_game()
	option_menu_animation.play_backwards("option")
	ttt_header.visible = true
	button_press.pitch_scale = randf_range(0.9, 1.2)
	button_press.play()

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)
	button_press.pitch_scale = randf_range(0.9, 1.2)
	button_press.play()

func _on_multiplayer_button_pressed() -> void:
	multiplayer_window.visible = true
	game_options.visible = false
	button_press.pitch_scale = randf_range(0.9, 1.2)
	button_press.play()


func update_grid():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	var anim_time = 0.1
	if Global.Player_turn == Global.player1:
		anim_time += anim_time
	var move1

	if Global.GRID[0][0] != "" and label_1.text == "":
		move1 = Global.GRID[0][0]
		tween.tween_property(label_1, "text", move1, anim_time)
		grid_button_1.visible = false
	
	if Global.GRID[0][1] != "" and label_2.text == "":
		move1 = Global.GRID[0][1]
		tween.tween_property(label_2, "text", move1, anim_time)
		grid_button_2.visible = false

	if Global.GRID[0][2] != "" and label_3.text == "":
		move1 = Global.GRID[0][2]
		tween.tween_property(label_3, "text", move1, anim_time)
		grid_button_3.visible = false

	if Global.GRID[1][0] != "" and label_4.text == "":
		move1 = Global.GRID[1][0]
		tween.tween_property(label_4, "text", move1, anim_time)
		grid_button_4.visible = false

	if Global.GRID[1][1] != "" and label_5.text == "":
		move1 = Global.GRID[1][1]
		tween.tween_property(label_5, "text", move1, anim_time)
		grid_button_5.visible = false

	if Global.GRID[1][2] != "" and label_6.text == "":
		move1 = Global.GRID[1][2]
		tween.tween_property(label_6, "text", move1, anim_time)
		grid_button_6.visible = false

	if Global.GRID[2][0] != "" and label_7.text == "":
		move1 = Global.GRID[2][0]
		tween.tween_property(label_7, "text", move1, anim_time)
		grid_button_7.visible = false

	if Global.GRID[2][1] != "" and label_8.text == "":
		move1 = Global.GRID[2][1]
		tween.tween_property(label_8, "text", move1, anim_time)
		grid_button_8.visible = false

	if Global.GRID[2][2] != "" and label_9.text == "":
		move1 = Global.GRID[2][2]
		tween.tween_property(label_9, "text", move1, anim_time)
		grid_button_9.visible = false

#=========================================================-

func check_win_condition():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	var win_anim_time = 0.08
	var win_color = Color("#63A375")#Green color ||| Color("#B80C09") #Red color
	
	#Check diagonally
	if Global.GRID[0][0] != '' and Global.GRID[0][0] == Global.GRID[1][1] and Global.GRID[0][0] == Global.GRID[2][2]:
		win_color = Color("#B80C09") if (Global.GRID[0][0] != Global.multiplayer_PlayerSymbol and Global.is_multiplayer) or (Global.tictactoe_mode != 0  and  Global.GRID[0][0] == Global.player2) else Color("#63A375") #Red color
		tween.tween_property(label_1, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT) # label_1
		tween.tween_property(label_5, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT) # label_5
		tween.tween_property(label_9, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT) # label_9
		return true
 
	if Global.GRID[0][2] != '' and Global.GRID[0][2] == Global.GRID[1][1] and Global.GRID[0][2] == Global.GRID[2][0]:
		win_color = Color("#B80C09") if (Global.GRID[0][2] != Global.multiplayer_PlayerSymbol and Global.is_multiplayer) or (Global.tictactoe_mode != 0  and  Global.GRID[0][2] == Global.player2) else Color("#63A375")
		tween.tween_property(label_3, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(label_5, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(label_7, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		return true

	#Checks each row for matching row,,#r = list number,c = position in the list
	for i in range(0, 3): 
		if Global.GRID[i][0] != '' and Global.GRID[i][0] == Global.GRID[i][1] and Global.GRID[i][0] == Global.GRID[i][2]:
			win_color = Color("#B80C09") if (Global.GRID[i][0] != Global.multiplayer_PlayerSymbol and Global.is_multiplayer) or (Global.tictactoe_mode != 0  and  Global.GRID[i][0] == Global.player2) else Color("#63A375")
			if i == 0:
				tween.tween_property(label_1, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_2, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_3, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			elif i == 1:
				tween.tween_property(label_4, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_5, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_6, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			elif i == 2:
				tween.tween_property(label_7, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_8, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_9, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			return true

	#Checks each column for matching column
	for i in range(0, 3): 
		if Global.GRID[0][i] != '' and Global.GRID[0][i] == Global.GRID[1][i] and Global.GRID[0][i] == Global.GRID[2][i]:
			win_color = Color("#B80C09") if (Global.GRID[0][i] != Global.multiplayer_PlayerSymbol and Global.is_multiplayer) or (Global.tictactoe_mode != 0  and  Global.GRID[0][i] == Global.player2) else Color("#63A375")
			if i == 0:
				tween.tween_property(label_1, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_4, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_7, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			elif i == 1:
				tween.tween_property(label_2, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_5, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_8, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			elif i == 2:
				tween.tween_property(label_3, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_6, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(label_9, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			return true
	return false

func draw_anim():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.parallel()
	var anim_time = 0.01
	var color = Color("#E08E45")
	tween.tween_property(label_1, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_2, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_3, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_4, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_5, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_6, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_7, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_8, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_9, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

# =================================Main Logic================================================
func play_turn(r: int, c: int):

	if Global.is_multiplayer:
		if Global.Player_turn != Global.multiplayer_PlayerSymbol:
			return
		make_move.rpc(r, c, Global.multiplayer_PlayerSymbol)
	else:
		Global.turn_count += 1
		#inserts the move
		Global.grid_changed(r, c, Global.Player_turn)
		# Swaps the player move
		if (Global.Player_turn == Global.player1): # if X
			Global.Player_turn = Global.player2
		elif (Global.Player_turn == Global.player2):
			Global.Player_turn = Global.player1

		set_turnLabeltext("Player " + str(Global.Player_turn) + " turn")
		_on_tictactoe_mainwindow_grid_updated()
		# Bot turn
		if Global.tictactoe_mode != 0  and Global.Player_turn == Global.player2 and Global.turn_count <= 9:
			var b_move = bot.bot_turn()
			play_turn(b_move[0], b_move[1])

func get_winner():
	if Global.turn_count < 5:
		return
	var move
	# checks who made the move
	if (Global.Player_turn == Global.player1): # if X
		move = Global.player2
	elif (Global.Player_turn == Global.player2):
		move = Global.player1
	
	# checks the win condition
	if Global.turn_count > 4:
		if check_win_condition():
			set_turnLabeltext("Player " + str(move) + " Won")
			turn_display.text = ("Player " + str(move) + " Won")
			if move == Global.player1:
				Global.P1_WinCount += 1
			elif move == Global.player2:
				Global.P2_WinCount += 1
			game_finished()
			return
		elif Global.turn_count >= 9 and bot.available_moves().is_empty():
			# Condition for draw
			draw_anim()
			set_turnLabeltext("Its a draw!")
			game_finished()

# WHen any win condition is met
func game_finished():
	get_tree().paused = true
	reload_button.visible = true
	score_display.visible = true
	score_display.text = "Player " + str(Global.player1) + "  " + str(Global.P1_WinCount) + "                                   Player " + str(Global.player2) + "  " + str(Global.P2_WinCount)

@rpc("authority","call_local")
func set_turnLabeltext(toast: String):
	turn_display.visible_ratio = 0.1
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(turn_display, "visible_ratio", 1.0, 0.25).set_ease(Tween.EASE_IN)
	turn_display.text = toast

# Multiplayer Code
# This RPC is called by a player to make a move
@rpc("any_peer", "call_local", "reliable")
func make_move(row: int, col: int, player_symbol: String):
	# If we're the server, validate the move
	if multiplayer.is_server():
		if Global.GRID[row][col] == "" and Global.Player_turn == player_symbol:
			process_valid_move.rpc(row, col, player_symbol)
		else:
			print("Invalid move")

# This RPC is called by the server to confirm a valid move to all clients
@rpc("authority", "call_local", "reliable")
func process_valid_move(row: int, col: int, player_symbol: String):
	Global.grid_changed(row, col, player_symbol)
	Global.turn_count += 1
	if player_symbol == Global.player1:
		Global.Player_turn = Global.player2
	else:
		Global.Player_turn = Global.player1
		 
	set_turnLabeltext("Player " + str(Global.Player_turn) + " turn")
	_on_tictactoe_mainwindow_grid_updated()
