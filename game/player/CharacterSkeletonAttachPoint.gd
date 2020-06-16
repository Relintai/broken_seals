extends Spatial
class_name CharacterSkeketonAttachPoint

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019-2020 Péter Magyar

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

var effects : Dictionary
var timed_effects : Dictionary

var follow : int = -1
export(Array, NodePath) var positions : Array
var follow_node : Spatial = null

func add(effect : PackedScene) -> void:
	if effects.has(effect):
		effects[effect][0] = effects[effect][0] + 1
	else:
		var eff : Node = effect.instance()

		add_child(eff)
		eff.owner = self
		
		var data : Array = [ 1, eff ]
		effects[effect] = data
	
func add_timed(effect : PackedScene, time : float) -> void:
	if timed_effects.has(effect):
		timed_effects[effect][0] = timed_effects[effect][0] + 1
	else:
		var eff : Node = effect.instance()
		
		add_child(eff)
		eff.owner = self
		
		var data : Array = [ 1, eff, time ]
		timed_effects[effect] = data
	
func remove(effect : PackedScene) -> void:
	if effects.has(effect):
		var data : Array = effects[effect]
		
		data[0] = data[0] - 1
		
		if data[0] <= 0:
			data[1].queue_free()
			
			effects.erase(effect)
			

func _process(delta : float) -> void:
	if follow_node != null:
		global_transform = follow_node.global_transform
	
	for k in timed_effects.keys():
		var data : Array = timed_effects[k]
		
		data[2] -= delta
		
		if data[2] <= 0:
			data[1].queue_free()
			
			timed_effects.erase(k)

func set_node_position(index : int) -> void:
	follow = index
	
	if index >= positions.size():
		index = -1
	
	if follow != -1:
		follow_node = get_node(positions[follow]) as Spatial

