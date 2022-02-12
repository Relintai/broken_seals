extends TabContainer

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

export(NodePath) var focus_control_on_tab_change_path : NodePath

export(String) var prev_tab_action : String = "ui_prev_page"
export(String) var next_tab_action : String = "ui_next_page"

var _focus_control_on_tab_change : Control = null

func _ready():
	_focus_control_on_tab_change = get_node(focus_control_on_tab_change_path) as Control
	
	connect("visibility_changed", self, "on_visibility_changed")
	on_visibility_changed()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed(next_tab_action, false):
		var oct : int = current_tab
		
		current_tab += 1
		
		if current_tab != oct:
			_focus_control_on_tab_change.grab_focus()
			
		get_tree().set_input_as_handled()
	elif event.is_action_pressed(prev_tab_action, false):
		var oct : int = current_tab
		
		current_tab -= 1
		
		if current_tab != oct:
			_focus_control_on_tab_change.grab_focus()
			
		get_tree().set_input_as_handled()

func on_visibility_changed() -> void:
	if is_visible_in_tree():
		set_process_input(true)
	else:
		set_process_input(false)
