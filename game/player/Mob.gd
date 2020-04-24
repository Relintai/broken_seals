extends Entity

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

var dead : bool = false
var death_timer : float = 0

func _ready() -> void:
	ai_state = EntityEnums.AI_STATE_PATROL
	
func _enter_tree():
	set_process(true)

func _process(delta : float) -> void:
	if dead:
		death_timer += delta
		
		if death_timer > 60:
			queue_free()
		
		return

func sstart_attack(entity : Entity) -> void:
	ai_state = EntityEnums.AI_STATE_ATTACK
	
	starget = entity
	
func _onc_mouse_enter() -> void:
	if centity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_LOOT:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
		
func _onc_mouse_exit() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func _son_death():
	if dead:
		return
	
	if starget == null:
		queue_free()
		return
		
	#warning-ignore:unused_variable
	for i in range(gets_aura_count()):
		removes_aura(gets_aura(0))
	
	dead = true
	
	var ldiff : float = scharacter_level - starget.scharacter_level + 10.0
	
	if ldiff < 0:
		ldiff = 0
		
	if ldiff > 15:
		ldiff = 15
		
	ldiff /= 10.0
	
	starget.adds_xp(int(5.0 * scharacter_level * ldiff))
		
	starget = null
	
	sentity_interaction_type = EntityEnums.ENITIY_INTERACTION_TYPE_LOOT
	ai_state = EntityEnums.AI_STATE_OFF

	
func set_position(position : Vector3, rotation : Vector3) -> void:
	get_body().set_position(position, rotation)

func _son_damage_dealt(data):
	if ai_state != EntityEnums.AI_STATE_ATTACK and data.dealer != self:
		sstart_attack(data.dealer)

func _con_damage_dealt(info : SpellDamageInfo) -> void:
#	if info.dealer == 
	WorldNumbers.damage(get_body().translation, 1.6, info.damage, info.crit)

func _con_heal_dealt(info : SpellHealInfo) -> void:
	WorldNumbers.heal(get_body().translation, 1.6, info.heal, info.crit)
		
func _son_xp_gained(value : int) -> void:
	if not ESS.get_resource_db().get_xp_data().can_character_level_up(gets_character_level()):
		return
	
	var xpr : int = ESS.get_resource_db().get_xp_data().get_character_xp(gets_character_level());
	
	if xpr <= scharacter_xp:
		scharacter_levelup(1)
		scharacter_xp = 0

func _son_class_level_up(value: int):
	._son_class_level_up(value)
	refresh_spells(value)

func _son_character_level_up(value: int) -> void:
	._son_character_level_up(value)
	refresh_spells(value)
		
func refresh_spells(value: int):
	if gets_free_spell_points() == 0 and gets_free_talent_points() == 0:
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
			
			if not hass_spell(spell):
				var spnum :int = gets_spell_count()
				
				crequest_spell_learn(spell.id)
				
				if spnum != gets_spell_count():
					break
				
			if sfree_spell_points == 0:
				break
			
			
		if sfree_spell_points == 0:
			break
	

