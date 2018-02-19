extends Node

enum {EMPTY, X, O}
var gameWon = false
var humanPlayersTurn = true
var playerState = X
var computerState = O
var emptyState = EMPTY
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

func _on_ComputerThinkTimer_timeout():
	$ComputerThinkingAnimation.visible = false
	computerTurn()


# Logic taken from Wikipedia: https://en.wikipedia.org/wiki/Tic-tac-toe
func computerTurn():
	if ! computerCanWin():
		if ! computerMustBlock():
			if ! computerTakesCenter():
				if ! computerTakesEmptySide():
					if ! computerTakesEmptyCorner():
						if ! computerCreatesFork():
							if ! computerMustBlockOpponentsFork():
								if !computerTakesEmptySide():
									! computerTakesOppositeCorner()
								
	moves += 1


	if isWinner(computerState):
		$WinnerLabel.text = "Computer\nwins!"
		computerWins += 1
		gameOver()

	if moves > 8:
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
			print ("Rule 1: Win")
			return true
	for col in range(3):
		if computerCanWinCol( col ):
			print ("Rule 1: Win")
			return true
	return computerCanWinDiagonals()

func computerCanWinRow( row ):
	if tiles[row*3].state == computerState && tiles[row*3+1].state == computerState && tiles[row*3+2].state == EMPTY:
		tiles[row*3+2].setState(computerState)
		return true
	elif tiles[row*3].state == computerState && tiles[row*3+1].state == EMPTY && tiles[row*3+2].state == computerState:
		tiles[row*3+1].setState(computerState)
		return true
	elif tiles[row*3].state == EMPTY && tiles[row*3+1].state == computerState && tiles[row*3+2].state == computerState:
		tiles[row*3].setState(computerState)
		return true
	return false

func computerCanWinCol( col ):
	if tiles[col].state == computerState && tiles[col+3].state == computerState && tiles[col+6].state == EMPTY:
		tiles[col+6].setState(computerState)
		return true
	elif tiles[col].state == computerState && tiles[col+3].state == EMPTY && tiles[col+6].state == computerState:
		tiles[col+3].setState(computerState)
		return true
	elif tiles[col].state == EMPTY && tiles[col+3].state == computerState && tiles[col+6].state == computerState:
		tiles[col].setState(computerState)
		return true

func computerCanWinDiagonals():
	if tiles[0].state == computerState && tiles[4].state == computerState && tiles[8].state == EMPTY:
		tiles[8].setState(computerState)
		print ("Rule 1: Win")
		return true
	elif tiles[0].state == computerState && tiles[4].state == EMPTY && tiles[8].state == computerState:
		tiles[4].setState(computerState)
		print ("Rule 1: Win")
		return true
	elif tiles[0].state == EMPTY && tiles[4].state == computerState && tiles[8].state == computerState:
		tiles[0].setState(computerState)
		print ("Rule 1: Win")
		return true
	if tiles[2].state == computerState && tiles[4].state == computerState && tiles[6].state == EMPTY:
		tiles[6].setState(computerState)
		print ("Rule 1: Win")
		return true
	elif tiles[2].state == computerState && tiles[4].state == EMPTY && tiles[6].state == computerState:
		tiles[4].setState(computerState)
		print ("Rule 1: Win")
		return true
	elif tiles[2].state == EMPTY && tiles[4].state == computerState && tiles[6].state == computerState:
		tiles[2].setState(computerState)
		print ("Rule 1: Win")
		return true

func computerMustBlock():
	for row in range(3):
		if computerMustBlockRow( row ):
			print ("Rule 2: Block opponent")
			return true
	for col in range(3):
		if computerMustBlockCol( col ):
			print ("Rule 2: Block opponent")
			return true
	return computerMustBlockDiagonals()

func computerMustBlockRow( row ):
	if tiles[row*3].state == playerState && tiles[row*3+1].state == playerState && tiles[row*3+2].state == EMPTY:
		tiles[row*3+2].setState(computerState)
		return true
	elif tiles[row*3].state == playerState && tiles[row*3+1].state == EMPTY && tiles[row*3+2].state == playerState:
		tiles[row*3+1].setState(computerState)
		return true
	elif tiles[row*3].state == EMPTY && tiles[row*3+1].state == playerState && tiles[row*3+2].state == playerState:
		tiles[row*3].setState(computerState)
		return true
	return false

