extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(NodePath) var icon_path : NodePath
export(NodePath) var label_path : NodePath

var icon : TextureRect
var label : RichTextLabel

var index : int
var player : Entity
var item : ItemInstance

func _ready():
	icon = get_node(icon_path) as TextureRect
	label = get_node(label_path) as RichTextLabel
	
	if icon == null or label == null:
		Logger.error("LootEntry is not setup correctly!")

func on_click():
	player.crequest_loot(index)

func set_item(pindex : int, item_instance : ItemInstance, pplayer : Entity) -> void:
	index = index
	player = pplayer
	item = item_instance
	
	icon.texture = item.item_template.icon
	label.bbcode_text = item.item_template.text_name
