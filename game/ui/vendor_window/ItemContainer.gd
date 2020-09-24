extends Control

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

export(NodePath) var icon_path : NodePath
export(NodePath) var name_label_path : NodePath
#export(NodePath) var description_label_path : NodePath
export(NodePath) var quantity_spinbox_path : NodePath
export(NodePath) var learn_button_path : NodePath
export(NodePath) var spell_button_path : NodePath
export(NodePath) var popup_path : NodePath

export(Color) var known_color : Color = Color.white
export(Color) var not_known_color : Color = Color.gray
export(Color) var unlearnable_color : Color = Color.gray

var _icon : TextureRect
var _name_label : Label
#var _description_label : RichTextLabel
var _item_button : Button
var _popup : Popup
var _quantity_spinbox : SpinBox

var _vendor_item_data_entry : VendorItemDataEntry
var _player : Entity
var _index : int

func _ready() -> void:
	_icon = get_node(icon_path) as TextureRect
	_name_label = get_node(name_label_path) as Label
#	_description_label = get_node(description_label_path) as RichTextLabel
	_item_button = get_node(spell_button_path) as Button
	_popup = get_node(popup_path) as Popup
	_quantity_spinbox = get_node(quantity_spinbox_path) as SpinBox
	
func set_vendor_item(p_player : Entity, p_vide: VendorItemDataEntry, index : int) -> void:
	_vendor_item_data_entry = p_vide
	_player = p_player
	_index = index
	
#	_icon.set_spell(_spell)
	_item_button.set_item(_vendor_item_data_entry)
	_popup.set_item(_vendor_item_data_entry)
	
	if _vendor_item_data_entry != null && _vendor_item_data_entry.item != null:

		_icon.texture = _vendor_item_data_entry.item.icon
		_name_label.text = _vendor_item_data_entry.item.text_name
	else:
		_icon.texture = null
		
		_name_label.text = "....."
		
	update_spell_indicators()

func spell_button_pressed() -> void:
	var pos : Vector2 = _item_button.rect_global_position
	pos.x += _item_button.rect_size.x
	
	_popup.popup(Rect2(pos, _popup.rect_size))
	
func buy():
	if !_player:
		return
	
	var count : int = _quantity_spinbox.value
	
	_player.vendor_item_sbuy(_index, count)

func update_spell_indicators():
	pass
