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

export (PackedScene) var action_bar_entry_scene
export (NodePath) var child_container_path
var child_container

func _ready() -> void:
	child_container = get_node(child_container_path)

func set_actionbar_entry(action_bar_entry : ActionBarEntry, player: Entity) -> void:

	for i in range(action_bar_entry.slot_num):
		var b : ActionBarButtonEntry = action_bar_entry.get_button_for_slotid(i)

	#for i in range(action_bar_entry.get_action_bar_entry_count()):
		#var b = action_bar_entry.get_button(i)

		var s : Node = action_bar_entry_scene.instance()
		
		child_container.add_child(s)
		
		s.set_player(player)
		s.set_button_entry(b, player)
		
		s.owner = child_container

