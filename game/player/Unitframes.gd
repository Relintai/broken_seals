extends Control

# Copyright (c) 2019 Péter Magyar
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

export (NodePath) var player_unit_frame_path : NodePath
export (NodePath) var target_unit_frame_path : NodePath

var target_unit_frame : Node
var player_unit_frame : Node

func _ready() -> void:
	target_unit_frame = get_node(target_unit_frame_path) as Node
	player_unit_frame = get_node(player_unit_frame_path) as Node

func set_player(player : Entity) -> void:
	player_unit_frame.set_player(player)
		
	_ctarget_changed(player, null)

	player.connect("ctarget_changed", self, "_ctarget_changed")
	

func _ctarget_changed(entity : Entity, old_target : Entity) -> void:
	if entity.ctarget == null:
		target_unit_frame.hide()
	else:
		target_unit_frame.show()
		
	target_unit_frame.set_player(entity.ctarget)
	
