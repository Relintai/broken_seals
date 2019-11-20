extends CanvasLayer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var loot_window_path : NodePath
var loot_window : Control

func _ready():
	loot_window = get_node(loot_window_path) as Control

func _on_Player_onc_open_loot_winow_request() -> void:
	if loot_window != null:
		loot_window.show()
