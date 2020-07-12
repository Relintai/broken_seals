extends Control

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

export(NodePath) var menu_path : NodePath
export(NodePath) var container_path : NodePath
export(NodePath) var player_display_container_path : NodePath
export(ButtonGroup) var character_button_group : ButtonGroup
export(PackedScene) var character_entry : PackedScene
export(String) var character_folder : String

export(NodePath) var load_button_path : NodePath
export(NodePath) var renounce_button_path : NodePath
export(NodePath) var create_button_path : NodePath

export(bool) var automatic_character_load : bool = false
export(bool) var only_one_character : bool = false

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
				
				var display : Entity = ESS.entity_spawner.spawn_display_player(file_name, player_display_container_node.get_path())
				
				var entity_data : EntityData = ESS.get_resource_db().get_entity_data(display.characterclass_id)
				
				if entity_data == null:
					print("EntityData not found!")
					display.queue_free()
					continue
				
				#player_display_container_node.add_child(display)
				#display.owner = player_display_container_node
				
				#display.from_dict(p as Dictionary)
				
				var centry : Button = character_entry.instance() as Button
				container.add_child(centry)
				centry.owner = container
				centry.group = character_button_group
				centry.pressed = true
				centry.connect("pressed", self, "character_selection_changed")
				
				centry.setup(file_name, display.sentity_name, ESS.get_resource_db().get_entity_data(display.characterclass_id).text_name, display.slevel, display.slevel, display)
				
				if first_entry == null:
					first_entry = centry
					
		if first_entry != null:
			first_entry.pressed = true
			
		if first_entry != null:
			#note that this just disables the create button, and 
			#will still allow character creation otherwise
			if only_one_character:
				get_node(create_button_path).hide()
				get_node(container_path).show()
			
			get_node(load_button_path).show()
			get_node(renounce_button_path).show()
			
			if (automatic_character_load):
				load_character()
		else:
			if only_one_character:
				get_node(create_button_path).show()
				get_node(container_path).hide()
				
			get_node(load_button_path).hide()
			get_node(renounce_button_path).hide()
	else:
		dir.make_dir("user://" + character_folder)
		if only_one_character:
			get_node(container_path).hide()
			get_node(create_button_path).show()
			
		get_node(load_button_path).hide()
		get_node(renounce_button_path).hide()

func clear() -> void:
	for c in container.get_children():
		c.disconnect("pressed", self, "character_selection_changed")
		c.queue_free()
		
	for e in player_display_container_node.get_children():
		e.queue_free()

func renounce_character() -> void:
	var b : BaseButton = character_button_group.get_pressed_button()
	
	if b == null:
		return
		
	if ESS.use_class_xp:
		var class_profile : ClassProfile = ProfileManager.getc_player_profile().get_class_profile(b.entity.sentity_data.resource_path)
		
		if ESS.can_class_level_up(class_profile.level):
			class_profile.xp += b.entity.sclass_xp
			
			
			var xpr : int = ESS.get_class_xp(class_profile.level)
			
			while ESS.can_class_level_up(class_profile.level) and class_profile.xp >= xpr:
				class_profile.level += 1
				class_profile.xp -= xpr
				
				xpr = ESS.get_class_xp(class_profile.level)
				
			ProfileManager.save()

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
		e.get_body().hide()
		
	b.entity.get_body().show()
