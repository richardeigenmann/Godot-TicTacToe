extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var gameWon = false;

func _ready():
	pass

func _process(delta):
	gameWon = gameWon()
	if gameWon :
		print("Winner")
	else:
		print("No Winner")
	
func gameWon():
	return xWins() || oWins()


# Somewhat inelegant way to test if the game is won but it works....
func xWins():
	var tiles = get_tree().get_nodes_in_group("Tiles")
	if     tiles[0].state == 1 && tiles[1].state == 1 && tiles[2].state == 1 \
		|| tiles[3].state == 1 && tiles[4].state == 1 && tiles[5].state == 1 \
		|| tiles[6].state == 1 && tiles[7].state == 1 && tiles[8].state == 1 \
		\
		|| tiles[0].state == 1 && tiles[3].state == 1 && tiles[6].state == 1 \
		|| tiles[1].state == 1 && tiles[4].state == 1 && tiles[7].state == 1 \
		|| tiles[2].state == 1 && tiles[5].state == 1 && tiles[8].state == 1 \
		\
		|| tiles[0].state == 1 && tiles[4].state == 1 && tiles[8].state == 1 \
		|| tiles[2].state == 1 && tiles[4].state == 1 && tiles[6].state == 1 :
		return true
	
	return false

# Somewhat inelegant way to test if the game is won but it works....
func oWins():
	var tiles = get_tree().get_nodes_in_group("Tiles")
	if     tiles[0].state == 2 && tiles[1].state == 2 && tiles[2].state == 2 \
		|| tiles[3].state == 2 && tiles[4].state == 2 && tiles[5].state == 2 \
		|| tiles[6].state == 2 && tiles[7].state == 2 && tiles[8].state == 2 \
		\
		|| tiles[0].state == 2 && tiles[3].state == 2 && tiles[6].state == 2 \
		|| tiles[1].state == 2 && tiles[4].state == 2 && tiles[7].state == 2 \
		|| tiles[2].state == 2 && tiles[5].state == 2 && tiles[8].state == 2 \
		\
		|| tiles[0].state == 2 && tiles[4].state == 2 && tiles[8].state == 2 \
		|| tiles[2].state == 2 && tiles[4].state == 2 && tiles[6].state == 2:
		return true
	
	return false
