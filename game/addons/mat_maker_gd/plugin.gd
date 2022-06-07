tool
extends EditorPlugin

var editor_packed_scene = preload("res://addons/mat_maker_gd/editor/MatMakerGDEditor.tscn")
var editor_scene = null

var tool_button : ToolButton = null

func _enter_tree():
	editor_scene = editor_packed_scene.instance()
	editor_scene.set_plugin(self)
	
	tool_button = add_control_to_bottom_panel(editor_scene, "MMGD")
	tool_button.hide()
	
func _exit_tree():
	remove_control_from_bottom_panel(editor_scene)
	
	if editor_scene:
		editor_scene.queue_free()
		
	editor_scene = null
	tool_button = null

func handles(object):
	return object is MMMaterial

func edit(object):
	#if editor_scene:
	#	make_bottom_panel_item_visible(editor_scene)

	if object is MMMaterial:
		editor_scene.set_mmmaterial(object as MMMaterial)
	
func make_visible(visible):
	if tool_button:
		if visible:
			tool_button.show()
		else:
			#if tool_button.pressed:
			#	tool_button.pressed = false
			
			if !tool_button.pressed:
				tool_button.hide()
	
func get_plugin_icon():
	return null
	
func get_plugin_name():
	return "MatMakerGD"

func has_main_screen():
	return false
	

