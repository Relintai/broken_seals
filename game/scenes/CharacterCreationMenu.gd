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
	
	var profile : PlayerProfile = ProfileManager.getc_player_profile()
	
	var fb : Button = null
	
	for i in range(ESS.get_resource_db().get_entity_data_count()):
		var d : EntityData = ESS.get_resource_db().get_entity_data_index(i)
		
		if not d.is_playable:
			continue
		
		var ce : Button = character_entry.instance() as Button
		
		if fb == null:
			fb = ce

		container.add_child(ce)
		ce.owner = container

		ce.id = d.id
		var class_profile : ClassProfile = profile.get_class_profile(d.resource_path)
		ce.set_class_name(d.entity_class_data.text_name, class_profile.level, class_profile)
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
	
	var ent : Entity = ESS.entity_spawner.spawn_player_for_menu(id, name_line_edit.text, self)
	if f.open(file_name, File.WRITE) == OK:
		f.store_string(to_json(ent.to_dict()))
		f.close()
	
	ent.queue_free()
	
	get_node(menu_path).switch_to_menu(Menu.StartMenuTypes.CHARACTER_SELECT)
	
