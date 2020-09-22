extends Node
class_name Main

# Copyright (c) 2019-2020 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export(int, "None",  "Menu", "World") var start_scene = 1
export(PackedScene) var menu_scene : PackedScene
export(PackedScene) var world_scene : PackedScene
export(PackedScene) var debug_camera_scene : PackedScene
export(NodePath) var loading_screen_path : NodePath

enum StartSceneTypes {
	NONE, MENU, WORLD
}

var _loading_screen : Node

var current_scene : Node
var current_character_file_name : String = ""

var _modules : Array

func _ready() -> void:
	_loading_screen = get_node(loading_screen_path)
	
	ProfileManager.load()
#	ESS.resource_db = ESSResourceDBMap.new()
	ESS.resource_db = ESSResourceDBStatic.new()
	ESS.resource_db.remap_ids = true
#	ESS.load_all()
	
	initialize_modules()
	
	switch_scene(start_scene)

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
					
					_modules.append(res)
					
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: " + path)

func switch_scene(scene : int) -> void:
	if current_scene != null:
		for s in get_tree().get_nodes_in_group("save"):
			if not s.has_method("save"):
				print(str(s) + " is in group save, but doesn't have save()!")
				continue

			s.save()
		
		current_scene.queue_free()
		remove_child(current_scene)
		
	WorldNumbers.clear()
	
	if scene == StartSceneTypes.MENU:
		var gs : Node = menu_scene.instance()
		add_child(gs)
		gs.owner = self
		
		current_scene = gs
	
	elif scene == StartSceneTypes.WORLD:
		var gs : Node = world_scene.instance()
		add_child(gs)
		gs.owner = self
		
		current_scene = gs
		
		if multiplayer.has_network_peer():# and get_tree().network_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
			if multiplayer.is_network_server():
				gs.load_character(current_character_file_name)
			else:
#				var dc = debug_camera_scene.instance()
#
#				gs.add_child(dc)
#				dc.owner = gs
#
				gs.setup_client_seed(Server._cseed)
				
				var file_name : String = "user://characters/" + current_character_file_name
	
				var f : File = File.new()
				
				if f.open(file_name, File.READ) == OK:
					var data : String = f.get_as_text()
					
					f.close()
					
					Server.upload_character(data)
		else:
			gs.load_character(current_character_file_name)
		
	if current_scene.has_method("needs_loading_screen"):
		if current_scene.needs_loading_screen():
			show_loading_screen()

func load_character(file_name : String) -> void:
	current_character_file_name = file_name
	
	switch_scene(StartSceneTypes.WORLD)

func show_loading_screen() -> void:
	_loading_screen.show()
	
func hide_loading_screen() -> void:
	_loading_screen.hide()
	
class ModulePathSorter:
	static func sort_ascending(a, b):
		if a.resource_path < b.resource_path:
			return true
		return false
