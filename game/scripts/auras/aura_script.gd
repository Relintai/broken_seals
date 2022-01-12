extends Spell
class_name AuraGD

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

func _aura_sapply(info : AuraApplyInfo) -> void:
#	var add : bool = false
	var ad : AuraData = info.target.aura_gets_by(info.caster, info.aura.id)

	if ad == null:
#		add = true
		ad = AuraData.new()

		setup_aura_data(ad, info);

		for i in range(aura_stat_attribute_get_count()):
			info.target.stat_mod(aura_stat_attribute_get_stat(id), aura_stat_attribute_get_base_mod(i), aura_stat_attribute_get_bonus_mod(i), aura_stat_attribute_get_percent_mod(i))

		if aura_states_add != 0:
			for i in range(EntityEnums.ENTITY_STATE_TYPE_INDEX_MAX):
				var t : int = 1 << i

				if aura_states_add & t != 0:
					info.target.adds_state_ref(i)

		info.target.aura_adds(ad);
		
		apply_mods(ad)
	else:
		ad.remaining_time = aura_time


func _aura_sdeapply(data : AuraData) -> void:
	for i in range(aura_stat_attribute_get_count()):
		data.owner.stat_mod(aura_stat_attribute_get_stat(id), -aura_stat_attribute_get_base_mod(i), -aura_stat_attribute_get_bonus_mod(i), -aura_stat_attribute_get_percent_mod(i))

	if aura_states_add != 0:
		for i in range(EntityEnums.ENTITY_STATE_TYPE_INDEX_MAX):
			var t : int = 1 << i

			if aura_states_add & t != 0:
				data.owner.removes_state_ref(i)
				
	deapply_mods(data)
				
func apply_mods(ad : AuraData):
	pass
	
func deapply_mods(ad : AuraData):
	pass
	
func _con_aura_added(data : AuraData) -> void:
	if data.owner.get_character_skeleton() == null or data.owner.get_character_skeleton().root_attach_point == null:
		return
	
	var bse : SpellEffectVisualBasic = aura_visual_spell_effects as SpellEffectVisualBasic
		
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
	var bse : SpellEffectVisualBasic = aura_visual_spell_effects as SpellEffectVisualBasic
		
	if bse != null:
		if bse.root_aura_effect != null and bse.root_aura_effect_time < 0.00001:
			data.owner.get_character_skeleton().root_attach_point.remove_effect(bse.root_aura_effect)
			
		if bse.torso_aura_effect != null and bse.torso_aura_effect_time < 0.00001:
			data.owner.get_character_skeleton().torso_attach_point.remove_effect(bse.torso_aura_effect)

