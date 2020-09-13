extends PopupPanel

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

export(NodePath) var label_path : NodePath
export(NodePath) var desc_label_path : NodePath
export(NodePath) var quantity_spinbox_path : NodePath

var _label : Label
var _desc_label : RichTextLabel
var _quantity_spinbox : SpinBox

var _item : ItemTemplate
var _item_data_entry : VendorItemDataEntry

func _ready():
	_label = get_node(label_path) as Label
	_desc_label = get_node(desc_label_path) as RichTextLabel
	_quantity_spinbox = get_node(quantity_spinbox_path) as SpinBox

func set_item(item_data_entry : VendorItemDataEntry) -> void:
	_item_data_entry = item_data_entry
	
	if _item_data_entry == null:
		return
	
	_item = _item_data_entry.item
	
	if _item == null:
		return
		
	_label.text = _item.text_name
	_desc_label.text = _item.get_description()
	_quantity_spinbox.max_value = _item.stack_size
	_quantity_spinbox.value = 1
	
