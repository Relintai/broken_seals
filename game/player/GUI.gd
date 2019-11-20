extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (NodePath) var player_path : NodePath
export (Array, NodePath) var child_controls : Array

func _ready() -> void:
	
	if player_path != null:
		var player = get_node(player_path)
	
	
		for child_path in child_controls:
			var child = get_node(child_path)
			
			child.set_player(player)
	
