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

var opener_button : BaseButton

export(PackedScene) var inventory_item_scene : PackedScene
export(NodePath) var inventory_item_container_path : NodePath
export(NodePath) var item_tooltip_path : NodePath
export(Array, NodePath) var inventory_slots : Array

var _inventory_slots : Array
var _inventory_item_container : Node
var _tooltip : Popup

var _player : Entity = null
var _bag : Bag = null

func _ready() -> void:
	_inventory_item_container = get_node(inventory_item_container_path)
	_tooltip = get_node(item_tooltip_path)
	
	for np in inventory_slots:
		var es : Control = get_node(np) as Control
		es.set_tooltip_node(_tooltip)
		_inventory_slots.append(es)
	
	connect("visibility_changed", self, "on_visibility_changed")

func set_player(p_player: Entity) -> void:
	if _player != null:
		_player.disconnect("cbag_changed", self, "cbag_changed")
		_player.disconnect("equip_con_success", self, "equip_con_success")
		
		for ie in _inventory_item_container.get_children():
			ie.queue_free()

	_player = p_player
	
	_player.connect("cbag_changed", self, "cbag_changed")
	_player.connect("equip_con_success", self, "equip_con_success")
	
	cbag_changed(_player, _player.cbag)
	
	for np in _inventory_slots:
		np.set_player(_player)
	
	refresh_bags()

func refresh_bags() -> void:
	if _bag == null:
		return
		
	if not visible:
		return
	
#	if _bag.size == _inventory_item_container.get_child_count():
#		return
	
	for ie in _inventory_item_container.get_children():
		ie.queue_free()
	
	for i in range(_bag.get_size()):
		var n : Node = inventory_item_scene.instance()
		
		_inventory_item_container.add_child(n)
		n.owner = _inventory_item_container
		
		n.set_slot_id(i)
		n.set_tooltip_node(_tooltip)
		n.set_player(_player)
		n.set_item_instance(_bag.get_item(i))

func cbag_changed(entity: Entity, bag: Bag) -> void:
	if _bag != null:
		_bag.disconnect("size_changed", self, "bag_size_changed")
		_bag.disconnect("item_added", self, "bag_item_added")
		_bag.disconnect("item_count_changed", self, "item_count_changed")
		_bag.disconnect("item_removed", self, "item_removed")
		_bag.disconnect("item_swapped", self, "item_swapped")
		
	_bag = entity.cbag
	
	if _bag == null:
		return
	
	_bag.connect("size_changed", self, "bag_size_changed")
	_bag.connect("item_added", self, "bag_item_added")
	_bag.connect("item_count_changed", self, "item_count_changed")
	_bag.connect("item_removed", self, "item_removed")
	_bag.connect("item_swapped", self, "item_swapped")

#	overburden_removed(bag: Bag)
#	overburdened(bag: Bag)
	
func bag_size_changed(bag: Bag) -> void:
	refresh_bags()
	
func bag_item_added(bag: Bag, item: ItemInstance, slot_id: int) -> void:
	refresh_bags()
	
func item_count_changed(bag: Bag, item: ItemInstance, slot_id: int) -> void:
	refresh_bags()
	
func item_removed(bag: Bag, item: ItemInstance, slot_id: int) -> void:
	refresh_bags()
	
func item_swapped(bag: Bag, item1_slot : int, item2_slot: int) -> void:
	refresh_bags()
	
func equip_con_success(entity, equip_slot, item, old_item, bag_slot) -> void:
	refresh_bags()

func on_visibility_changed():
	refresh_bags()
	
	if opener_button:
		if visible && !opener_button.pressed:
			opener_button.pressed = true
			return
			
		if !visible && opener_button.pressed:
			opener_button.pressed = false

func _on_button_toggled(button_pressed):
	if button_pressed:
		if !visible:
			show()
	else:
		if visible:
			hide()
