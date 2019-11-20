extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var menu_path : NodePath
export(NodePath) var container_path : NodePath
export(NodePath) var player_display_container_path : NodePath
export(ButtonGroup) var character_button_group : ButtonGroup
export(PackedScene) var character_entry : PackedScene
export(String) var character_folder : String

var container : Node
var player_display_container_node : Node

func _ready():
	container = get_node(container_path)
	player_display_container_node = get_node(player_display_container_path)
	
	if container == null:
		Logger.error("CharacterSelector not set up properly!")
		
	connect("visibility_changed", self, "visibility_changed")
		
	refresh()

func refresh():
	clear()
#	Entities.list_spells()
	var dir : Directory = Directory.new()
	
	var first_entry : Button = null
	
	if dir.open("user://" + character_folder) == OK:
		dir.list_dir_begin()
		
		var file_name = "."
		
		while (file_name != ""):
			file_name = dir.get_next()
			
			if dir.current_is_dir():
				continue
			
			var f : File = File.new()
			
			if f.open("user://" + character_folder + "/" + file_name, File.READ) == OK:
				var st : String = f.get_as_text()
				f.close()
				
				var json_err : String = validate_json(st)
				
				if json_err != "":
					Logger.error("Save corrupted! " + file_name)
					Logger.error(json_err)
					continue
				
				var p = parse_json(st)
				
				if typeof(p) != TYPE_DICTIONARY:
					Logger.error("Save corrupted! Not Dict! " + file_name)
					continue
				
				var display : Entity = Entities.spawn_display_player(file_name)
				player_display_container_node.add_child(display)
				display.owner = player_display_container_node
				
				display.from_dict(p as Dictionary)
				
				var centry : Button = character_entry.instance() as Button
				container.add_child(centry)
				centry.owner = container
				centry.group = character_button_group
				centry.connect("pressed", self, "character_selection_changed")
				
				#display.sentity_data.entity_class_data.entity_class_name
				centry.setup(file_name, display.sentity_name, "", display.slevel, display)
				
				if first_entry == null:
					first_entry = centry
					
		if first_entry != null:
			first_entry.pressed = true
				
	else:
		dir.make_dir("user://" + character_folder)

func clear() -> void:
	for c in container.get_children():
		c.disconnect("pressed", self, "character_selection_changed")
		c.queue_free()
		
	for e in player_display_container_node.get_children():
		e.queue_free()

func delete_character() -> void:
	var b : BaseButton = character_button_group.get_pressed_button()
	
	if b == null:
		return
	
	var file_name : String = "user://" + character_folder + "/" + b.file_name
	
	var f : File = File.new()
			
	if f.file_exists(file_name):
		var d : Directory = Directory.new()
		if d.remove(file_name) == OK:
			refresh()
	
func load_character() -> void:
	var b : BaseButton = character_button_group.get_pressed_button()
	
	if b == null:
		return
	
#	if multiplayer.has_network_peer():
#		var file_name : String = "user://" + character_folder + "/" + b.file_name
#
#		var f : File = File.new()
#
#		if f.open(file_name, File.READ) == OK:
#			var data : String = f.get_as_text()
#
#			f.close()
#
#			Server.upload_character(data)
#
#			get_node("/root/Main").load_character(b.file_name)
#	else:
	get_node("/root/Main").load_character(b.file_name)
	
func visibility_changed() -> void:
	if visible:
		refresh()
		
func character_selection_changed() -> void:
	var b : BaseButton = character_button_group.get_pressed_button()
	
	if b == null:
		return
		
	for e in player_display_container_node.get_children():
		e.hide()
		
	b.entity.show()
