extends "aura_script.gd"

export(String) var spell_name : String
export(float) var mod_value : float

func _sapply_passives_damage_deal(data : SpellDamageInfo):
	var spell : Spell = data.spell_source_get()
	
	if !spell:
		return
	
	if spell.get_name() == spell_name:
		data.damage *= (100.0 + mod_value) / 100.0

