extends Control

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

export(NodePath) var focus_button_path : NodePath = ""

var _previous : Control = null
var _current_focus : Control = null

var _viewport : Viewport = null


func _ready():
	connect("visibility_changed", self, "on_visibility_changed")

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
	_current_focus = node


func on_visibility_changed() -> void:
	if visible:
		focus()
	else:
		unfocus()

func focus():
	_previous = _current_focus
	
	var n : Control = get_node(focus_button_path)
	
	if n:
		n.grab_focus()
	
func unfocus():
	if _previous:
		_previous.grab_focus()
		_previous = null
	else:
		release_focus()