func computerMustBlockCol( col ):
	if tiles[col].state == playerState && tiles[col+3].state == playerState && tiles[col+6].state == EMPTY:
		tiles[col+6].setState(computerState)
		return true
	elif tiles[col].state == playerState && tiles[col+3].state == EMPTY && tiles[col+6].state == playerState:
		tiles[col+3].setState(computerState)
		return true
	elif tiles[col].state == EMPTY && tiles[col+3].state == playerState && tiles[col+6].state == playerState:
		tiles[col].setState(computerState)
		return true

func computerMustBlockDiagonals():
	if tiles[0].state == playerState && tiles[4].state == playerState && tiles[8].state == EMPTY:
		tiles[8].setState(computerState)
		print ("Rule 2: Block opponent")
		return true
	elif tiles[0].state == playerState && tiles[4].state == EMPTY && tiles[8].state == playerState:
		tiles[4].setState(computerState)
		print ("Rule 2: Block opponent")
		return true
	elif tiles[0].state == EMPTY && tiles[4].state == playerState && tiles[8].state == playerState:
		tiles[0].setState(computerState)
		print ("Rule 2: Block opponent")
		return true
	if tiles[2].state == playerState && tiles[4].state == playerState && tiles[6].state == EMPTY:
		tiles[6].setState(computerState)
		print ("Rule 2: Block opponent")
		return true
	elif tiles[2].state == playerState && tiles[4].state == EMPTY && tiles[6].state == playerState:
		tiles[4].setState(computerState)
		print ("Rule 2: Block opponent")
		return true
	elif tiles[2].state == EMPTY && tiles[4].state == playerState && tiles[6].state == computerState:
		tiles[2].setState(computerState)
		print ("Rule 2: Block opponent")
		return true

func computerCreatesFork():
	if takeFork(computerState, computerState):
		print ("Rule 3: Fork")
		return true
	return false
	
func computerMustBlockOpponentsFork():
	if takeFork(playerState, computerState):
		print ("Rule 4: Block Fork")
		return true
	return false

# A Fork is defined as "If there are two intersecting rows, columns, or diagonals
# with one of my pieces and two blanks, and the intersecting space is empty,
# then move to the insersecting space thus creating two ways to wind on my next turn
# from http://onlinelibrary.wiley.com/doi/10.1207/s15516709cog1704_3/epdf
func takeFork(forkPlayer, takePlayer):
	for row in range(3):
		for col in range(3):
			if takeForkRowCol(forkPlayer, takePlayer, row, col):
				return true
		if takeForkLeftDiagonalRow(forkPlayer, takePlayer, row):
			return true
		if takeForkRightDiagonalRow(forkPlayer, takePlayer, row):
			return true
		if takeForkLeftDiagonalColumn(forkPlayer, takePlayer, row):
			return true
		if takeForkRightDiagonalColumn(forkPlayer, takePlayer, row):
			return true
	return false

func takeForkRowCol(forkPlayer, takePlayer, row, col):
	var intersection = row*3 + col
	var h1
	var h2
	var v1
	var v2
	
	if col == 0:
		h1 = row * 3 + 1
		h2 = row * 3 + 2
	elif col == 1:
		h1 = row * 3 + 0
		h2 = row * 3 + 2
	else:
		h1 = row * 3 + 0
		h2 = row * 3 + 1
		
	if row == 0:
		v1 = (row + 1) * 3 + col
		v2 = (row + 2) * 3 + col
	elif row == 1:
		v1 = (row - 1) * 3 + col
		v2 = (row + 1) * 3 + col
	else:
		v1 = (row -2) * 3 + col
		v2 = (row -1) * 3 + col
		
	return takeForkIfPossible(forkPlayer, takePlayer, intersection, h1, h2, v1, v2)


func takeForkLeftDiagonalRow(forkPlayer, takePlayer, row):
	var intersection = row * 3 + row
	var h1
	var h2
	var v1
	var v2
	
	if row == 0:
		h1 = 1
		h2 = 2
		v1 = 4
		v2 = 8
	elif row == 1:
		h1 = 3
		h2 = 5
		v1 = 0
		v2 = 8
	else:
		h1 = 6
		h2 = 7
		v1 = 0
		v2 = 4
		
	return takeForkIfPossible(forkPlayer, takePlayer, intersection, h1, h2, v1, v2)

func takeForkRightDiagonalRow(forkPlayer, takePlayer, row):
	var intersection = row * 3 + (3 - row)
	var h1
	var h2
	var v1
	var v2
	
	if row == 0:
		h1 = 0
		h2 = 1
		v1 = 4
		v2 = 6
	elif row == 1:
		h1 = 3
		h2 = 5
		v1 = 2
		v2 = 6
	else:
		h1 = 7
		h2 = 8
		v1 = 2
		v2 = 4
		
	return takeForkIfPossible(forkPlayer, takePlayer, intersection, h1, h2, v1, v2)

