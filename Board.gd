extends Node

var gameWon = false
var humanPlayersTurn = true
var playerState = 1
var computerState = 2
var tiles

func _ready():
	tiles = get_tree().get_nodes_in_group("Tiles")
	newGame()

func _process(delta):
	gameWon = gameWon()
	if ! gameWon && ! humanPlayersTurn:
		computerTurn()
	
func gameWon():
	if xWins():
		$WinnerLabel.text = "X wins!"
		$WinnerLabel.visible = true
		$NewGameButton.visible = true
	elif oWins():
		$WinnerLabel.text = "O wins!"
		$WinnerLabel.visible = true
		$NewGameButton.visible = true
		

func newGame():
	$NewGameButton.visible = false
	$WinnerLabel.visible = false
	for tile in tiles :
		tile.setState(0)

# Somewhat inelegant way to test if the game is won but it works....
func xWins():
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


func _on_NewGameButton_pressed():
	newGame()
	
func computerTurn():
	for tile in tiles:
		if tile.state == 0:
			tile.setState(computerState)
			break
	humanPlayersTurn = true
	