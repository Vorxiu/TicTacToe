extends Control

@onready var turn_display: Label = $"../../header/turn_display"
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

var player1_turn:bool
var turn_count:int
@export var player1:String = "X"
@export var player2:String = "O"
var GRID = [['','',''],['','',''],['','','']]

func _ready() -> void:
	turn_count = 1
	player1_turn = true

func _process(delta: float) -> void:
	if(player1_turn):
		turn_display.text = "Player 1 turn # "
	elif(!player1_turn):
		turn_display.text = "Player 2 turn # "
	turn_display.text += str(turn_count)
	

func play_turn(r:int,c:int):
	var move:String
	turn_count += 1
	if(player1_turn):#if true
		player1_turn = false
		move = player1
	elif(!player1_turn):
		player1_turn = true
		move = player2
	
	#Inserts the move
	GRID[r][c] = move #r = list number,c = position in the list
	print(GRID);print(turn_count)
	
	if turn_count > 4:
		if check_win_condition(false):
			turn_display.text = "Player " + str(move) + " Won"
			# await get_tree().create_timer(2.0).timeout
			# get_tree().paused = true
	
	elif turn_count >= 8:
		turn_display.text = "Its a draw!"
		get_tree().paused = true
	return move

func check_win_condition(_is_bot):
	var win_anim_time = 0.08
	var tween = get_tree().create_tween()
	# var return false
	#Check diagonally
	if  GRID[0][0] != '' and GRID[0][0] == GRID[1][1] and GRID[0][0] == GRID[2][2]:
		tween.tween_property(label_1, "modulate", Color(0,1,0), win_anim_time)# label_1
		tween.tween_property(label_5, "modulate", Color(0,1,0), win_anim_time)# label_5
		tween.tween_property(label_9, "modulate", Color(0,1,0), win_anim_time)# label_9
		return true  
 
	elif  GRID[0][2] != '' and GRID[0][2] == GRID[1][1] and GRID[0][2] == GRID[2][0]:
		tween.tween_property(label_3, "modulate", Color(0,1,0), win_anim_time)
		tween.tween_property(label_5, "modulate", Color(0,1,0), win_anim_time)
		tween.tween_property(label_7, "modulate", Color(0,1,0), win_anim_time)
		return true

	#Checks each row for matching row,,#r = list number,c = position in the list
	for i in range(0,3):#0,0 wuold be label1 0,1 label4 0,2 label7,,i = 0,0,0 and 1,4,7, i = 1,1,1 then 2,
		if  GRID[i][0] != '' and GRID[i][0] == GRID[i][1] and GRID[i][0] == GRID[i][2]:
			if i == 0:
				tween.tween_property(label_1, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_2, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_3, "modulate", Color(0,1,0), win_anim_time)
			elif i == 1:
				tween.tween_property(label_4, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_5, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_6, "modulate", Color(0,1,0), win_anim_time)
			elif i == 2:
				tween.tween_property(label_7, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_8, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_9, "modulate", Color(0,1,0), win_anim_time)
			return true

	#Checks each column for matching column
	for i in range(0,3): #here i 0 will be label1,2,3
		if  GRID[0][i] != '' and GRID[0][i] == GRID[1][i] and GRID[0][i] == GRID[2][i]:
			if i == 0:
				tween.tween_property(label_1, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_4, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_7, "modulate", Color(0,1,0), win_anim_time)
			elif i == 1:
				tween.tween_property(label_2, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_5, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_8, "modulate", Color(0,1,0), win_anim_time)
			elif i == 2:
				tween.tween_property(label_3, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_6, "modulate", Color(0,1,0), win_anim_time)
				tween.tween_property(label_9, "modulate", Color(0,1,0), win_anim_time)
			
			return true

	#if there is a winner then prints the relevant message
	#if is_bot == False and return= True:
		##winner_check(a,b)
		#pass
	
	# return win


func _on_grid_button_1_released() -> void:
	grid_button_1.visible = false
	label_1.text = play_turn(0,0)

func _on_grid_button_2_released() -> void:
	grid_button_2.visible = false
	label_2.text = play_turn(0,1)

func _on_grid_button_3_released() -> void:
	grid_button_3.visible = false
	label_3.text = play_turn(0,2)

func _on_grid_button_4_released() -> void:
	grid_button_4.visible = false
	label_4.text = play_turn(1,0)

func _on_grid_button_5_released() -> void:
	grid_button_5.visible = false
	label_5.text = play_turn(1,1)

func _on_grid_button_6_released() -> void:
	grid_button_6.visible = false
	label_6.text = play_turn(1,2)

func _on_grid_button_7_released() -> void:
	grid_button_7.visible = false
	label_7.text = play_turn(2,0)

func _on_grid_button_8_released() -> void:
	grid_button_8.visible = false
	label_8.text = play_turn(2,1)

func _on_grid_button_9_released() -> void:
	grid_button_9.visible = false
	label_9.text = play_turn(2,2)
