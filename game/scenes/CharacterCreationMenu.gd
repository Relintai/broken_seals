extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(PackedScene) var character_entry : PackedScene
export(NodePath) var menu_path : NodePath
export(NodePath) var name_imput_path : NodePath
export(NodePath) var container_path : NodePath
export(ButtonGroup) var character_creation_button_group : ButtonGroup
export(String) var character_folder : String

var container : Node
var name_line_edit : LineEdit

func _ready():
	name_line_edit = get_node(name_imput_path)
	container = get_node(container_path)
	
	var fb : Button = null
	
	for i in range(Entities.get_player_character_data_count()):
		var d : EntityData = Entities.get_player_character_data_index(i)
		
		var ce : Button = character_entry.instance() as Button
		
		if fb == null:
			fb = ce

		container.add_child(ce)
		ce.owner = container

		ce.id = d.id
		ce.set_class_name(d.entity_class_data.text_name)
		ce.group = character_creation_button_group
		
	if fb != null:
		fb.pressed = true

func create() -> void:
	if name_line_edit.text == "":
		return
		
	var file_name : String = "user://" + character_folder + "/" + name_line_edit.text
	
	var f : File = File.new()
	
	if f.file_exists(file_name):
		return
	
	var active : BaseButton = character_creation_button_group.get_pressed_button()
	
	var id : int = active.id
	
	var ent : Entity = Entities.spawn_player_for_menu(id, name_line_edit.text, self)
	if f.open(file_name, File.WRITE) == OK:
		f.store_string(to_json(ent.to_dict()))
		f.close()
	
	ent.queue_free()
	
	get_node(menu_path).switch_to_menu(Menu.StartMenuTypes.CHARACTER_SELECT)
	
