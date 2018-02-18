extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var IndexNumber

var state = 0;

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
	setState ( state + 1 )
