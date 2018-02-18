extends Node

enum {EMPTY, X, O}
var gameWon = false
var humanPlayersTurn = true
var playerState = X
var computerState = O
var emptyState = EMPTY
var rounds
var tiles

func _ready():
	tiles = get_tree().get_nodes_in_group("Tiles")
	newGame()

func _on_NewGameButton_pressed():
	newGame()

func newGame():
	$NewGameButton.visible = false
	$WinnerLabel.visible = false
	rounds = 0
	humanPlayersTurn = true
	$ComputerThinkingAnimation.visible = false
	for tile in tiles :
		tile.setState(0)

func gameOver():
	$WinnerLabel.visible = true
	$NewGameButton.visible = true

# The Tile must call here when the human has played
func humanHasPlayed():
	rounds += 1
	humanPlayersTurn = false
	if isWinner( playerState ) :
		$WinnerLabel.text = "You won!"
		gameOver()
	elif rounds > 8:
		$WinnerLabel.text = "Draw"
		gameOver()
	else:
		$ComputerThinkTimer.start()
		$ComputerThinkingAnimation.visible = true

func _on_ComputerThinkTimer_timeout():
	$ComputerThinkingAnimation.visible = false
	computerTurn()


func computerTurn():
	rounds += 1
	if ! computerCanWin():
		for tile in tiles:
			if tile.state == EMPTY:
				tile.setState(computerState)
				break

	if isWinner(computerState):
		$WinnerLabel.text = "Computer\nwins!"
		gameOver()

	if rounds > 8:
		$WinnerLabel.text = "Draw"
		gameOver()

	humanPlayersTurn = true

# Checks if the supplied player won
func isWinner( player ):
	if     tiles[0].state == player && tiles[1].state == player && tiles[2].state == player \
		|| tiles[3].state == player && tiles[4].state == player && tiles[5].state == player \
		|| tiles[6].state == player && tiles[7].state == player && tiles[8].state == player \
		\
		|| tiles[0].state == player && tiles[3].state == player && tiles[6].state == player \
		|| tiles[1].state == player && tiles[4].state == player && tiles[7].state == player \
		|| tiles[2].state == player && tiles[5].state == player && tiles[8].state == player \
		\
		|| tiles[0].state == player && tiles[4].state == player && tiles[8].state == player \
		|| tiles[2].state == player && tiles[4].state == player && tiles[6].state == player:
		return true
	return false

func computerCanWin():
	for row in range(3):
		if computerCanWinRow( row ):
			return true
	for col in range(3):
		if computerCanWinCol( col ):
			return true
	return computerCanWinDiagonals()

func computerCanWinRow( row ):
	if (tiles[row*3].state == computerState) && (tiles[row*3+1].state == computerState) && (tiles[row*3+2].state == EMPTY):
		tiles[row*3+2].setState(computerState)
		return true
	elif (tiles[row*3].state == computerState) && (tiles[row*3+1].state == EMPTY) && (tiles[row*3+2].state == computerState):
		tiles[row*3+1].setState(computerState)
		return true
	elif (tiles[row*3].state == EMPTY) && (tiles[row*3+1].state == computerState) && (tiles[row*3+2].state == computerState):
		tiles[row*3].setState(computerState)
		return true
	return false

func computerCanWinCol( col ):
	if (tiles[col].state == computerState) && (tiles[col+3].state == computerState) && (tiles[col+6].state == EMPTY):
		tiles[col+6].setState(computerState)
		return true
	elif (tiles[col].state == computerState) && (tiles[col+3].state == EMPTY) && (tiles[col+6].state == computerState):
		tiles[col+3].setState(computerState)
		return true
	elif (tiles[col].state == EMPTY) && (tiles[col+3].state == computerState) && (tiles[col+8].state == computerState):
		tiles[col].setState(computerState)
		return true

func computerCanWinDiagonals():
	if (tiles[0].state == computerState) && (tiles[4].state == computerState) && (tiles[8].state == EMPTY):
		tiles[8].setState(computerState)
		return true
	elif (tiles[0].state == computerState) && (tiles[4].state == EMPTY) && (tiles[8].state == computerState):
		tiles[4].setState(computerState)
		return true
	elif (tiles[0].state == EMPTY) && (tiles[4].state == computerState) && (tiles[8].state == computerState):
		tiles[0].setState(computerState)
		return true
	if (tiles[2].state == computerState) && (tiles[4].state == computerState) && (tiles[6].state == EMPTY):
		tiles[6].setState(computerState)
		return true
	elif (tiles[2].state == computerState) && (tiles[4].state == EMPTY) && (tiles[6].state == computerState):
		tiles[4].setState(computerState)
		return true
	elif (tiles[2].state == EMPTY) && (tiles[4].state == computerState) && (tiles[6].state == computerState):
		tiles[2].setState(computerState)
		return true
		

func printStates():
	print ("PrintStates")
	for row in range(3):
		for col in range(3):
			print ("Row: ", row, " Col: ", col, " State: ", tiles[row*3 + col].state)