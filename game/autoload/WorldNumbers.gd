extends Node

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(PackedScene) var number_scene

func damage(entity_position : Vector3, entity_height : float, value : int, crit : bool) -> void:
	var scene : Node = number_scene.instance()
	
	add_child(scene)
	scene.owner = self
	
	entity_position.y += entity_height + (0.2 * randf())
	entity_position.x += entity_height * 0.4 - entity_height * 0.8 * randf()
	entity_position.z += entity_height * 0.4 - entity_height * 0.8 * randf()
	
	scene.damage(entity_position, value, crit)
	
func heal(entity_position : Vector3, entity_height : float, value : int, crit : bool) -> void:
	var scene : Node = number_scene.instance()
	
	add_child(scene)
	scene.owner = self
	
	randomize()
	
	entity_position.y += entity_height + (0.3 * randf())
	entity_position.x += entity_height * 0.4 - entity_height * 0.8 * randf()
	entity_position.z += entity_height * 0.4 - entity_height * 0.8 * randf()
	
	
	scene.heal(entity_position, value, crit)

func clear() -> void:
	for child in get_children():
		child.queue_free()
