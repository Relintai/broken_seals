tool
extends PanelContainer

func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event : InputEventKey) -> void:
	#if event.key
	if event.scancode == KEY_G:
		#translate
		pass
	elif event.scancode == KEY_S:
		#scale? probably needs a differrent key
		pass
	elif event.scancode == KEY_R:
		#rotate
		pass

	pass
