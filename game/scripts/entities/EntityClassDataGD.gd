extends EntityClassData

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019 Péter Magyar

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

var _data : Dictionary = {
	"target_aura_spells": {},
	"spells": []
}

func _init():
	for i in range(get_num_spells()):
		var spell : Spell = get_spell(i)
		
		if spell.get_num_target_aura_applys() > 0:
			var aura : Aura = spell.get_target_aura_apply(0)
			
			if not _data["target_aura_spells"].has(aura.aura_group):
				_data["target_aura_spells"][aura.aura_group] = []
			
			_data["target_aura_spells"][aura.aura_group].append({ "aura_id": aura.id, "spell_id": spell.id, "rank": spell.rank })
			
			continue
			
		_data["spells"].append(spell.id)
		
	for key in _data["target_aura_spells"]:
		var arr : Array = _data["target_aura_spells"][key]
		
		arr.sort_custom(self, "sort_spells_by_rank")


func _sai_attack(entity):
	var mob : Entity = entity as Entity
	
	var target : Entity = entity.starget
	
	if mob != null and target == null:
		mob.ai_state = EntityEnums.AI_STATE_REGENERATE
		mob.target_movement_direction = Vector2()
		return
	
	var cast : bool = false
	if not entity.gets_has_global_cooldown():
		var taspellsdict : Dictionary = _data["target_aura_spells"]
		
		for taskey in taspellsdict.keys():
			for tas in taspellsdict[taskey]:
				var spell_id : int = tas["spell_id"]
				
				if not entity.hass_spell_id(spell_id):
					continue
			
				if taskey == null:
					if target.sget_aura_by(entity, tas["aura_id"]) == null and not entity.hass_cooldown(spell_id):
						entity.crequest_spell_cast(spell_id)
						cast = true
						break
				else:
					if target.sget_aura_with_group_by(entity, taskey) == null and not entity.hass_cooldown(spell_id):
						entity.crequest_spell_cast(spell_id)
						cast = true
						break
			if cast:
				break
				
		if not cast:
			var sps : Array = _data["spells"]
		
			for spell_id in sps:
				if not entity.hass_spell_id(spell_id):
					continue
			
				if not entity.hass_cooldown(spell_id):
					entity.crequest_spell_cast(spell_id)
					cast = true
					break
	
	
	if entity.sis_casting():
		mob.target_movement_direction = Vector2()
		return
	
	var dir : Vector3 = target.translation - entity.translation
	
	mob.target_movement_direction = Vector2(dir.x, dir.z)

#func _setup_resources(entity):
#	var p : EntityResource = ManaResource.new()
#
#	entity.adds_resource(p)

func sort_spells_by_rank(a, b):
	if a == null or b == null:
		return true
		
	return a["rank"] > b["rank"]
