extends Resource
class_name PlayerMaster

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = "Testname", selected_class = 1 }
var sid : int

var player : Entity 

func _init():
	pass
	
func _notification(what : int) -> void:
	if what == NOTIFICATION_PREDELETE:
		#save
		#cleanup
		pass

