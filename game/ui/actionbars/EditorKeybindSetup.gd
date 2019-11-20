tool
extends Node

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(bool) var create = false setget createf
export(bool) var delete = false setget deletef


func createf(value : bool) -> void:
	if not value:
		return
	
	for i in range(6):
		for j in range(12):
			var actionstr : String = "input/actionbar_" + str(i) + "_" + str(j)
			
			var action : Dictionary = Dictionary()
			action["events"] = Array()
			action["deadzone"] = 0.5

			ProjectSettings.set(name, actionstr)
			ProjectSettings.save()

	
func deletef(value : bool) -> void:
	if not value:
		return
		
	for i in range(6):
		for j in range(12):
			var action : String = "input/actionbar_" + str(i) + "_" + str(j)
			
			ProjectSettings.clear(action)
			ProjectSettings.save()
