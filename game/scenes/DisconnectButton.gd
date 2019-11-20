extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _ready():
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("server_disconnected", self, "server_disconnected")
	
func _exit_tree():
	get_tree().disconnect("connected_to_server", self, "connected_to_server")
	get_tree().disconnect("server_disconnected", self, "server_disconnected")

func connected_to_server():
	show()
	
func server_disconnected():
	hide()
