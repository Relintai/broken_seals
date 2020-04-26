tool
extends Control

signal inspect_data

export(PackedScene) var resource_scene : PackedScene
export(PackedScene) var folder_entry_button_scene : PackedScene
export(String) var base_folder : String = "res://modules/"
export(NodePath) var main_container : NodePath
export(NodePath) var folder_entry_container_path : NodePath


var _main_container : Node
var _resource_scene : Node
var _folder_entry_container : Node


var _folders : Array = [
]

func _ready():
	var dir : Directory = Directory.new()
	
	
	if dir.file_exists("res://ess_data.json"):
		var file : File = File.new()
		
		if file.open("res://ess_data.json", File.READ) == OK:
			var s : String = file.get_as_text()
			
			_folders = parse_json(s)
			
			file.close()
#	else:
#		var file : File = File.new()
#
#		if file.open("res://ess_data.json", File.WRITE) == OK:
#			file.store_string(to_json(_folders))
#
#			file.close()
	
	_main_container = get_node(main_container)
	
	_resource_scene = resource_scene.instance()
	_main_container.add_child(_resource_scene)
	_resource_scene.owner = _main_container
	_resource_scene.connect("inspect_data", self, "inspect_data")
	
	_folder_entry_container = get_node(folder_entry_container_path)
	
	for ch in _folder_entry_container.get_children():
		ch.queue_free()
	
	var index = 0
	for f in _folders:
		if f.has("header"):
			var h : Label = Label.new()
			
			_folder_entry_container.add_child(h)
			h.owner = _folder_entry_container
			
			h.text = f["header"]
		
		var fe : Node = folder_entry_button_scene.instance()
		
		_folder_entry_container.add_child(fe)
		fe.owner = _folder_entry_container
		
		fe.text = f["name"]
		fe.tab = index
		
		fe.set_main_panel(self)
		
		index += 1
	
	set_tab(0)
#	set_tab("test")

func set_tab(tab_index : int) -> void:
	hide_all()
	
	_resource_scene.show()
	_resource_scene.set_resource_type(_folders[tab_index]["folder"], _folders[tab_index]["type"])
	
func hide_all() -> void:
	_resource_scene.hide()

func inspect_data(var data : Resource) -> void:
	emit_signal("inspect_data", data)
