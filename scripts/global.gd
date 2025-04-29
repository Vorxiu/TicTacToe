extends Node
var tictactoe_mode:int = 0# 0 is pvp,1is easy bot,2is advanced bot
const save_path = "user://savedgame.cfg"
var Player_turn:bool = true
var P1_WinCount:int = 0
var P2_WinCount:int = 0
var GRID = [['','',''],['','',''],['','','']]
@export var player1:String = "X"
@export var player2:String = "O"

func clear_grid():
	GRID = [['','',''],['','',''],['','','']]

func save_game():
	var config = ConfigFile.new()
	config.set_value("TicTacToe", "mode", tictactoe_mode)
	# Save it to a file (overwrite if already exists).
	config.save(save_path)

func load_game():
	var config = ConfigFile.new()
	var err = config.load(save_path)
	if err == OK:
		tictactoe_mode = config.get_value("TicTacToe","mode",0)
