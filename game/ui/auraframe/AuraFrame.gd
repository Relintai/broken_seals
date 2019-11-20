extends MarginContainer

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export (PackedScene) var aura_entry_scene : PackedScene

export (NodePath) var buff_container_path : NodePath
export (NodePath) var debuff_container_path : NodePath

var buff_container_node : Node
var debuff_container_node : Node

var buff_nodes : Array
var debuff_nodes : Array

var entity : Entity

func _ready():
	buff_container_node = get_node(buff_container_path)
	debuff_container_node = get_node(debuff_container_path)

func set_target(pentity : Entity) -> void:
	if entity != null:
		pass
	
	entity = pentity
	entity.connect("caura_added", self, "on_caura_added")
	entity.connect("caura_removed", self, "on_caura_removed")

func on_caura_added(aura_data : AuraData) -> void:
	var created_node : Node = aura_entry_scene.instance()
	
	if (not aura_data.aura.debuff):
		buff_container_node.add_child(created_node)
		created_node.owner = buff_container_node
	else:
		debuff_container_node.add_child(created_node)
		created_node.owner = debuff_container_node
	
	created_node.set_aura_data(aura_data)

func on_caura_removed(aura_data : AuraData) -> void:
	if (not aura_data.aura.debuff):
		for bn in buff_container_node.get_children():
			if bn.get_aura_data() == aura_data:
				buff_container_node.remove_child(bn)
				bn.queue_free()
				return
	else:
		for bn in debuff_container_node.get_children():
			if bn.get_aura_data() == aura_data:
				debuff_container_node.remove_child(bn)
				bn.queue_free()
				return

func set_player(player : Entity) -> void:
	set_target(player)
