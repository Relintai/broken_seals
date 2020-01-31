tool
extends HBoxContainer

# Copyright (c) 2019-2020 Péter Magyar
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

export(String) var property_category : String
export(String) var property_name : String

export(String) var property_label : String

export(Array, String) var options : Array

func _ready():
	$Label.text = property_label
	
	if Engine.editor_hint:
		return
		
	var ob : OptionButton = $OptionButton as OptionButton
	
	for i in range(options.size()):
		ob.add_item(options[i], i)
	
	ob.selected = Settings.get_value(property_category, property_name)
	
	ob.connect("item_selected", self, "item_selected")

func item_selected(id : int) -> void:
	Settings.set_value(property_category, property_name, id)
