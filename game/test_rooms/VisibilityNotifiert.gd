tool
extends VisibilityNotifier


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("screen_entered", self, "screen_enter")
	connect("screen_exited", self, "screen_exit")
	
	pass # Replace with function body.

func screen_enter():
	print("screen_enter")
	
func screen_exit():
	print("screen_exit")
	
func _notification(what):
	if what == NOTIFICATION_ENTER_GAMEPLAY:
		print("aaaa")
	elif what == NOTIFICATION_EXIT_GAMEPLAY:
		print("bbbb")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
