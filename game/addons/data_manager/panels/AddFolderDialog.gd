tool
extends ConfirmationDialog

const DataManagerAddonSettings = preload("res://addons/data_manager/resources/data_manager_addon_settings.gd")

var _settings : DataManagerAddonSettings = null
var _module = null

signal folders_created

func _enter_tree():
	if !is_connected("confirmed", self, "on_confirmed"):
		connect("confirmed", self, "on_confirmed")

func setup() -> void:
	var entry_container : Control = $ScrollContainer/VBoxContainer

	for ch in entry_container.get_children():
		ch.queue_free()
		
	var dir : Directory = Directory.new()
	
	var label_str : String = "= " + get_module_label_text(_module) + " ="
	window_title = "Add folder(s) for " + label_str

	var module_dir_base : String = _module.resource_path.get_base_dir()
		
	for f in _settings.folders:
		if dir.dir_exists(module_dir_base + "/" + f.folder):
			continue
			
		var ecb : CheckBox = CheckBox.new()
		ecb.text = f.folder + " (" + f.type + ")"
		ecb.set_meta("folder", f.folder)
		entry_container.add_child(ecb)

func on_confirmed() -> void:
	var entry_container : Control = $ScrollContainer/VBoxContainer

	var dir : Directory = Directory.new()
	var module_dir_base : String = _module.resource_path.get_base_dir()
	
	for c in entry_container.get_children():
		if !(c is CheckBox):
			continue
			
		if !c.pressed:
			continue
			
		var folder : String = c.get_meta("folder")
		var d : String = module_dir_base + "/" + folder
		if !dir.dir_exists(d):
			dir.make_dir(d)
			
	emit_signal("folders_created")

func set_module(module, settings : DataManagerAddonSettings) -> void:
	_module = module
	_settings = settings
	setup()
	#popup_centered()
	
	popup_centered()

func get_module_label_text(module) -> String:
	var label_str : String = module.resource_name
		
	if label_str == "":
		label_str = module.resource_path
		label_str = label_str.replace("res://", "")
		label_str = label_str.replace("/game_module.tres", "")
		label_str = label_str.replace("game_module.tres", "")
		
	return label_str
