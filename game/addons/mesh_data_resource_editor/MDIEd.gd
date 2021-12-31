tool
extends PanelContainer

var plugin : EditorPlugin

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
		set_edit_mode_translate()
	elif event.scancode == KEY_S:
		#scale? probably needs a differrent key
		set_edit_mode_scale()
	elif event.scancode == KEY_R:
		#rotate
		set_edit_mode_rotate()
	elif event.scancode == KEY_X:
		if plugin:
			plugin.set_axis_x(event.pressed)
	elif event.scancode == KEY_Y:
		if plugin:
			plugin.set_axis_y(event.pressed)
	elif event.scancode == KEY_Z:
		if plugin:
			plugin.set_axis_z(event.pressed)

func set_edit_mode_translate() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer/Translate.pressed = true

func set_edit_mode_rotate() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer/Rotate.pressed = true
			
func set_edit_mode_scale() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer/Scale.pressed = true

func on_edit_mode_translate_toggled(on : bool) -> void:
	if on:
		if plugin:
			plugin.set_translate(on)

func on_edit_mode_rotate_toggled(on : bool) -> void:
	if on:
		if plugin:
			plugin.set_rotate(on)
			
func on_edit_mode_scale_toggled(on : bool) -> void:
	if on:
		if plugin:
			plugin.set_scale(on)

func _on_Extrude_pressed():
	pass # Replace with function body.

func _on_AddBox_pressed():
	plugin.add_box()

func _on_UnwrapButton_pressed():
	plugin.uv_unwrap()
