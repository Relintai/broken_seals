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

export(NodePath) var name_path : NodePath
export(NodePath) var description_path : NodePath
export(NodePath) var use_button_path : NodePath

var _name : RichTextLabel
var _description : RichTextLabel
var _use_button : Button

var _entity : Entity
var _item : ItemInstance

func _ready():
	_name = get_node(name_path) as RichTextLabel
	_description = get_node(description_path) as RichTextLabel
	_use_button = get_node(use_button_path) as Button

func set_item(entity : Entity, item : ItemInstance) -> void:
	_entity = entity
	_item = item
	
	_name.bbcode_text = item.item_template.text_name
#	_description.text = item.item_template.

	if item.item_template.use_spell != null:
		_use_button.show()
	else:
		_use_button.hide()
		
func use_button_pressed():
	_entity.item_crequest_use(_item.item_template.id)
