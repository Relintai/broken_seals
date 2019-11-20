extends Entity

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("con_damage_taken", self, "c_on_damage_taken")
	connect("son_damage_taken", self, "s_on_damage_taken")
	#c_on_damage_taken( Entity Entity, DamagePipelineData damage_pipeline_data )

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func c_on_damage_taken(entity, dpd):
	print("c " + str(dpd.damage))
	print("ch " + str(get_health().ccurrent) + "/" + str(get_health().cmax))
	pass

func s_on_damage_taken(entity, dpd):
	print("s " + str(dpd.damage))
	#print("ch " + str(get_health().scurrent) + "/" + str(get_health().smax))
	pass
