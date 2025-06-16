extends Node

var myBoard

func _ready():
	myBoard = get_node("/root/Board")

func playMove( player, opponent ):
	if ! playerCanWin( player ):
		if ! playerMustBlock( player, opponent ):
			if ! createFork( player ):
				if ! blockOpponentFork( player, opponent ):
					if ! takeCenter( player ):
						if ! takeOppositeCorner( player, opponent):
							if ! takeEmptyCorner( player ):
								takeEmptySide( player )

func playerCanWin( player ):
	for row in range(3):
		var tile = myBoard.canWinRow( player, row )
		if tile != null:
			tile.setState( player )
			print ("Rule 1: Win")
			return true
	for col in range(3):
		var tile = myBoard.canWinCol( player, col )
		if tile != null:
			tile.setState( player )
			print ("Rule 1: Win")
			return true
	var tile = myBoard.canWinDiagonal( player )
	if tile != null:
		tile.setState( player )
		print ("Rule 1: Win")
		return true
	return false
	
func playerMustBlock( player, opponent ):
	for row in range(3):
		var tile = myBoard.canWinRow( opponent, row )
		if tile != null:
			tile.setState( player )
			return true
	for col in range(3):
		var tile = myBoard.canWinCol( opponent, col )
		if tile != null:
			tile.setState( player )
			return true
	var tile = myBoard.canWinDiagonal( opponent )
	if tile != null:
		tile.setState( player )
		return true
	return false

func takeCenter( player ):
	if myBoard.tiles[4].state == myBoard.EMPTY:
		myBoard.tiles[4].setState( player )
		print("Rule 5: Take Center")
		return true
	return false

func createFork( player ):
	if takeFork( player, player ):
		print ("Rule 3: Fork")
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


func isForkRowCol( player, row, col ):
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
		
	return isFork( player, intersection, h1, h2, v1, v2 )


func takeForkRowCol(forkPlayer, takePlayer, row, col):
	if isForkRowCol( forkPlayer, row, col ):
		var intersection = row*3 + col
		myBoard.tiles[intersection].setState(takePlayer)
		return true
	return false


# Returns if the situation is a for for the player
# The intersection must be EMPTY and each of the lines (a & b)
# must have one tile EMPTY and the other set to the player
func isFork( player, intersection, a1, a2, b1, b2):
	return myBoard.tiles[intersection].state == myBoard.EMPTY \
			&& ( ( myBoard.tiles[a1].state == player && myBoard.tiles[a2].state == myBoard.EMPTY ) \
				|| ( myBoard.tiles[a1].state == myBoard.EMPTY && myBoard.tiles[a2].state == player ) ) \
			&& ( ( myBoard.tiles[b1].state == player && myBoard.tiles[b2].state == myBoard.EMPTY ) \
				|| ( myBoard.tiles[b1].state == myBoard.EMPTY && myBoard.tiles[b2].state == player ) )

# Takes the fork for the takePlayer if forkPlayer has a 
# fork on the supplied the intersection of lines a and b
func takeForkIfPossible(forkPlayer, takePlayer, intersection, a1, a2, b1, b2):
	if isFork(forkPlayer, intersection, a1, a2, b1, b2):
		myBoard.tiles[intersection].setState(takePlayer)
		return true
	return false

func isForkLeftDiagonalRow( player, row ):
	var intersection = row * 3 + row
	var a1
	var a2
	var b1
	var b2
	
	if row == 0:
		a1 = 1
		a2 = 2
		b1 = 4
		b2 = 8
	elif row == 1:
		a1 = 3
		a2 = 5
		b1 = 0
		b2 = 8
	else:
		a1 = 6
		a2 = 7
		b1 = 0
		b2 = 4
		
	return isFork( player, intersection, a1, a2, b1, b2 )


