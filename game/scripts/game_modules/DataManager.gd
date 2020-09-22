extends Node

const PLAYER_UI_INSTANCE : int = 0

export(PackedScene) var player_ui : PackedScene 

var _modules : Array

func _ready() -> void:
	ProfileManager.load()
#	ESS.resource_db = ESSResourceDBMap.new()
	ESS.resource_db = ESSResourceDBStatic.new()
	ESS.resource_db.remap_ids = true
#	ESS.load_all()
	
	initialize_modules()

func initialize_modules() -> void:
	_modules.clear()
	
	load_modules_at("res://")
	
	_modules.sort_custom(ModulePathSorter, "sort_ascending")
	
	for module in _modules:
		if module.has_method("load_module"):
			module.load_module()
	
func load_modules_at(path : String) -> void:
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name == "." or file_name == "..":
				file_name = dir.get_next()
				continue

			if dir.current_is_dir():
				if path == "res://":
					load_modules_at(path + file_name)
				else:
					load_modules_at(path + "/" + file_name)
			else:
				if file_name == "game_module.tres":
					var res : Resource = null
					
					if path == "res://":
						res = ResourceLoader.load(path + file_name)
					else:
						res = ResourceLoader.load(path + "/" + file_name)
						
					if res.enabled:
						_modules.append(res)
					
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: " + path)


func request_instance(what : int) -> Node:
	var inst : Node = null
	
	if what == PLAYER_UI_INSTANCE:
		inst = player_ui.instance()
		inst.initialize()
	
	for module in _modules:
#		if module.has_method("on_request_instance"):
		module.on_request_instance(what, inst)
			
	return inst

class ModulePathSorter:
	static func sort_ascending(a, b):
		if a.resource_path < b.resource_path:
			return true
		return false
