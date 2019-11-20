extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


func _ready():
	connect("pressed", self, "on_click")
	
func on_click() -> void:
	get_node("/root/Main").switch_scene(Main.StartSceneTypes.MENU)
