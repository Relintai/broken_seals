extends Control
class_name Menu

# Copyright (c) 2019-2021 Péter Magyar
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

export(int, "Character Select", "Character Create") var start_menu : int = 0
export (NodePath) var character_selector_scene : NodePath
export (NodePath) var charcer_creation_scenes : NodePath
export (NodePath) var option_buttons_path : NodePath

enum StartMenuTypes {
	CHARACTER_SELECT, CHARACTER_CREATE
}

var _menu : int = 0
var _viewport : Viewport = null

func _ready() -> void:
	switch_to_menu(start_menu)

func _enter_tree() -> void:
	#find the viewport
	var n : Node = self

	while n:
		n = n.get_parent()
		
		if n is Viewport:
			_viewport = n as Viewport
			_viewport.connect("gui_focus_changed", self, "_on_control_focus_changed")
			break
			
func _exit_tree():
	if _viewport:
		_viewport.disconnect("gui_focus_changed", self, "_on_control_focus_changed")
		
	_viewport =  null
	
func _on_control_focus_changed(node : Control) -> void:
	if !node:
		if _menu == StartMenuTypes.CHARACTER_SELECT:
			get_node(character_selector_scene).focus()
		else:
			get_node(character_selector_scene).focus()

func switch_to_menu(menu : int) -> void:
	_menu = menu
	
	if menu == StartMenuTypes.CHARACTER_SELECT:
		get_node(character_selector_scene).show()
		get_node(option_buttons_path).show()
	else:
		get_node(character_selector_scene).hide()
		
	if menu == StartMenuTypes.CHARACTER_CREATE:
		get_node(charcer_creation_scenes).show()
		get_node(option_buttons_path).hide()
	else:
		get_node(charcer_creation_scenes).hide()



func _on_About_pressed() -> void:
	pass # Replace with function body.
