extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var container_path : NodePath
export(NodePath) var status_label_path : NodePath

export(NodePath) var use_websockets_checkbox_path : NodePath

export(NodePath) var port_line_edit_path : NodePath

var _container : Control
var _status : Label

var _use_websockets_checkbox : CheckBox

var _port_line_edit : LineEdit

func _ready():
	_container = get_node(container_path) as Control
#	get_tree().connect("connected_to_server", self, "connected_to_server")
	
	_status = get_node(status_label_path) as Label
	_status.text = ""
	
	_use_websockets_checkbox = get_node(use_websockets_checkbox_path) as CheckBox
	
	_port_line_edit = get_node(port_line_edit_path) as LineEdit

#func _exit_tree():
#	get_tree().disconnect("connected_to_server", self, "connected_to_server")

func _pressed():
	var port : String = _port_line_edit.text
	
	var portint : int = int(port)
	
	_status.text = "Connecting..."
	var err : int = 0

	if _use_websockets_checkbox.pressed:
		err = Server.start_hosting_websocket(portint)
	else:
		err = Server.start_hosting(portint)

	if err != OK:
		_status.text = "Error: " + str(err)
	else:
		_container.hide()
	

#func connected_to_server():
#	_container.hide()
