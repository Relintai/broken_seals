extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(PackedScene) var entry_scene : PackedScene
export(NodePath) var container_path : NodePath

var container : Node

var player : Entity
var target_bag : Bag

func _ready():
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

func on_visibility_changed():
	if visible:
		refresh()
	else:
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
	
