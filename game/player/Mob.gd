extends Entity
class_name MobGD

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019-2021 Péter Magyar

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

var dead : bool = false
var death_timer : float = 0
	
func _enter_tree():
	set_process(true)
	
	ai_state = EntityEnums.AI_STATE_PATROL

func _process(delta : float) -> void:
	if dead:
		death_timer += delta
		
		if death_timer > 60:
			queue_free()
		
		return

func sstart_attack(entity : Entity) -> void:
	ai_state = EntityEnums.AI_STATE_ATTACK
	
	starget = entity
	
func _notification_cmouse_enter() -> void:
	if centity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_LOOT:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	elif centity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_NONE:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	elif centity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_TRAIN:
		Input.set_default_cursor_shape(Input.CURSOR_HELP)
	elif centity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_VENDOR:
		Input.set_default_cursor_shape(Input.CURSOR_HELP)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
		
func _notification_cmouse_exit() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func _notification_sdeath():
	if dead:
		return
	
	if starget == null:
		queue_free()
		return
		
	#warning-ignore:unused_variable
	for i in range(aura_gets_count()):
		aura_removes(aura_gets(0))
	
	dead = true
	
	var ldiff : float = slevel - starget.slevel + 10.0
	
	if ldiff < 0:
		ldiff = 0
		
	if ldiff > 15:
		ldiff = 15
		
	ldiff /= 10.0
	
	starget.xp_adds(int(5.0 * slevel * ldiff))
		
	starget = null
	
	if sentity_data.loot_db != null:
		sentity_interaction_type = EntityEnums.ENITIY_INTERACTION_TYPE_LOOT
	else:
		sentity_interaction_type = EntityEnums.ENITIY_INTERACTION_TYPE_NONE
		
	ai_state = EntityEnums.AI_STATE_OFF

	
func set_position(position : Vector3, rotation : Vector3) -> void:
	body_get().set_position(position, rotation)

func _notification_sdamage(what, info):
	if what == SpellEnums.NOTIFICATION_DAMAGE_DAMAGE_DEALT:
		if ai_state != EntityEnums.AI_STATE_ATTACK and info.dealer != self:
			sstart_attack(info.dealer)
			
func _notification_cdamage(what, info):
	if what == SpellEnums.NOTIFICATION_DAMAGE_DAMAGE_DEALT:
		WorldNumbers.damage(body_get().translation, 1.6, info.damage, info.crit)
			
func _notification_cheal(what, info):
	if what == SpellEnums.NOTIFICATION_DAMAGE_DAMAGE_DEALT:
		WorldNumbers.heal(body_get().translation, 1.6, info.heal, info.crit)

func _notification_sxp_gained(value : int) -> void:
	if not ESS.get_resource_db().get_xp_data().can_character_level_up(slevel):
		return
	
	var xpr : int = ESS.get_resource_db().get_xp_data().get_character_xp(slevel);
	
	if xpr <= sxp:
		levelups(1)
		sxp = 0

func _notification_sclass_level_up(value: int):
	._notification_sclass_level_up(value)
	refresh_spells(value)

func _notification_scharacter_level_up(value: int) -> void:
	._notification_scharacter_level_up(value)
	refresh_spells(value)
		
func refresh_spells(value: int):
	if spell_points_gets_free() == 0 and class_talent_points_gets_free() == 0:
		return
	
	var ecd : EntityClassData = sentity_data.entity_class_data
	
	if ecd == null:
		return
	
	var arr : Array = Array()
	
	for i in range(ecd.get_num_spells()):
		arr.append(ecd.get_spell(i))
		
	randomize()
	arr.shuffle()
	
	for _v in range(value):
		for i in range(arr.size()):
			var spell : Spell = arr[i]
			
			if not spell_hass(spell):
				var spnum :int = spell_gets_count()
				
				spell_learn_requestc(spell.id)
				
				if spnum != spell_gets_count():
					break
				
			if sfree_spell_points == 0:
				break
			
			
		if sfree_spell_points == 0:
			break
	

