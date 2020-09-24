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

export(NodePath) var icon_path : NodePath
export(NodePath) var name_label_path : NodePath
export(NodePath) var description_label_path : NodePath

var _icon : TextureRect
var _name_label : Label
var _description_label : RichTextLabel

func _ready():
	_icon = get_node(icon_path) as TextureRect
	_name_label = get_node(name_label_path) as Label
	_description_label = get_node(description_label_path) as RichTextLabel

func set_item(item: CraftRecipeHelper) -> void:
	if item == null:
		return
	
	_icon.texture = item.item.icon
	_name_label.text = item.item.text_name
	_description_label.text = item.item.text_name
