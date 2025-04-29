extends Control
@onready var button_press: AudioStreamPlayer2D = $"../../button_press"
@onready var grid_button_1: TouchScreenButton = $gridButton_1
@onready var grid_button_3: TouchScreenButton = $gridButton_3
@onready var grid_button_4: TouchScreenButton = $gridButton_4
@onready var grid_button_5: TouchScreenButton = $gridButton_5
@onready var grid_button_6: TouchScreenButton = $gridButton_6
@onready var grid_button_7: TouchScreenButton = $gridButton_7
@onready var grid_button_8: TouchScreenButton = $gridButton_8
@onready var grid_button_9: TouchScreenButton = $gridButton_9
@onready var game_options: Control = $"../../changemode/game_options"
@onready var grid_button_2: TouchScreenButton = $gridButton_2
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
@onready var game_options_window: Control = $"../../changemode/game_options"
@onready var option_window: ColorRect = $"../../changemode/game_options/Option_window"
@onready var game_options_labels: Label = $"../../changemode/game_options/Option_window/GameOptions"
@onready var option_menu_animation: AnimationPlayer = $"../../changemode/Option_menu_animation"
@onready var multiplayer_window: Control = $"../../changemode/multiplayer_window"

var bot_script = preload("res://scripts/bots.gd")
var bot = bot_script.new()
#var mode:int = 0# 0 is pvp,1is easy bot,2is advanced bot

