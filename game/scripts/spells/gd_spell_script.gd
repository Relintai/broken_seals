extends Spell
class_name SpellGD

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


func _cast_starts(info : SpellCastInfo) -> void:
	if needs_target and info.target == null:
		return
		
	if info.caster.cast_is_castings():
		return
	
	if cooldown_global_cooldown_enabled and info.caster.gcd_hass() or info.caster.category_cooldown_hass(spell_type) or info.caster.cooldown_hass(id):
		return
	
	if !info.caster.spell_hass_id(id):
		return
		
	var entity_relation_type = info.caster.gets_relation_to(info.target)
	
	var ok = false
	
	if target_relation_type & TARGET_FRIENDLY or target_relation_type & TARGET_SELF:
		if entity_relation_type == EntityEnums.ENTITY_RELATION_TYPE_FRIENDLY or entity_relation_type == EntityEnums.ENTITY_RELATION_TYPE_NEUTRAL:
			ok = true
		else:
			if entity_relation_type == EntityEnums.ENTITY_RELATION_TYPE_HOSTILE:
				info.target = info.caster
				ok = true
			
	if target_relation_type & TARGET_ENEMY:
		if entity_relation_type == EntityEnums.ENTITY_RELATION_TYPE_HOSTILE:
			ok = true
			
	if !ok:
		return
		
	if range_enabled:
		if info.caster != info.target:
			var c : Vector3 = info.caster.get_body().transform.origin
			var t : Vector3 = info.target.get_body().transform.origin
			
			if (c - t).length() > range_range:
				return
	
	if resource_cost != null and resource_cost.entity_resource_data != null:
		var r : EntityResource = info.caster.resource_gets_id(resource_cost.entity_resource_data.id)

		if r == null:
			return

		if r.current_value < resource_cost.cost:
			return
	
	if cast_enabled:
		info.caster.cast_starts(info)
		return
		
	if resource_cost != null and resource_cost.entity_resource_data != null:
		var r : EntityResource = info.caster.resource_gets_id(resource_cost.entity_resource_data.id)

		r.current_value -= resource_cost.cost

	info.caster.notification_scast(SpellEnums.NOTIFICATION_CAST_FINISHED, info)
	info.caster.notification_scast(SpellEnums.NOTIFICATION_CAST_SUCCESS, info)
	
	info.caster.notification_ccast(SpellEnums.NOTIFICATION_CAST_FINISHED, info)

	if info.target:
		info.target.notification_scast(SpellEnums.NOTIFICATION_CAST_FINISHED_TARGET, info)

	handle_cooldown(info)
		
#	if projectile != null:
#		handle_projectile(info)
#	else:
	handle_effect(info)
		
	handle_gcd(info)

func _cast_finishs(info : SpellCastInfo) -> void:
	if resource_cost != null and resource_cost.entity_resource_data != null:
		var r : EntityResource = info.caster.resource_gets_id(resource_cost.entity_resource_data.id)

		if r.current_value < resource_cost.cost:
			info.caster.son_cast_failed(info)
			return

		r.current_value -= resource_cost.cost

	info.caster.notification_scast(SpellEnums.NOTIFICATION_CAST_FINISHED, info)
	info.caster.notification_scast(SpellEnums.NOTIFICATION_CAST_SUCCESS, info)
	
	info.caster.notification_ccast(SpellEnums.NOTIFICATION_CAST_FINISHED, info)
	
	if is_instance_valid(info.target):
		info.target.notification_scast(SpellEnums.NOTIFICATION_CAST_FINISHED_TARGET, info)

	if projectile_scene != null:
		handle_projectile(info)
	else:
		handle_effect(info)
		
	handle_cooldown(info)
	handle_gcd(info)
	
	
func _son_cast_player_moved(info):
	if !cast_can_move_while_casting:
		info.caster.cast_fails()


func handle_effect(info : SpellCastInfo) -> void:
	if target_type == SPELL_TARGET_TYPE_TARGET:
		if info.target == null:
			return
			
#		var ok : bool = false
		
#		if (target_relation_type & TARGET_SELF):
#			ok = true
			
#		if not ok and (target_relation_type & TARGET_ENEMY and info.target is Entity):
#			ok = true
#
#		if not ok and (target_relation_type & TARGET_FRIENDLY and info.target is Player):
#			ok = true
			
