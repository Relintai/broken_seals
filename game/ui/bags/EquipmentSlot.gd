extends Button

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(int) var equip_slot : int

export(NodePath) var texture_path : NodePath

var _texture : TextureRect
var _tooltip : Popup

var _player : Entity

var _item_instance : ItemInstance

func _ready():
	_texture = get_node(texture_path) as TextureRect

func set_tooltip_node(tooltip : Popup) -> void:
	_tooltip = tooltip

func set_player(player: Entity) -> void:
	if _player != null:
		_player.disconnect("con_equip_success", self, "con_equip_success")
	
	_player = player
	
	if _player == null:
		return
	
	_player.connect("con_equip_success", self, "con_equip_success")
	
func drop_data(position, data):
	if _player == null:
		return
	
	var dd : ESDragAndDrop = data as ESDragAndDrop
	
	if dd.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_EQUIPPED_ITEM:
		#todo
		return
		
	if dd.type == ESDragAndDrop.ES_DRAG_AND_DROP_TYPE_INVENTORY_ITEM:
		_player.crequest_equip(equip_slot, dd.item_id)

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
	esd.item_id = equip_slot
	
	return esd

func con_equip_success(entity: Entity, pequip_slot: int, item: ItemInstance, old_item: ItemInstance, bag_slot: int):
	if equip_slot != pequip_slot:
		return

	_item_instance = item
	
	if item == null:
		_texture.texture = null
		return
		
	_texture.texture = item.item_template.icon
