extends PanelContainer

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
