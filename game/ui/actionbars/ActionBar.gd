extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (PackedScene) var action_bar_entry_scene
export (NodePath) var child_container_path
var child_container

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child_container = get_node(child_container_path)
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_actionbar_entry(action_bar_entry : ActionBarEntry, player: Entity) -> void:
	#rect_size = Vector2(action_bar_entry.size, (action_bar_entry.size) * action_bar_entry.slot_num)
	#set_anchors_preset(Control.PRESET_BOTTOM_RIGHT, false)
	#margin_left = action_bar_entry.action_bar_id * -(action_bar_entry.size + 5) - 10
	
	margin_top = - ((action_bar_entry.size) * action_bar_entry.slot_num)
	#margin_bottom = 0
	margin_right = -((action_bar_entry.action_bar_id - 1) * action_bar_entry.size)
	margin_left = -((action_bar_entry.action_bar_id) * action_bar_entry.size)

	for i in range(action_bar_entry.slot_num):
		var b : ActionBarButtonEntry = action_bar_entry.get_button_for_slotid(i)

	#for i in range(action_bar_entry.get_action_bar_entry_count()):
		#var b = action_bar_entry.get_button(i)

		var s : Node = action_bar_entry_scene.instance()
		
		child_container.add_child(s)
		
		s.set_player(player)
		s.set_button_entry(b, player)
		
		s.owner = child_container

