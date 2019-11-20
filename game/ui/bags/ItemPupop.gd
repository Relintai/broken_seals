extends PopupPanel

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var name_path : NodePath
export(NodePath) var description_path : NodePath

var _name : RichTextLabel
var _description : RichTextLabel

func _ready():
	_name = get_node(name_path) as RichTextLabel
	_description = get_node(description_path) as RichTextLabel

func set_item(item : ItemInstance) -> void:
	_name.bbcode_text = item.item_template.text_name
#	_description.text = item.item_template.
