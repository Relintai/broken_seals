extends Aura

export(String) var spell_name : String
export(float) var reduction_value : float

func _notification_ccast(what : int, data : AuraData, info: SpellCastInfo):
	if SpellEnums.NOTIFICATION_CAST_STARTED:
		if info.spell.get_name() == spell_name:
			info.cast_time -= reduction_value
