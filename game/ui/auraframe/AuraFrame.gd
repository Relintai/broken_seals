extends Control

# Copyright (c) 2019-2021 Péter Magyar
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
	entity.connect("notification_caura", self, "on_notification_caura")

func on_notification_caura(what :int, aura_data : AuraData) -> void:
	if what == SpellEnums.NOTIFICATION_AURA_ADDED:
		var created_node : Node = aura_entry_scene.instance()
		
		if (not aura_data.aura.aura_debuff):
			buff_container_node.add_child(created_node)
			created_node.owner = buff_container_node
		else:
			debuff_container_node.add_child(created_node)
			created_node.owner = debuff_container_node
		
		created_node.set_aura_data(aura_data)
	elif what == SpellEnums.NOTIFICATION_AURA_REMOVED:
		if (not aura_data.aura.aura_debuff):
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
