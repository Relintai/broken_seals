tool
extends EditorPlugin

const _main_panel : PackedScene = preload("res://addons/module_manager/panels/MainPanel.tscn")
const _script_icon : Texture = preload("res://addons/module_manager/icons/icon_multi_line.png")

var _main_panel_instance : Control

func _enter_tree():
	_main_panel_instance = _main_panel.instance() as Control
	_main_panel_instance.connect("inspect_data", self, "inspect_data")

	get_editor_interface().get_editor_viewport().add_child(_main_panel_instance)

	make_visible(false)

func _exit_tree():
	_main_panel_instance.queue_free()
	
func has_main_screen():
	return true

func make_visible(visible):
	if visible:
		_main_panel_instance.show()
	else:
		_main_panel_instance.hide()

func get_plugin_icon():
	return _script_icon

func get_plugin_name():
	return "Modules"

func inspect_data(var data : Resource) -> void:
	get_editor_interface().inspect_object(data)
