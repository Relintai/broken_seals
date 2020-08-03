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

export(float) var min_value : float = 0
export(float) var max_value : float = 100
export(float) var step : float = 1
export(bool) var rounded : bool = true

export(String) var prefix : String = ""
export(String) var suffix : String = ""

var _sb : SpinBox = null

func _ready():
	$Label.text = property_label
	
	_sb = $SpinBox as SpinBox
	
	_sb.min_value = min_value
	_sb.max_value = max_value
	_sb.step = step
	
	_sb.prefix = prefix
	_sb.suffix = suffix
	
	_sb.rounded = rounded
	
	if Engine.editor_hint:
		return
	
	_sb = $SpinBox as SpinBox
	
	_sb.min_value = min_value
	_sb.max_value = max_value
	_sb.step = step
	_sb.value = Settings.get_value(property_category, property_name)
	
	_sb.connect("value_changed", self, "value_changed")

func value_changed(val: float) -> void:
	Settings.set_value(property_category, property_name, val)
