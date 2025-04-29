extends Node
var GRID
func bot_turn(turn_count):
	#var r:int
	#var c:int
		# if Global.tictactoe_mode != 0:
	
	# the moves checks if it is the players turn and then in the next iteration the bot inserts O
	if Global.tictactoe_mode == 3 and Global.Player_turn == Global.player1 and turn_count <= 9:
		return advanced_bot()
		#print("bot move :" + str(bot_move))
		#r = bot_move[0]
		#c = bot_move[1]
		#play_turn(r, c)
	elif Global.tictactoe_mode == 2 and Global.Player_turn == Global.player1 and turn_count <= 9: # the issue is here some where
		return beatable_bot()
		#print("bot move :" + str(bot_move))
		#r = bot_move[0]
		#c = bot_move[1]
		#play_turn(r,c)
	elif Global.tictactoe_mode == 1 and Global.Player_turn == Global.player1 and turn_count <= 9:
		return easy_bot()
		#print("bot move :" + str(bot_move))
		#r = bot_move[0]
		#c = bot_move[1]
		#play_turn(r,c)

func available_moves():
	GRID = Global.GRID
	var available_move = []
	for rows in range(3):
		for column in range(3):
			if GRID[rows][column] == "":                
				available_move.append([rows,column])
	return available_move

func advanced_bot():
	GRID = Global.GRID
	# Define the bot's move value and the opponent's move value
	var bot_move_value = Global.player2
	var opponent_move_value = Global.player1
	# Get all available moves
	var moves = available_moves()
	# Check for a winning move
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = bot_move_value  # Simulate the bot's move
		if check_win_condition():  # Check if this move wins the game
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the winning move
		GRID[r][c] = ""  # Reset the grid

	# Check for a blocking move (prevent opponent from winning)
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = opponent_move_value  # Simulate the opponent's move
		if check_win_condition():  # Check if this move would let the opponent win
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
	GRID = Global.GRID
	# Define the bot's move value and the opponent's move value
	var bot_move_value = Global.player2
	var opponent_move_value = Global.player1
	# Get all available moves
	var moves = available_moves()

	# Check for a winning move
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = bot_move_value  # Simulate the bot's move
		if check_win_condition():  # Check if this move wins the game
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the winning move
		GRID[r][c] = ""  # Reset the grid

	# Check for a blocking move (prevent opponent from winning)
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = opponent_move_value  # Simulate the opponent's move
		if check_win_condition():  # Check if this move would let the opponent win
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the blocking move
		GRID[r][c] = ""  
	return moves.pick_random()

func easy_bot():
	GRID = Global.GRID
	# Define the bot's move value and the opponent's move value
	var bot_move_value = Global.player2
	# Get all available moves
	var moves = available_moves()
	# Check for a winning move
	for move in moves:
		var r = move[0]
		var c = move[1]
		GRID[r][c] = bot_move_value  # Simulate the bot's move
		if check_win_condition():  # Check if this move wins the game
			GRID[r][c] = ""  # Reset the grid
			return move  # Return the winning move
		GRID[r][c] = ""  # Reset the grid
	return moves.pick_random()

func check_win_condition():
	
	#Check diagonally
	if  GRID[0][0] != '' and GRID[0][0] == GRID[1][1] and GRID[0][0] == GRID[2][2]:
		return true  
 
	elif  GRID[0][2] != '' and GRID[0][2] == GRID[1][1] and GRID[0][2] == GRID[2][0]:
		return true

	#Checks each row for matching row,,#r = list number,c = position in the list
	for i in range(0,3):
		if  GRID[i][0] != '' and GRID[i][0] == GRID[i][1] and GRID[i][0] == GRID[i][2]:
			return true

	#Checks each column for matching column
	for i in range(0,3):
		if  GRID[0][i] != '' and GRID[0][i] == GRID[1][i] and GRID[0][i] == GRID[2][i]:
			return true
	return false
