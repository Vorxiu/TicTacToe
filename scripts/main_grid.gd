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
@onready var reload_button: TouchScreenButton = $reload_button
@onready var gridwindow: Control = $".."
@onready var insert_sound: AudioStreamPlayer2D = $"../../insert_sound"
@onready var ttt_header: Label = $"../../header/ttt_header"
@onready var turn_display: Label = $"../../header/turn_display"
@onready var h_slider: HSlider = $"../../changemode/game_options/ColorRect/HSlider"
@onready var pvp_button: Button = $"../../changemode/game_options/ColorRect/pvp_button"
@onready var easy_button: Button = $"../../changemode/game_options/ColorRect/easy_button"
@onready var bot_button: Button = $"../../changemode/game_options/ColorRect/bot_button"
@onready var expert_button: Button = $"../../changemode/game_options/ColorRect/expert_button"
@onready var resume: Button = $"../../changemode/game_options/ColorRect/resume"
@onready var score_display: Label = $"../../score_display"
@onready var game_options: Control = $"../../changemode/game_options"
@onready var option_window: ColorRect = $"../../changemode/game_options/Option_window"
@onready var game_options_labels: Label = $"../../changemode/game_options/Option_window/GameOptions"
@onready var option_menu_animation: AnimationPlayer = $"../../changemode/Option_menu_animation"



var turn_count:int
@export var player1:String = "X"
@export var player2:String = "O"
var GRID = [['','',''],['','',''],['','','']]
#var mode:int = 0# 0 is pvp,1is easy bot,2is advanced bot

