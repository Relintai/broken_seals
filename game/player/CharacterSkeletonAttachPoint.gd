extends Spatial
class_name CharacterSkeketonAttachPoint

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

var effects : Dictionary
var timed_effects : Dictionary

func add_effect(effect : PackedScene) -> void:
	if effects.has(effect):
		effects[effect][0] = effects[effect][0] + 1
	else:
		var eff : Node = effect.instance()

		add_child(eff)
		eff.owner = self
		
		var data : Array = [ 1, eff ]
		effects[effect] = data
	
func add_effect_timed(effect : PackedScene, time : float) -> void:
	if timed_effects.has(effect):
		timed_effects[effect][0] = timed_effects[effect][0] + 1
	else:
		var eff : Node = effect.instance()
		
		add_child(eff)
		eff.owner = self
		
		var data : Array = [ 1, eff, time ]
		timed_effects[effect] = data
	
func remove_effect(effect : PackedScene) -> void:
	if effects.has(effect):
		var data : Array = effects[effect]
		
		data[0] = data[0] - 1
		
		if data[0] <= 0:
			data[1].queue_free()
			
			effects.erase(effect)
			

func _process(delta : float) -> void:
	for k in timed_effects.keys():
		var data : Array = timed_effects[k]
		
		data[2] -= delta
		
		if data[2] <= 0:
			data[1].queue_free()
			
			timed_effects.erase(k)