func _ready() -> void:
	var tween = get_tree().create_tween()
	Global.load_game()
	Global.clear_grid()
	Global.turn_count = 1
	score_display.visible = false
	game_options.visible = false
	gridwindow.visible = true
	reload_button.visible = false
	multiplayer_window.visible = false
	tween.tween_property(ttt_header,"visible_ratio",1.0,0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	Global.Player_turn = Global.player1

func _process(delta: float) -> void:
	set_turnLabeltext("Player " + str(Global.Player_turn) + " turn")


func play_turn(r:int,c:int):
	var move:String = "Error"
	Global.turn_count += 1
	
	if(Global.Player_turn == Global.player1):#if true
		Global.Player_turn = Global.player2
		move = Global.player1
	elif(Global.Player_turn == Global.player2):
		Global.Player_turn = Global.player1
		move = Global.player2
	#move = Global.Player_turn
	
	#Inserts the move
	if Global.GRID[r][c] == "":
		insert_sound.pitch_scale = randf_range(0.9,1.2)
		insert_sound.play()
		Global.GRID[r][c] = insert_move(r,c,move) #r = list number,c = position in the list
	
	#checks the winner
	if Global.turn_count > 4:
		if check_win_condition(false):
			set_turnLabeltext("Player " + str(move) + " Won")
			if move == Global.player1:
				Global.P1_WinCount += 1
			elif move == Global.player2:
				Global.P2_WinCount += 1
			reload()
		elif Global.turn_count > 9:
			set_turnLabeltext("It's a draw!")
			draw_anim()
			reload()

	#the moves checks if it is the players turn and then in thr next itertion the bot inserts O
	if Global.tictactoe_mode == 3 and move == Global.player1 and Global.turn_count <= 9:
		var bot_move = bot.advanced_bot()
		print("bot move :" + str(bot_move))
		r = bot_move[0]
		c = bot_move[1]
		play_turn(r,c)
	elif Global.tictactoe_mode == 2 and move == Global.player1 and Global.turn_count <= 9: # the issue is here some where
		var bot_move = bot.beatable_bot()
		print("bot move :" + str(bot_move))
		r = bot_move[0]
		c = bot_move[1]
		play_turn(r,c)
	elif Global.tictactoe_mode == 1 and move == Global.player1 and Global.turn_count <= 9:
		var bot_move = bot.easy_bot()
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
	if  Global.GRID[0][0] != '' and Global.GRID[0][0] == Global.GRID[1][1] and Global.GRID[0][0] == Global.GRID[2][2]:
		if !is_bot:
			tween.tween_property(label_1, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)# label_1
			tween.tween_property(label_5, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)# label_5
			tween.tween_property(label_9, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)# label_9
		return true  
 
	elif  Global.GRID[0][2] != '' and Global.GRID[0][2] == Global.GRID[1][1] and Global.GRID[0][2] == Global.GRID[2][0]:
		if !is_bot:
			tween.tween_property(label_3, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(label_5, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(label_7, "modulate", win_color, win_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		return true

	#Checks each row for matching row,,#r = list number,c = position in the list
	for i in range(0,3):#0,0 wuold be label1 0,1 label4 0,2 label7,,i = 0,0,0 and 1,4,7, i = 1,1,1 then 2,
		if  Global.GRID[i][0] != '' and Global.GRID[i][0] == Global.GRID[i][1] and Global.GRID[i][0] == Global.GRID[i][2]:
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
		if  Global.GRID[0][i] != '' and Global.GRID[0][i] == Global.GRID[1][i] and Global.GRID[0][i] == Global.GRID[2][i]:
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
	score_display.text = "Player " + str(Global.player1) + "  " + str(Global.P1_WinCount) + "                                   Player " + str(Global.player2) + "  " + str(Global.P2_WinCount) 

func set_turnLabeltext(toast:String):
	turn_display.visible_ratio = 0.1
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(turn_display,"visible_ratio",1.0,0.25).set_ease(Tween.EASE_IN)
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

	#Change this to use a loop and use grd for dynamic loading

#Dynamically updates the grid
func insert_move(r, c, move):  # r = row, c = column, move = "X" or "O"
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	var anim_time = 0.1
	if move == Global.player2:
		anim_time += anim_time
	
	# for row in range(0,3):
	# 	for column in range(0,3):
	# 		print(Global.GRID[row][column])
	# 		var move1 = Global.GRID[row][column]
	# 		r = row
	# 		c = column
	# 		if r == 0 and c == 0:
	# 			if label_1.text == "":
	# 				tween.tween_property(label_1,"text",move1,anim_time)
	# 				grid_button_1.visible = false
	# 		elif r == 0 and c == 1:
	# 			if label_2.text == "":
	# 				tween.tween_property(label_2,"text",move1,anim_time)
	# 				grid_button_2.visible = false
	# 		elif r == 0 and c == 2:
	# 			if label_3.text == "":
	# 				tween.tween_property(label_3,"text",move1,anim_time)
	# 				grid_button_3.visible = false
	# 		elif r == 1 and c == 0:
	# 			if label_4.text == "":
	# 				tween.tween_property(label_4,"text",move1,anim_time)
	# 				grid_button_4.visible = false
	# 		elif r == 1 and c == 1:
	# 			if label_5.text == "":
	# 				tween.tween_property(label_5,"text",move1,anim_time)
	# 				grid_button_5.visible = false
	# 		elif r == 1 and c == 2:
	# 			if label_6.text == "":
	# 				tween.tween_property(label_6,"text",move1,anim_time)
	# 				grid_button_6.visible = false
	# 		elif r == 2 and c == 0:
	# 			if label_7.text == "":
	# 				tween.tween_property(label_7,"text",move1,anim_time)
	# 				grid_button_7.visible = false
	# 		elif r == 2 and c == 1:
	# 			if label_8.text == "":
	# 				tween.tween_property(label_8,"text",move1,anim_time)
	# 				grid_button_8.visible = false
	# 		elif r == 2 and c == 2:
	# 			if label_9.text == "":
	# 				tween.tween_property(label_9,"text",move1,anim_time)
	# 				grid_button_9.visible = false


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

func _on_pvp_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 0
		button_press.play()

func _on_easy_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 1
		button_press.play()
func _on_bot_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 2
		button_press.play()
func _on_expert_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.tictactoe_mode = 3
		button_press.play()
func _on_resume_pressed() -> void:
	Global.gridwindow.visible = true
	multiplayer_window.visible = false
	#game_options.visible = false
	get_tree().paused = false
	Global.save_game()
	option_menu_animation.play_backwards("option")
	ttt_header.visible = true
	button_press.play()

func _on_button_game_options_pressed() -> void:
	button_press.play()
	game_options.visible = true
	Global.gridwindow.visible = false
	get_tree().paused = true
	ttt_header.visible = false
	option_menu_animation.play("option")
	
	
func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0,value)
	button_press.play()

func draw_anim():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.parallel()
	var anim_time = 0.01
	var color = Color("#E08E45")#B80C09:red
	# Color()
	tween.tween_property(label_1, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_2, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_3, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_4, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_5, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_6, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_7, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_8, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_9, "modulate", color, anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	

func _on_multiplayer_button_pressed() -> void:
	multiplayer_window.visible = true
	game_options.visible = false
