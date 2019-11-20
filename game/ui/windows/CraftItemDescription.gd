extends HBoxContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