#		if not ok:
#			return
			
	elif target_type == SPELL_TARGET_TYPE_SELF:
		info.target = info.caster
		
	if damage_enabled and info.target:
		var sdi : SpellDamageInfo = SpellDamageInfo.new()
		
		sdi.damage_source = self
		sdi.dealer = info.caster
		sdi.receiver = info.target
		
		handle_spell_damage(sdi)
		
	if heal_enabled and info.target:
		var shi : SpellHealInfo = SpellHealInfo.new()
		
		shi.heal_source = self
		shi.dealer = info.caster
		shi.receiver = info.target
		
		handle_spell_heal(shi)
		
	for aura in caster_aura_applys:
		var ainfo : AuraApplyInfo = AuraApplyInfo.new()
		
		ainfo.caster = info.caster
		ainfo.target = info.caster
		ainfo.spell_scale = 1
		ainfo.aura = aura

		aura.sapply(ainfo)
		
	if info.target != null:
		for aura in target_aura_applys:
			var ad : AuraData = null
			
			if aura.aura_group != null:
				ad = info.target.aura_gets_with_group_by(info.caster, aura.aura_group)
			else:
				ad = info.target.aura_gets_by(info.caster, aura.get_id())
			
			if ad != null:
				info.target.aura_removes_exact(ad)
			
			var ainfo : AuraApplyInfo = AuraApplyInfo.new()
		
			ainfo.caster = info.caster
			ainfo.target = info.target
			ainfo.spell_scale = 1
			ainfo.aura = aura

			aura.sapply(ainfo)
		
		
		
func handle_cooldown(info : SpellCastInfo) -> void:
	if cooldown_cooldown > 0:
		info.caster.cooldown_adds(id, cooldown_cooldown)
		
func handle_gcd(info : SpellCastInfo) -> void:
	if cooldown_global_cooldown_enabled and cast_cast_time < 0.01:
		info.caster.gcd_starts(info.caster.get_gcd().scurrent)

func add_spell_cast_effect(info : SpellCastInfo) -> void:
	var basic_spell_effect : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if basic_spell_effect != null:
		if basic_spell_effect.spell_cast_effect_left_hand != null:
			info.caster.get_character_skeleton().common_attach_point_add(EntityEnums.COMMON_SKELETON_POINT_LEFT_HAND, basic_spell_effect.spell_cast_effect_left_hand)
		
		if basic_spell_effect.spell_cast_effect_right_hand != null:
			info.caster.get_character_skeleton().common_attach_point_add(EntityEnums.COMMON_SKELETON_POINT_RIGHT_HAND, basic_spell_effect.spell_cast_effect_right_hand)
		
func remove_spell_cast_effect(info : SpellCastInfo) -> void:
	var basic_spell_effect : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if basic_spell_effect != null:
		if basic_spell_effect.spell_cast_effect_left_hand != null:
			info.caster.get_character_skeleton().common_attach_point_remove(EntityEnums.COMMON_SKELETON_POINT_LEFT_HAND, basic_spell_effect.spell_cast_effect_left_hand)
		
		if basic_spell_effect.spell_cast_effect_right_hand != null:
			info.caster.get_character_skeleton().common_attach_point_remove(EntityEnums.COMMON_SKELETON_POINT_RIGHT_HAND, basic_spell_effect.spell_cast_effect_right_hand)
		
func _notification_ccast(what, info):
	if what == SpellEnums.NOTIFICATION_CAST_STARTED:
		add_spell_cast_effect(info)
	elif what == SpellEnums.NOTIFICATION_CAST_FAILED:
		remove_spell_cast_effect(info)
	elif what == SpellEnums.NOTIFICATION_CAST_FINISHED:
		remove_spell_cast_effect(info)
	elif what == SpellEnums.NOTIFICATION_CAST_INTERRUPTED:
		remove_spell_cast_effect(info)
	elif what == SpellEnums.NOTIFICATION_CAST_SUCCESS:
		remove_spell_cast_effect(info)

		if not is_instance_valid(info.target):
			return
		
		var bse : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
			
		if bse != null:
			if bse.torso_spell_cast_finish_effect != null:
				info.target.get_character_skeleton().common_attach_point_add_timed(EntityEnums.COMMON_SKELETON_POINT_TORSO, bse.torso_spell_cast_finish_effect_time)

			if bse.root_spell_cast_finish_effect != null:
				info.target.get_character_skeleton().common_attach_point_add_timed(EntityEnums.COMMON_SKELETON_POINT_ROOT, bse.root_spell_cast_finish_effect_time)


func _son_spell_hit(info):
	handle_effect(info)
