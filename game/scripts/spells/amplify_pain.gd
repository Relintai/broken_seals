extends SpellGD

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _sfinish_cast(info : SpellCastInfo) -> void:
	var target : Entity = info.target
	
	if not is_instance_valid(target):
		return
	
	for i in range(target.sget_aura_count()):
		
		var ad : AuraData = target.sget_aura(i)
		
		if ad.caster == info.caster:
			var aura : Aura = ad.aura
			
			if aura.aura_type & SpellEnums.AURA_TYPE_MAGIC != 0:
				ad.time_since_last_tick += ad.tick
