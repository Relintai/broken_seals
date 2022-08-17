tool
extends EditorPlugin

const DataManagerAddonSettings = preload("res://addons/data_manager/resources/data_manager_addon_settings.gd")
const _main_panel : PackedScene = preload("res://addons/data_manager/panels/MainPanel.tscn")

var _script_icon : Texture = null

var settings : DataManagerAddonSettings = null

var _main_panel_instance : Control

func _enter_tree():
	load_settings()
	
	_main_panel_instance = _main_panel.instance() as Control
	_main_panel_instance.set_plugin(self)
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
	if !_script_icon:
		_script_icon = get_editor_interface().get_base_control().get_theme_icon("ThemeSelectAll", "EditorIcons")
		
	return _script_icon

func get_plugin_name():
	return "Data"

func inspect_data(var data : Resource) -> void:
	get_editor_interface().inspect_object(data)

func load_settings() -> void:
	settings = DataManagerAddonSettings.new()
	settings.load_from_project_settings()
