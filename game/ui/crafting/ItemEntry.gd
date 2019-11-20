extends PanelContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var icon_path : NodePath
export(NodePath) var label_path : NodePath

var _icon : TextureRect
var _label : Label

var _entity : Entity
var _crh : CraftRecipeHelper

func _ready():
	_icon = get_node(icon_path) as TextureRect
	_label = get_node(label_path) as Label

func set_item(entity: Entity, crh: CraftRecipeHelper) -> void:
	_entity = entity
	_crh = crh
	
	refresh()

func refresh() -> void:
	if _crh.item == null:
		return
	
	_icon.texture = _crh.item.icon
	_label.text = _crh.item.text_name + " (" + str(_crh.count) + ")"