func _ready() -> void:
	Global.load_game()
	score_display.visible = false
	turn_count = 1
	game_options.visible = false
	gridwindow.visible = true
	#Global.Player_turn = true
	reload_button.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(ttt_header,"visible_ratio",1.0,0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	set_turnLabeltext("Player X turn")
	Global.Player_turn = true
	if Global.Player_turn:
		pass

func play_turn(r:int,c:int):
	var move:String = "C"
	turn_count += 1
	
	if(Global.Player_turn):#if true
		Global.Player_turn = false
		move = player1
		set_turnLabeltext("Player " + "O" + " turn")
	elif(!Global.Player_turn):
		Global.Player_turn = true
		move = player2
		set_turnLabeltext("Player " + "X" + " turn")
	#Inserts the move
	
	if GRID[r][c] == "":
		insert_sound.pitch_scale = randf_range(0.9,1.2)
		insert_sound.play()
		GRID[r][c] = insert_move(r,c,move) #r = list number,c = position in the list
	
	#checks the winner
	if turn_count > 4:
		if check_win_condition(false):
			set_turnLabeltext("Player " + str(move) + " Won")
			if move == player1:
				Global.P1_WinCount += 1
			elif move == player2:
				Global.P2_WinCount += 1
			reload()
		elif turn_count > 9:
			set_turnLabeltext("It's a draw!")
			draw_anim()
			reload()

	#gets the bot move
	if Global.tictactoe_mode == 3 and move == player1 and turn_count <= 9:
		var bot_move = advanced_bot()
		print("bot move :" + str(bot_move))
		r = bot_move[0]
		c = bot_move[1]
		play_turn(r,c)
	elif Global.tictactoe_mode == 2 and move == player1 and turn_count <= 9: # the issue is here some where
		var bot_move = beatable_bot()
		print("bot move :" + str(bot_move))
		r = bot_move[0]
		c = bot_move[1]
		play_turn(r,c)
	elif Global.tictactoe_mode == 1 and move == player1 and turn_count <= 9:
		var bot_move = easy_bot()
		print("bot move :" + str(bot_move))
		r = bot_move[0]
		c = bot_move[1]
		play_turn(r,c)

func check_win_condition(is_bot:bool):
	var tween = get_tree().create_tween()
	#tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	var win_anim_time = 0.08
	var win_color = Color("#63A375")
	# var return false
	#Check diagonally
	if  GRID[0][0] != '' and GRID[0][0] == GRID[1][1] and GRID[0][0] == GRID[2][2]:
		if !is_bot:
			tween.tween_property(label_1, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)# label_1
			tween.tween_property(label_5, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)# label_5
			tween.tween_property(label_9, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)# label_9
		return true  
 
	elif  GRID[0][2] != '' and GRID[0][2] == GRID[1][1] and GRID[0][2] == GRID[2][0]:
		if !is_bot:
			tween.tween_property(label_3, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(label_5, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(label_7, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		return true

	#Checks each row for matching row,,#r = list number,c = position in the list
	for i in range(0,3):#0,0 wuold be label1 0,1 label4 0,2 label7,,i = 0,0,0 and 1,4,7, i = 1,1,1 then 2,
		if  GRID[i][0] != '' and GRID[i][0] == GRID[i][1] and GRID[i][0] == GRID[i][2]:
			if !is_bot:
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
	for i in range(0,3): #here i 0 will be label1,2,3
		if  GRID[0][i] != '' and GRID[0][i] == GRID[1][i] and GRID[0][i] == GRID[2][i]:
			if !is_bot:
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

func reload():
	get_tree().paused = true
	reload_button.visible = true
	score_display.visible = true
	score_display.text = "Player " + str(player1) + "  " + str(Global.P1_WinCount) + "                                   Player " + str(player2) + "  " + str(Global.P2_WinCount) 

func set_turnLabeltext(toast:String):

	turn_display.visible_ratio = 0.1
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(turn_display,"visible_ratio",1,0.25).set_ease(Tween.EASE_IN)
	turn_display.text = toast

func _on_grid_button_1_released() -> void:
	play_turn(0,0)

func _on_grid_button_2_released() -> void:
	play_turn(0,1)

func _on_grid_button_3_released() -> void:
	play_turn(0,2)

func _on_grid_button_4_released() -> void:
	play_turn(1,0)

func _on_grid_button_5_released() -> void:
	play_turn(1,1)

func _on_grid_button_6_released() -> void:
	play_turn(1,2)

func _on_grid_button_7_released() -> void:
	play_turn(2,0)

func _on_grid_button_8_released() -> void:
	play_turn(2,1)

func _on_grid_button_9_released() -> void:
	play_turn(2,2)

func _on_reload_button_released() -> void:
	get_tree().paused = false
	score_display.visible = false
	get_tree().reload_current_scene()

func available_moves():
	var available_move = []
	for rows in range(3):
		for column in range(3):
			if GRID[rows][column] == "":                
				available_move.append([rows,column])
	return available_move

func advanced_bot():

	# Define the bot's move value and the opponent's move value
	var bot_move_value = player2
	var opponent_move_value = player1
	
	# Get all available moves
	var moves = available_moves()

	# Check for a winning move
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = bot_move_value  # Simulate the bot's move
		if check_win_condition(true):  # Check if this move wins the game
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the winning move
		GRID[r][c] = ""  # Reset the grid

	# Check for a blocking move (prevent opponent from winning)
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = opponent_move_value  # Simulate the opponent's move
		if check_win_condition(true):  # Check if this move would let the opponent win
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the blocking move
		GRID[r][c] = ""  

	# If the center is available, take it
	if GRID[1][1] == "":
		return [1, 1]

	# Check for an empty corner
	var corner_moves = [[0, 0], [0, 2], [2, 0], [2, 2]]
	for corner in corner_moves:
		if corner in moves:
			return corner
	return moves.pick_random()
func beatable_bot():
	
	# Define the bot's move value and the opponent's move value
	var bot_move_value = player2
	var opponent_move_value = player1
	
	# Get all available moves
	var moves = available_moves()

	# Check for a winning move
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = bot_move_value  # Simulate the bot's move
		if check_win_condition(true):  # Check if this move wins the game
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the winning move
		GRID[r][c] = ""  # Reset the grid

	# Check for a blocking move (prevent opponent from winning)
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = opponent_move_value  # Simulate the opponent's move
		if check_win_condition(true):  # Check if this move would let the opponent win
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the blocking move
		GRID[r][c] = ""  
	return moves.pick_random()
	
func insert_move(r, c, move):  # r = row, c = column, move = "X" or "O"
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	var anim_time = 0.1

	if move == player2:
		anim_time += anim_time
	if r == 0 and c == 0:
		tween.tween_property(label_1,"text",move,anim_time)
		grid_button_1.visible = false
	elif r == 0 and c == 1:
		tween.tween_property(label_2,"text",move,anim_time)
		grid_button_2.visible = false
	elif r == 0 and c == 2:
		tween.tween_property(label_3,"text",move,anim_time)
		grid_button_3.visible = false
	elif r == 1 and c == 0:
		tween.tween_property(label_4,"text",move,anim_time)
		grid_button_4.visible = false
	elif r == 1 and c == 1:
		tween.tween_property(label_5,"text",move,anim_time)
		grid_button_5.visible = false
	elif r == 1 and c == 2:
		tween.tween_property(label_6,"text",move,anim_time)
		grid_button_6.visible = false
	elif r == 2 and c == 0:
		tween.tween_property(label_7,"text",move,anim_time)
		grid_button_7.visible = false
	elif r == 2 and c == 1:
		tween.tween_property(label_8,"text",move,anim_time)
		grid_button_8.visible = false
	elif r == 2 and c == 2:
		tween.tween_property(label_9,"text",move,anim_time)
		grid_button_9.visible = false
	return move

func easy_bot():
	# Define the bot's move value and the opponent's move value
	var bot_move_value = player2
	
	# Get all available moves
	var moves = available_moves()
	# Check for a winning move
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = bot_move_value  # Simulate the bot's move
		if check_win_condition(true):  # Check if this move wins the game
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the winning move
		GRID[r][c] = ""  # Reset the grid
	return moves.pick_random()

func _on_pvp_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 0

func _on_easy_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 1

func _on_bot_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 2

func _on_expert_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 3

func _on_resume_pressed() -> void:
	game_options.visible = false
	gridwindow.visible = true
	get_tree().paused = false
	Global.save_game()
	ttt_header.visible = true

func _on_button_game_options_pressed() -> void:
	game_options.visible = true
	gridwindow.visible = false
	get_tree().paused = true
	ttt_header.visible = false
	option_menu_animation.play("option")

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0,value)

func draw_anim():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.parallel()
	var anim_time = 0.01
	var color = Color("#E08E45")#B80C09:red
	Color()
	tween.tween_property(label_1, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_2, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_3, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_4, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_5, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_6, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_7, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_8, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_9, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
