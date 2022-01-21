tool
extends EditorPlugin

var SWorldGeneratorSettings = preload("res://addons/world_generator/resources/world_generator_settings.gd")

var SWorldGenBaseResource = preload("res://addons/world_generator/resources/world_gen_base_resource.gd")
var SWorldGenWorld = preload("res://addons/world_generator/resources/world_gen_world.gd")
var SContinent = preload("res://addons/world_generator/resources/continent.gd")
var SZone = preload("res://addons/world_generator/resources/zone.gd")
var SSubZone = preload("res://addons/world_generator/resources/subzone.gd")

var editor_packed_scene = preload("res://addons/world_generator/ui/MainScreen.tscn")
var editor_scene = null

var tool_button : ToolButton = null

func _enter_tree():
	add_custom_type("WorldGeneratorSettings", "Resource", SWorldGeneratorSettings, null)
	
	add_custom_type("WorldGenBaseResource", "Resource", SWorldGenBaseResource, null)
	#Don't change the base to "WorldGenBaseResource" else it will complain about a non-existant class
	#Also it works perfectly like this
	add_custom_type("WorldGenWorld", "Resource", SWorldGenWorld, null)
	add_custom_type("Continent", "Resource", SContinent, null)
	add_custom_type("Zone", "Resource", SZone, null)
	add_custom_type("SubZone", "Resource", SSubZone, null)

	editor_scene = editor_packed_scene.instance()
	editor_scene.set_plugin(self)

	tool_button = add_control_to_bottom_panel(editor_scene, "World Editor")
	tool_button.hide()

func _exit_tree():
	remove_custom_type("WorldGeneratorSettings")
	
	remove_custom_type("WorldGenBaseResource")
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
		var wgw : WorldGenWorld = object as WorldGenWorld
		wgw.setup()
		editor_scene.set_wgworld(wgw)

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


