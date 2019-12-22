extends Button

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
