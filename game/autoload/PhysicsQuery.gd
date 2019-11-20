extends Spatial

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	pass

#func queue_raycast():
#	var space_state : PhysicsDirectSpaceState = get_world().direct_space_state
