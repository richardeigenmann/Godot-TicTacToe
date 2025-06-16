extends Node

var myBoard

func _ready():
	myBoard = get_node("/root/Board")
	randomize()

func playMove( player, opponent ):
	var array = [0,1,2,3,4,5,6,7,8] 
	var shuffledList = shuffleList( array )
	print ("shuffledList: ", shuffledList)
	for i in range(shuffledList.size()):
		print (i, " -> ", shuffledList[i])
		if myBoard.tiles[shuffledList[i]].state == myBoard.EMPTY:
			print ("Setting shuffledList[i]: ", shuffledList[i])
			myBoard.tiles[shuffledList[i]].setState( player )
			return

func shuffleList(list):
	var shuffledList = []
	var indexList = range(list.size())
	for i in range(list.size()):
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	return shuffledList
