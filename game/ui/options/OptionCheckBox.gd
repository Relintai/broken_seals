extends CheckBox

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(String) var property_category : String
export(String) var property_name : String

func _ready() -> void:
	var p : bool = Settings.get_value(property_category, property_name) as bool
	
	if p != pressed:
		pressed = p
	
func _toggled(button_pressed : bool) -> void:
	Settings.set_value(property_category, property_name, button_pressed)
