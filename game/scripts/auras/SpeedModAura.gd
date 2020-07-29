extends "aura_script.gd"

export(bool) var does_stack : bool = true
export(float) var mod_speed : float = 0

func apply_mods(ad : AuraData):
	#slows never stack
	if mod_speed < 0:
		ad.owner.gets_speed().add_non_stacking_mod(mod_speed)
		return
		
	if does_stack:
		ad.owner.gets_speed().add_stacking_mod(mod_speed)
	else:
		ad.owner.gets_speed().add_non_stacking_mod(mod_speed)
	
func deapply_mods(ad : AuraData):
	#slows never stack
	if mod_speed < 0:
		ad.owner.gets_speed().remove_non_stacking_mod(mod_speed)
		return
		
	if does_stack:
		ad.owner.gets_speed().remove_stacking_mod(mod_speed)
	else:
		ad.owner.gets_speed().remove_non_stacking_mod(mod_speed)
