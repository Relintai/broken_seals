extends Button

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

export(int) var equip_slot : int

export(NodePath) var texture_path : NodePath

var _texture : TextureRect
var _tooltip : Popup

var _player : Entity

var _item_instance : ItemInstance

func _ready():
	_texture = get_node(texture_path) as TextureRect
	
	connect("button_up", self, "_on_button_pressed")

func set_tooltip_node(tooltip : Popup) -> void:
	_tooltip = tooltip

func set_player(player: Entity) -> void:
	if _player != null:
		_player.disconnect("equip_con_success", self, "equip_con_success")
	
	_player = player
	
	if _player == null:
		return
	
	_player.connect("equip_con_success", self, "equip_con_success")
	
	equip_con_success(player, equip_slot, player.equip_getc_slot(equip_slot), null, 0)
	
func drop_data(position, data):
	if _player == null:
		return
	
	var dd : ESDragAndDrop = data as ESDragAndDrop
	
	if dd.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_EQUIPPED_ITEM:
		#todo
		return
		
	if dd.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_INVENTORY_ITEM:
		_player.equip_crequest(equip_slot, dd.get_meta("slot_id"))

func can_drop_data(position, data):
	if _player == null:
		return false
	
	if data is ESDragAndDrop and (data.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_EQUIPPED_ITEM or
		data.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_INVENTORY_ITEM):
		return true
		
	return false

func get_drag_data(position):
	if _item_instance == null:
		return null

	var tr = TextureRect.new()
	tr.texture = _texture.texture
	tr.expand = true
	
	tr.rect_size = _texture.rect_size
	set_drag_preview(tr)

	var esd = ESDragAndDrop.new()

	esd.origin = self
	esd.type = ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_EQUIPPED_ITEM
	esd.item_path = _item_instance.item_template.resource_path
	esd.set_meta("equip_slot_id", equip_slot)
	
	return esd

func equip_con_success(entity: Entity, pequip_slot: int, item: ItemInstance, old_item: ItemInstance, bag_slot: int):
	if equip_slot != pequip_slot:
		return

	_item_instance = item

	if item == null:
		_texture.texture = null
		return
		
	_texture.texture = item.item_template.icon

func _on_button_pressed() -> void:
#func _pressed():
	if _tooltip != null and _item_instance != null:
		var pos : Vector2 = rect_global_position
		pos.x += rect_size.x
		
		_tooltip.set_item(_player, _item_instance)
		_tooltip.popup(Rect2(pos, _tooltip.rect_size))
#		_tooltip.pac
