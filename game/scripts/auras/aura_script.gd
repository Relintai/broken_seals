extends Aura
class_name AuraGD

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

func _con_aura_added(data : AuraData) -> void:
	if data.owner.get_character_skeleton() == null or data.owner.get_character_skeleton().root_attach_point == null:
		return
	
	var bse : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if bse != null:
		if bse.root_aura_effect != null:
			if bse.root_aura_effect_time < 0.00001:
				data.owner.get_character_skeleton().root_attach_point.add_effect(bse.root_aura_effect)
			else:
				data.owner.get_character_skeleton().root_attach_point.add_effect_timed(bse.root_aura_effect, bse.root_aura_effect_time)

		if bse.torso_aura_effect != null:
			if bse.torso_aura_effect_time < 0.00001:
				data.owner.get_character_skeleton().torso_attach_point.add_effect(bse.torso_aura_effect)
			else:
				data.owner.get_character_skeleton().torso_attach_point.add_effect_timed(bse.torso_aura_effect, bse.torso_aura_effect_time)

func _con_aura_removed(data : AuraData) -> void:
	var bse : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if bse != null:
		if bse.root_aura_effect != null and bse.root_aura_effect_time < 0.00001:
			data.owner.get_character_skeleton().root_attach_point.remove_effect(bse.root_aura_effect)
			
		if bse.torso_aura_effect != null and bse.torso_aura_effect_time < 0.00001:
			data.owner.get_character_skeleton().torso_attach_point.remove_effect(bse.torso_aura_effect)

