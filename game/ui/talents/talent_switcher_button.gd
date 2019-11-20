extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

var _index : int
var _spec_window : Node

func set_spec_index(spec_window : Node, index : int) -> void:
	_index = index
	_spec_window = spec_window

func _toggled(button_pressed):
	if button_pressed:
		_spec_window.select_spec(_index)
