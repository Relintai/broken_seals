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


func _sstart_casting(info : SpellCastInfo) -> void:
	if needs_target and info.target == null:
		return
		
	if info.caster.sis_casting():
		return
	
	if cooldown_global_cooldown_enabled and info.caster.gets_has_global_cooldown() or info.caster.hass_category_cooldown(spell_type) or info.caster.hass_cooldown(id):
		return
	
	if !info.caster.hass_spell_id(id):
		return
		
	var entity_relation_type = info.caster.gets_relation_to(info.target)
	
	var ok = false
	
	if target_relation_type & TARGET_FRIENDLY or target_relation_type & TARGET_SELF:
		if entity_relation_type == EntityEnums.ENTITY_RELATION_TYPE_FRIENDLY or entity_relation_type == EntityEnums.ENTITY_RELATION_TYPE_NEUTRAL:
			ok = true
			
	if target_relation_type & TARGET_ENEMY:
		if entity_relation_type == EntityEnums.ENTITY_RELATION_TYPE_HOSTILE:
			ok = true
			
	if !ok:
		return
	
	if cast_enabled:
		info.caster.sstart_casting(info)
		return

	info.caster.sspell_cast_success(info)

	if info.target:
		info.target.son_cast_finished_target(info)

	handle_cooldown(info)
		
	if projectile != null:
		handle_projectile(info)
	else:
		handle_effect(info)
		
	handle_gcd(info)

func _sfinish_cast(info : SpellCastInfo) -> void:
	info.caster.son_cast_finished(info)
	info.caster.sspell_cast_success(info)
	
	if is_instance_valid(info.target):
		info.target.son_cast_finished_target(info)
	
	if projectile != null:
		handle_projectile(info)
	else:
		handle_effect(info)
		
	handle_cooldown(info)
	handle_gcd(info)
	


func _son_cast_player_moved(info):
	if !cast_can_move_while_casting:
		info.caster.sfail_cast()

func handle_projectile(info : SpellCastInfo):
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
				ad = info.target.gets_aura_with_group_by(info.caster, aura.aura_group)
			else:
				ad = info.target.gets_aura_by(info.caster, aura.get_id())
			
			if ad != null:
				info.target.removes_aura_exact(ad)
			
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
	if cooldown_global_cooldown_enabled and cast_cast_time < 0.01:
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
			
