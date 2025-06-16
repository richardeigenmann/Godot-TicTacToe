extends Button

var state
var myBoard


func _ready():
	myBoard = get_node("/root/Board")
	state = myBoard.EMPTY

func setState( newState ):
	state = newState
	if state == myBoard.X:
		print("move: ", myBoard.moves, " X plays: ", self.name)
		$X_Texture.visible = true
		$O_Texture.visible = false
	elif state == myBoard.O:
		print("move: ", myBoard.moves, " O plays: ", self.name)
		$X_Texture.visible = false
		$O_Texture.visible = true
	else:
		$X_Texture.visible = false
		$O_Texture.visible = false
	

func _on_Button_pressed():
	if myBoard.humanPlayersTurn && state == myBoard.EMPTY:
		print("Button Pressed")
		setState ( myBoard.playerState )
		myBoard.humanHasPlayed()
