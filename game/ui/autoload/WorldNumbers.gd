extends Node

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
