tool
extends EditorPlugin

var WorldGenWorld = preload("res://addons/world_generator/resources/world_gen_world.gd")
var Continent = preload("res://addons/world_generator/resources/continent.gd")
var Zone = preload("res://addons/world_generator/resources/zone.gd")
var SubZone = preload("res://addons/world_generator/resources/subzone.gd")

var editor_packed_scene = preload("res://addons/world_generator/ui/MainScreen.tscn")
var editor_scene = null

var tool_button : ToolButton = null

func _enter_tree():
	add_custom_type("WorldGenWorld", "Resource", WorldGenWorld, null)
	add_custom_type("Continent", "Resource", Continent, null)
	add_custom_type("Zone", "Resource", Zone, null)
	add_custom_type("SubZone", "Resource", SubZone, null)

	editor_scene = editor_packed_scene.instance()

	tool_button = add_control_to_bottom_panel(editor_scene, "WorldEditor")
	tool_button.hide()

func _exit_tree():
	remove_custom_type("WorldGenWorld")
	remove_custom_type("Continent")
	remove_custom_type("Zone")
	remove_custom_type("SubZone")

	remove_control_from_bottom_panel(editor_scene)


func handles(object):
	return object is WorldGenWorld

func edit(object):
	#if editor_scene:
	#	make_bottom_panel_item_visible(editor_scene)

	if object is WorldGenWorld:
		editor_scene.set_wgworld(object as WorldGenWorld)

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
	return "WorldGeneratorEditor"

func has_main_screen():
	return false


