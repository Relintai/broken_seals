extends EntityResource
class_name ManaResource

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _init():
	resource_type = EntityEnums.PLAYER_RESOURCE_TYPES_MANA
	
#	should_process = true

#func _ons_stat_changed(stat : Stat):
#	print(stat.get_id())
