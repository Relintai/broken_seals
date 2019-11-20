extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
	
