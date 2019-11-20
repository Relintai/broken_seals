extends HBoxContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _ready():
	var ob : OptionButton = $OptionButton as OptionButton
	
	ob.add_item("Single-Unsafe", 0)
	ob.add_item("Single-Safe", 1)
	ob.add_item("Multi Threaded", 2)
	
	ob.selected = Settings.get_value("rendering", "thread_model")
	
	ob.connect("item_selected", self, "item_selected")

func item_selected(id : int) -> void:
	Settings.set_value("rendering", "thread_model", id)
