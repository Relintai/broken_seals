extends PopupPanel

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var label_path : NodePath
export(NodePath) var desc_label_path : NodePath

var _label : Label
var _desc_label : RichTextLabel

var _spell : Spell

func _ready():
	_label = get_node(label_path) as Label
	_desc_label = get_node(desc_label_path) as RichTextLabel

func set_spell(spell : Spell) -> void:
	_spell = spell
	
	if _spell == null:
		return
		
	_label.text = _spell.text_name
	_desc_label.text = _spell.text_description
	