func takeForkRightDiagonalColumn(forkPlayer, takePlayer, col):
	var intersection = (2 - col) * 3 + col
	var h1
	var h2
	var v1
	var v2
	
	if col == 0:
		h1 = 0
		h2 = 3
		v1 = 2
		v2 = 4
	elif col == 1:
		h1 = 1
		h2 = 7
		v1 = 2
		v2 = 6
	else:
		h1 = 5
		h2 = 8
		v1 = 6
		v2 = 4
		
	return takeForkIfPossible(forkPlayer, takePlayer, intersection, h1, h2, v1, v2)


func takeForkLeftDiagonalColumn(forkPlayer, takePlayer, col):
	var intersection = col * 3 + col
	var h1
	var h2
	var v1
	var v2
	
	if col == 0:
		h1 = 3
		h2 = 6
		v1 = 4
		v2 = 8
	elif col == 1:
		h1 = 1
		h2 = 7
		v1 = 0
		v2 = 8
	else:
		h1 = 2
		h2 = 5
		v1 = 0
		v2 = 4
		
	return takeForkIfPossible(forkPlayer, takePlayer, intersection, h1, h2, v1, v2)


# Takes the fork for the takePlayer if the intersection is EMPTY and one of 
# the two others in the row is empty and forkPlayer's and one of the tho others
# in the vertical is EMPTY and forkPlayer's
func takeForkIfPossible(forkPlayer, takePlayer, intersection, h1, h2, v1, v2):
	if tiles[intersection].state == EMPTY \
			&& ( ( tiles[h1].state == forkPlayer && tiles[h2].state == EMPTY ) \
				|| ( tiles[h1].state == EMPTY && tiles[h2].state == forkPlayer ) ) \
			&& ( ( tiles[v1].state == forkPlayer && tiles[v2].state == EMPTY ) \
				|| ( tiles[v1].state == EMPTY && tiles[v2].state == forkPlayer ) ):
		tiles[intersection].setState(takePlayer);
		return true
	return false


func computerTakesCenter():
	if tiles[4].state == EMPTY:
		tiles[4].setState(computerState)
		print("Rule 5: Take Center")
		return true
	return false

func computerTakesOppositeCorner():
	if (tiles[0].state == playerState) && (tiles[8].state == EMPTY):
		tiles[8].setState(computerState)
		print("Rule 6: Take opposite corner")
		return true
	if (tiles[2].state == playerState) && (tiles[6].state == EMPTY):
		tiles[6].setState(computerState)
		print("Rule 6: Take opposite corner")
		return true
	if (tiles[8].state == playerState) && (tiles[0].state == EMPTY):
		tiles[0].setState(computerState)
		print("Rule 6: Take opposite corner")
		return true
	if (tiles[6].state == playerState) && (tiles[2].state == EMPTY):
		tiles[2].setState(computerState)
		print("Rule 6: Take opposite corner")
		return true
	
func computerTakesEmptyCorner():
	if tiles[0].state == EMPTY:
		tiles[0].setState(computerState)
		print("Rule 7: Take empty corner")
		return true
	if tiles[2].state == EMPTY:
		tiles[2].setState(computerState)
		print("Rule 7: Take empty corner")
		return true
	if tiles[8].state == EMPTY:
		tiles[8].setState(computerState)
		print("Rule 7: Take empty corner")
		return true
	if tiles[6].state == EMPTY:
		tiles[6].setState(computerState)
		print("Rule 7: Take empty corner")
		return true

func computerTakesEmptySide():
	if tiles[1].state == EMPTY:
		tiles[1].setState(computerState)
		print("Rule 8: Take empty side")
		return true
	if tiles[3].state == EMPTY:
		tiles[3].setState(computerState)
		print("Rule 8: Take empty side")
		return true
	if tiles[5].state == EMPTY:
		tiles[5].setState(computerState)
		print("Rule 8: Take empty side")
		return true
	if tiles[7].state == EMPTY:
		tiles[7].setState(computerState)
		print("Rule 8: Take empty side")
		return true

func printStates():
	print ("PrintStates")
	for row in range(3):
		for col in range(3):
			print ("Row: ", row, " Col: ", col, " State: ", tiles[row*3 + col].state)