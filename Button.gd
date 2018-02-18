extends Button

var state = 0;
var playerState = 2;

func _ready():
	pass
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func setState( newState ):
	state = newState % 3
	if state == 1:
		$X_Texture.visible = true
		$O_Texture.visible = false
	elif state == 2:
		$X_Texture.visible = false
		$O_Texture.visible = true
	else:
		$X_Texture.visible = false
		$O_Texture.visible = false
	

func _on_Button_pressed():
	if state == 0:
		setState ( playerState )
