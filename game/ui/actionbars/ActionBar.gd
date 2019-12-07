extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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

