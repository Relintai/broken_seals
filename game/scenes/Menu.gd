extends Control
class_name Menu

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(int, "Character Select", "Character Create") var start_menu : int = 0
export (NodePath) var character_selector_scene : NodePath
export (NodePath) var charcer_creation_scenes : NodePath

enum StartMenuTypes {
	CHARACTER_SELECT, CHARACTER_CREATE
}

func _ready():
	switch_to_menu(start_menu)
	
func switch_to_menu(menu : int) -> void:
	
	if menu == StartMenuTypes.CHARACTER_SELECT:
		get_node(character_selector_scene).show()
	else:
		get_node(character_selector_scene).hide()
		
	if menu == StartMenuTypes.CHARACTER_CREATE:
		get_node(charcer_creation_scenes).show()
	else:
		get_node(charcer_creation_scenes).hide()

