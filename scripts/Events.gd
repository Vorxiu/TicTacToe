extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_turn():
	if(Global.Player_turn):#if true
		Global.Player_turn = false
		return ("Player " + "O" + " turn")
	elif(!Global.Player_turn):
		Global.Player_turn = true
		return ("Player " + "X" + " turn")