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

export(PackedScene) var entry_scene : PackedScene
export(NodePath) var container_path : NodePath

var container : Node

var player : Entity
var target_bag : Bag

func _ready():
	get_node("../../../").loot_window = self
	
	container = get_node(container_path)
	
	connect("visibility_changed", self, "on_visibility_changed")
	
	if entry_scene == null:
		Logger.error("LootWindow: entry_scene is null")

func refresh():
	for child in container.get_children():
		child.queue_free()
	
	if target_bag == null:
		return

	for i in range(target_bag.get_size()):
		var ii : ItemInstance = target_bag.get_item(i)
		
		if ii:
			var e : Node = entry_scene.instance()
			
			container.add_child(e)
			e.owner = container
			
			e.set_item(i, ii, player)

func set_player(p_player : Entity) -> void:
	player = p_player
	player.connect("ctarget_bag_changed", self, "ctarget_bag_changed")
	player.connect("onc_open_winow_request", self, "onc_open_loot_winow_request")

func on_player_moved():
	if visible:
		hide()

func on_visibility_changed():
	if visible:
		refresh()
	else:
		if target_bag != null:
			target_bag.disconnect("item_removed", self, "on_item_removed")
			target_bag = null

func on_item_removed(bag: Bag, item: ItemInstance, slot_id: int) -> void:
	refresh()

func ctarget_bag_changed(entity: Entity, bag: Bag) -> void:
	if target_bag != null:
		target_bag.disconnect("item_removed", self, "on_item_removed")
		target_bag = null

	target_bag = bag
	
	if target_bag == null:
		return
	
	target_bag.connect("item_removed", self, "on_item_removed")
	
func onc_open_loot_winow_request(window_id) -> void:
	if window_id != EntityEnums.ENTITY_WINDOW_LOOT:
		return
	
	show()

	if player.has_signal("player_moved") && !player.is_connected("player_moved", self, "on_player_moved"):
		player.connect("player_moved", self, "on_player_moved", [], CONNECT_ONESHOT)
