extends Node

enum {EMPTY, X, O}
var gameWon = false
var humanPlayersTurn = true
var playerState = X
var computerState = O
var moves
var tiles
var humanWins = 0
var computerWins = 0

func _ready():
	tiles = get_tree().get_nodes_in_group("Tiles")
	newGame()

func _on_NewGameButton_pressed():
	newGame()

func newGame():
	$NewGameButton.visible = false
	$WinnerLabel.visible = false
	moves = 0
	humanPlayersTurn = true
	$ComputerThinkingAnimation.visible = false
	for tile in tiles :
		tile.setState(0)

func gameOver():
	$WinnerLabel.visible = true
	$NewGameButton.visible = true
	$ComputerScoreLabel.text = str(computerWins)
	$YouScoreLabel.text = str(humanWins)
	if $AutoplayCheckbox.is_pressed():
		$AutoplayTimer.start()

func _on_AutoplayTimer_timeout():
	newGame()
	humanTurn()


# The Tile must call here when the human has played
func humanHasPlayed():
	moves += 1
	humanPlayersTurn = false
	if isWinner( playerState ) :
		$WinnerLabel.text = "You won!"
		humanWins += 1
		gameOver()
	elif moves > 8:
		$WinnerLabel.text = "Draw"
		gameOver()
	else:
		$ComputerThinkTimer.start()
		$ComputerThinkingAnimation.visible = true

func _on_AutoplayCheckbox_pressed():
	if $AutoplayCheckbox.is_pressed():
		$HumanThinkTimer.start()

func _on_ComputerThinkTimer_timeout():
	$ComputerThinkingAnimation.visible = false
	computerTurn()

func _on_HumanTinkTimer_timeout():
	$ComputerThinkingAnimation.visible = false
	humanTurn()

func computerTurn():
	#$WikipediaAlgo.playMove( computerState, playerState )
	$RandomAlgo.playMove( computerState, playerState )
	moves += 1

	if isWinner(computerState):
		$WinnerLabel.text = "Computer\nwins!"
		computerWins += 1
		gameOver()
	elif moves > 8:
		$WinnerLabel.text = "Draw"
		gameOver()
	if $AutoplayCheckbox.is_pressed():
		$HumanThinkTimer.start()
		$ComputerThinkingAnimation.visible = true

	humanPlayersTurn = true
	
func humanTurn():
	#$WikipediaAlgo.playMove( playerState, computerState )
	$RandomAlgo.playMove( playerState, computerState )
	moves += 1

	if isWinner(playerState):
		$WinnerLabel.text = "Human\nwins!"
		humanWins += 1
		gameOver()
	elif moves > 8:
		$WinnerLabel.text = "Draw"
		gameOver()
	else:
		$ComputerThinkTimer.start()
		$ComputerThinkingAnimation.visible = true

	humanPlayersTurn = false
	
	

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



# Tests the row for the supplied player and returns the winning tile
# @param player The enum for X or O who would win the row
# @param row the row [0..1] that should be tested
# @return the winning tile, null if no win is possible
func canWinRow( player, row ):
	if tiles[row*3].state == player && tiles[row*3+1].state == player && tiles[row*3+2].state == EMPTY:
		return tiles[row*3+2]
	elif tiles[row*3].state == player && tiles[row*3+1].state == EMPTY && tiles[row*3+2].state == player:
		return tiles[row*3+1]
	elif tiles[row*3].state == EMPTY && tiles[row*3+1].state == player && tiles[row*3+2].state == player:
		return tiles[row*3]
	return null

# Tests the column for the supplied player and returns the winning tile
# @param player The enum for X or O who would win the column
# @param col the col [0..1] that should be tested
# @return the winning tile, null if no win is possible
func canWinCol( player, col ):
	if tiles[col].state == player && tiles[col+3].state == player && tiles[col+6].state == EMPTY:
		return tiles[col+6]
	elif tiles[col].state == player && tiles[col+3].state == EMPTY && tiles[col+6].state == player:
		return tiles[col+3]
	elif tiles[col].state == EMPTY && tiles[col+3].state == player && tiles[col+6].state == player:
		return tiles[col]
	return null

# Tests the diagonal for the supplied player and returns the winning tile
# @param player The enum for X or O who would win the diagonal
# @return the winning tile, null if no win is possible
func canWinDiagonal( player ):
	if tiles[0].state == player && tiles[4].state == player && tiles[8].state == EMPTY:
		return tiles[8]
	elif tiles[0].state == player && tiles[4].state == EMPTY && tiles[8].state == player:
		return tiles[4]
	elif tiles[0].state == EMPTY && tiles[4].state == player && tiles[8].state == player:
		return tiles[0]
	if tiles[2].state == player && tiles[4].state == player && tiles[6].state == EMPTY:
		return tiles[6]
	elif tiles[2].state == player && tiles[4].state == EMPTY && tiles[6].state == player:
		return tiles[4]
	elif tiles[2].state == EMPTY && tiles[4].state == player && tiles[6].state == player:
		return tiles[2]
	return null

func printStates():
	print ("PrintStates")
	for row in range(3):
		for col in range(3):
			print ("Row: ", row, " Col: ", col, " State: ", tiles[row*3 + col].state)

