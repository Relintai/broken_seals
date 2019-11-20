extends MarginContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var container_path : NodePath
var container : Node

export(String) var character_folder : String

func _ready():
	container = get_node(container_path)
	
	if container == null:
		Logger.error("CharacterSelector not set up properly!")
		
	refresh()

func refresh():
	var dir : Directory = Directory.new()
	
	if dir.open("user://" + character_folder) == OK:
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		
		while (file_name != ""):
			if dir.current_is_dir():
				file_name = dir.get_next()
				
			
				
	else:
		dir.make_dir("user://" + character_folder)

