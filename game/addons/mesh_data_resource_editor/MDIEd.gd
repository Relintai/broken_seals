tool
extends PanelContainer

var plugin

export var uv_editor_path : NodePath

var uv_editor : Node

func _enter_tree():
	uv_editor = get_node(uv_editor_path)
	
func set_mesh_data_resource(a : MeshDataResource) -> void:
	if uv_editor:
		uv_editor.set_mesh_data_resource(a)

func _unhandled_key_input(event : InputEventKey) -> void:
	if event.echo:
		return
	
	#if event.key
	if event.scancode == KEY_G:
		#translate
		if plugin:
			plugin.set_translate(event.pressed)
	elif event.scancode == KEY_S:
		#scale? probably needs a differrent key
		if plugin:
			plugin.set_scale(event.pressed)
	elif event.scancode == KEY_R:
		#rotate
		if plugin:
			plugin.set_rotate(event.pressed)
	elif event.scancode == KEY_X:
		if plugin:
			plugin.set_axis_x(event.pressed)
	elif event.scancode == KEY_Y:
		if plugin:
			plugin.set_axis_y(event.pressed)
	elif event.scancode == KEY_Z:
		if plugin:
			plugin.set_axis_z(event.pressed)
