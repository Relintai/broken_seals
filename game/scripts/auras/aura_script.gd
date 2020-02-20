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
	
	damage_info.damage = damage_min + (randi() % (damage_max - damage_min))
	damage_info.damage *= damage_info.dealer.scharacter_level / float(EntityEnums.MAX_CHARACTER_LEVEL)
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
	var ad : AuraData = info.target.sget_aura_by(info.caster, info.aura.id)

	if ad == null:
#		add = true
		ad = AuraData.new()
		
		setup_aura_data(ad, info);

		for i in range(get_aura_stat_attribute_count()):
			var stat_attribute : AuraStatAttribute = get_aura_stat_attribute(i)
			var stat : Stat = info.target.get_stat_enum(stat_attribute.stat)
			stat.add_modifier(id, stat_attribute.base_mod, stat_attribute.bonus_mod, stat_attribute.percent_mod)

		if states_add != 0:
			for i in range(EntityEnums.ENTITY_STATE_TYPE_INDEX_MAX):
				var t : int = 1 << i
				
				if states_add & t != 0:
					info.target.sadd_state_ref(i)
				

		info.target.sadd_aura(ad);
	else:
		ad.remaining_time = time
		
	
func _sdeapply(data : AuraData) -> void:
	for i in range(get_aura_stat_attribute_count()):
		var stat_attribute : AuraStatAttribute = get_aura_stat_attribute(i)
		
		var stat : Stat = data.owner.get_stat_enum(stat_attribute.stat)
		
		stat.remove_modifier(id)
		
	if states_add != 0:
		for i in range(EntityEnums.ENTITY_STATE_TYPE_INDEX_MAX):
			var t : int = 1 << i
				
			if states_add & t != 0:
				data.owner.sremove_state_ref(i)

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