func takeForkLeftDiagonalRow( forkPlayer, takePlayer, row ):
	if isForkLeftDiagonalRow( forkPlayer, row ):
		var intersection = row * 3 + row
		myBoard.tiles[intersection].setState(takePlayer)
		return true
	return false


func isForkRightDiagonalRow( player, row ):
	var intersection = row * 3 + (3 - row)
	var a1
	var a2
	var b1
	var b2
	
	if row == 0:
		a1 = 0
		a2 = 1
		b1 = 4
		b2 = 6
	elif row == 1:
		a1 = 3
		a2 = 5
		b1 = 2
		b2 = 6
	else:
		a1 = 7
		a2 = 8
		b1 = 2
		b2 = 4
		
	return isFork( player, intersection, a1, a2, b1, b2)


func takeForkRightDiagonalRow( forkPlayer, takePlayer, row ):
	if isForkRightDiagonalRow( forkPlayer, row ):
		var intersection = row * 3 + (3 - row)
		myBoard.tiles[intersection].setState(takePlayer)
	return false

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

# Blocking an opponent's fork: If there is only one possible fork for the opponent, 
# the player should block it. Otherwise, the player should block any forks in any 
# way that simultaneously allows them to create two in a row. Otherwise, the player
# should create a two in a row to force the opponent into defending, as long as it 
# doesn't result in them creating a fork. For example, if "X" has two opposite corners 
# and "O" has the center, "O" must not play a corner in order to win. (Playing a corner
# in this scenario creates a fork for "X" to win.)
func blockOpponentFork( player, opponent ):
	if takeFork( opponent, player ):
		print ("Rule 4: Block Fork")
		return true
	return false


func takeOppositeCorner( player, opponent ):
	if (myBoard.tiles[0].state == opponent) && (myBoard.tiles[8].state == myBoard.EMPTY):
		myBoard.tiles[8].setState( player )
		print("Rule 6: Take opposite corner")
		return true
	if (myBoard.tiles[2].state == opponent) && (myBoard.tiles[6].state == myBoard.EMPTY):
		myBoard.tiles[6].setState( player )
		print("Rule 6: Take opposite corner")
		return true
	if (myBoard.tiles[8].state == opponent) && (myBoard.tiles[0].state == myBoard.EMPTY):
		myBoard.tiles[0].setState( player )
		print("Rule 6: Take opposite corner")
		return true
	if (myBoard.tiles[6].state == opponent) && (myBoard.tiles[2].state == myBoard.EMPTY):
		myBoard.tiles[2].setState( player )
		print("Rule 6: Take opposite corner")
		return true
	
func takeEmptyCorner( player ):
	if myBoard.tiles[0].state == myBoard.EMPTY:
		myBoard.tiles[0].setState( player )
		print("Rule 7: Take empty corner")
		return true
	if myBoard.tiles[2].state == myBoard.EMPTY:
		myBoard.tiles[2].setState( player )
		print("Rule 7: Take empty corner")
		return true
	if myBoard.tiles[8].state == myBoard.EMPTY:
		myBoard.tiles[8].setState( player )
		print("Rule 7: Take empty corner")
		return true
	if myBoard.tiles[6].state == myBoard.EMPTY:
		myBoard.tiles[6].setState( player )
		print("Rule 7: Take empty corner")
		return true

func takeEmptySide( player ):
	if myBoard.tiles[1].state == myBoard.EMPTY:
		myBoard.tiles[1].setState( player )
		print("Rule 8: Take empty side")
		return true
	if myBoard.tiles[3].state == myBoard.EMPTY:
		myBoard.tiles[3].setState( player )
		print("Rule 8: Take empty side")
		return true
	if myBoard.tiles[5].state == myBoard.EMPTY:
		myBoard.tiles[5].setState( player )
		print("Rule 8: Take empty side")
		return true
	if myBoard.tiles[7].state == myBoard.EMPTY:
		myBoard.tiles[7].setState( player )
		print("Rule 8: Take empty side")
		return true
