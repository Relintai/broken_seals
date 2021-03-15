tool
extends PanelContainer

var plugin

func _unhandled_key_input(event : InputEventKey) -> void:
	if event.echo:
		return
	
	#if event.key
	if event.scancode == KEY_G:
		
		#translate
		if plugin:
			plugin.translate_key_pressed(event.pressed)
	elif event.scancode == KEY_S:
		#scale? probably needs a differrent key
		if plugin:
			plugin.scale_key_pressed(event.pressed)
	elif event.scancode == KEY_R:
		#rotate
		if plugin:
			plugin.rotate_key_pressed(event.pressed)
	elif event.scancode == KEY_X:
		if plugin:
			plugin.axis_key_x(event.pressed)
	elif event.scancode == KEY_Y:
		if plugin:
			plugin.axis_key_y(event.pressed)
	elif event.scancode == KEY_Z:
		if plugin:
			plugin.axis_key_z(event.pressed)
