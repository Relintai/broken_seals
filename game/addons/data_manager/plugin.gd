tool
extends EditorPlugin

const DataManagerAddonSettings = preload("res://addons/data_manager/resources/data_manager_addon_settings.gd")

const _main_panel : PackedScene = preload("res://addons/data_manager/panels/MainPanel.tscn")
const _script_icon : Texture = preload("res://addons/data_manager/icons/icon_multi_line.png")

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
	return _script_icon

func get_plugin_name():
	return "Data"

func inspect_data(var data : Resource) -> void:
	get_editor_interface().inspect_object(data)

func ensure_data_dir_exists() -> void:
	var dir : Directory = Directory.new()
	
	if !dir.dir_exists("res://addons/data_manager/_data/"):
		dir.make_dir("res://addons/data_manager/_data/")

func load_settings() -> void:
	ensure_data_dir_exists()
	
	var dir : Directory = Directory.new()
	
	if !dir.file_exists("res://addons/data_manager/_data/settings.tres"):
		settings = DataManagerAddonSettings.new()
		
		ResourceSaver.save("res://addons/data_manager/_data/settings.tres", settings)
	else:
		settings = ResourceLoader.load("res://addons/data_manager/_data/settings.tres")
