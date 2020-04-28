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
	player.loot_crequest(index)

func set_item(pindex : int, item_instance : ItemInstance, pplayer : Entity) -> void:
	index = index
	player = pplayer
	item = item_instance
	
	icon.texture = item.item_template.icon
	label.bbcode_text = item.item_template.text_name
