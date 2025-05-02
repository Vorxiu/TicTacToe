extends Node

const save_path = "user://savedgame.cfg"
@export var turn_count:int = 0
@export var GRID = [['','',''],['','',''],['','','']]
@export var player1:String = "X"
@export var player2:String = "O"
var is_multiplayer:bool = false
var tictactoe_mode:int = 0 #if !is_multiplayer else 0# 0 is pvp,1is easy bot,2is advanced bot
var winner:String = ""
var P1_WinCount:int = 0
var P2_WinCount:int = 0
signal grid_updated()

var Player_turn:String = player1
var multiplayer_PlayerSymbol = ""


func clear_grid():
	GRID = [['','',''],['','',''],['','','']]
	emit_signal("grid_updated")

func grid_changed(r,c,move):
	if GRID[r][c] != move and GRID[r][c] == "":
		GRID[r][c] = move

		emit_signal("grid_updated")

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
