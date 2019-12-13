extends Spell
class_name SpellGD

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _sstart_casting(info : SpellCastInfo) -> void:
	if info.caster.sis_casting():
		return
	
	if info.spell.cooldown_global_cooldown and info.caster.gets_has_global_cooldown() or info.caster.hass_category_cooldown(spell_type) or info.caster.hass_cooldown(id):
		return
	
	if !info.caster.hass_spell(self):
		return
	
	if cast:
		info.caster.sstart_casting(info)
		return

	info.caster.sspell_cast_success(info)

	if info.target:
		info.target.son_cast_finished_target(info)

	handle_cooldown(info)
		
	if projectile != null:
		fire_projectile(info)
	else:
		handle_effect(info)
		
	handle_gcd(info)

func _sfinish_cast(info : SpellCastInfo) -> void:
	info.caster.son_cast_finished(info)
	info.caster.sspell_cast_success(info)
	
	if is_instance_valid(info.target):
		info.target.son_cast_finished_target(info)
	
	if projectile != null:
		fire_projectile(info)
	else:
		handle_effect(info)
		
	handle_cooldown(info)

func _son_cast_player_moved(info):
	if !cast_can_move_while_casting:
		info.caster.sfail_cast()

func fire_projectile(info : SpellCastInfo):
	pass
#	if projectile_type == SPELL_PROJECTILE_TYPE_FOLLOW:
#		var sp : WorldSpellGD = WorldSpellGD.new()
#
#		info.get_caster().get_parent().add_child(sp)
#		sp.owner = info.get_caster().get_parent()
#
#		sp.launch(info, projectile, projectile_speed)

func _son_spell_hit(info):
	handle_effect(info)

func handle_effect(info : SpellCastInfo) -> void:
	if target_type == SPELL_TARGET_TYPE_TARGET:
		if info.target == null:
			return
			
		var ok : bool = false
		
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
		
	if damage and info.target:
		var sdi : SpellDamageInfo = SpellDamageInfo.new()
		
		sdi.damage_source = self
		sdi.dealer = info.caster
		sdi.receiver = info.target
		
		handle_spell_damage(sdi)
		
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
				ad = info.target.sget_aura_with_group_by(info.caster, aura.aura_group)
			else:
				ad = info.target.sget_aura_by(info.caster, aura.get_id())
			
			if ad != null:
				info.target.sremove_aura_exact(ad)
			
			var ainfo : AuraApplyInfo = AuraApplyInfo.new()
		
			ainfo.caster = info.caster
			ainfo.target = info.target
			ainfo.spell_scale = 1
			ainfo.aura = aura

			aura.sapply(ainfo)
		
		
		
func handle_cooldown(info : SpellCastInfo) -> void:
	if cooldown_cooldown > 0:
		info.caster.adds_cooldown(id, cooldown_cooldown)
		
func handle_gcd(info : SpellCastInfo) -> void:
	if cooldown_global_cooldown and cast_cast_time < 0.01:
		info.caster.sstart_global_cooldown(info.caster.get_gcd().scurrent)

func add_spell_cast_effect(info : SpellCastInfo) -> void:
	var basic_spell_effect : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if basic_spell_effect != null:
		if basic_spell_effect.spell_cast_effect_left_hand != null:
			info.caster.get_character_skeleton().left_hand_attach_point.add_effect(basic_spell_effect.spell_cast_effect_left_hand)
		
		if basic_spell_effect.spell_cast_effect_right_hand != null:
			info.caster.get_character_skeleton().right_hand_attach_point.add_effect(basic_spell_effect.spell_cast_effect_right_hand)
		
func remove_spell_cast_effect(info : SpellCastInfo) -> void:
	var basic_spell_effect : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if basic_spell_effect != null:
		if basic_spell_effect.spell_cast_effect_left_hand != null:
			info.caster.get_character_skeleton().left_hand_attach_point.remove_effect(basic_spell_effect.spell_cast_effect_left_hand)
		
		if basic_spell_effect.spell_cast_effect_right_hand != null:
			info.caster.get_character_skeleton().right_hand_attach_point.remove_effect(basic_spell_effect.spell_cast_effect_right_hand)
		
func _con_spell_cast_started(info):
	add_spell_cast_effect(info)

func _con_spell_cast_failed(info):
	remove_spell_cast_effect(info)
	
func _con_spell_cast_interrupted(info):
	remove_spell_cast_effect(info)
	
func _con_spell_cast_success(info):
	remove_spell_cast_effect(info)
	
	if not is_instance_valid(info.target):
		return
	
	var bse : SpellEffectVisualBasic = visual_spell_effects as SpellEffectVisualBasic
		
	if bse != null:
		if bse.torso_spell_cast_finish_effect != null:
			info.target.get_character_skeleton().torso_attach_point.add_effect_timed(bse.torso_spell_cast_finish_effect, bse.torso_spell_cast_finish_effect_time)

		if bse.root_spell_cast_finish_effect != null:
			info.target.get_character_skeleton().root_attach_point.add_effect_timed(bse.root_spell_cast_finish_effect, bse.root_spell_cast_finish_effect_time)
			
