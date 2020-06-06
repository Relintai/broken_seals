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


func _handle_aura_damage(aura_data : AuraData, damage_info : SpellDamageInfo) -> void:
	randomize()
	
	if  damage_info.dealer == null:
		printerr("_handle_aura_damage: damage_info.dealer is null! ")
		return
	
	damage_info.damage = damage_min + (randi() % (damage_max - damage_min))
	
	if scale_with_level:
		damage_info.damage *= int(float(damage_info.dealer.scharacter_level) / float(EntityEnums.MAX_CHARACTER_LEVEL))

	damage_info.damage_source_type = aura_data.aura.damage_type
	
	if (is_instance_valid(damage_info.dealer)):
		damage_info.dealer.sdeal_damage_to(damage_info)
	
func _handle_aura_heal(aura_data : AuraData, shi : SpellHealInfo) -> void:
	randomize()
	
	shi.heal = heal_min + (randi() % (heal_max - heal_min))
	shi.damage *= shi.dealer.scharacter_level / float(EntityEnums.MAX_CHARACTER_LEVEL)
	shi.heal_source_type = aura_data.aura.aura_type
	
	shi.dealer.sdeal_heal_to(shi)

func _sapply(info : AuraApplyInfo) -> void:
#	var add : bool = false
	var ad : AuraData = info.target.aura_gets_by(info.caster, info.aura.id)

	if ad == null:
#		add = true
		ad = AuraData.new()
		
		setup_aura_data(ad, info);

		for i in range(stat_attribute_get_count()):
			info.target.stat_mod(id, stat_attribute_get_base_mod(i), stat_attribute_get_bonus_mod(i), stat_attribute_get_percent_mod(i))

		if states_add != 0:
			for i in range(EntityEnums.ENTITY_STATE_TYPE_INDEX_MAX):
				var t : int = 1 << i
				
				if states_add & t != 0:
					info.target.adds_state_ref(i)
				

		info.target.aura_adds(ad);
	else:
		ad.remaining_time = time
		
	
func _sdeapply(data : AuraData) -> void:
	for i in range(stat_attribute_get_count()):
		data.owner.stat_mod(id, stat_attribute_get_base_mod(i), stat_attribute_get_bonus_mod(i), stat_attribute_get_percent_mod(i))

	if states_add != 0:
		for i in range(EntityEnums.ENTITY_STATE_TYPE_INDEX_MAX):
			var t : int = 1 << i
				
			if states_add & t != 0:
				data.owner.removes_state_ref(i)

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

