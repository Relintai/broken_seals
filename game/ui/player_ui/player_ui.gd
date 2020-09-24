extends CanvasLayer

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

export (String) var player_path : String = "../.."


export(NodePath) var gui_base_path : NodePath
export(NodePath) var buttons_path : NodePath
export(NodePath) var windows_path : NodePath

var gui_base : Node
var buttons : Node
var windows : Node

var loot_window : Control

func _ready():
	initialize()
	
	if player_path != null:
		var player = get_node(player_path)
	
		for c in windows.get_children():
			if c.has_method("set_player"):
				c.set_player(player)
				
		for c in gui_base.get_children():
			if c.has_method("set_player"):
				c.set_player(player)

func initialize():
	gui_base = get_node(gui_base_path)
	buttons = get_node(buttons_path)
	windows = get_node(windows_path)


func _on_Player_onc_open_loot_winow_request() -> void:
	if loot_window != null:
		loot_window.show()
