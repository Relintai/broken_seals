extends Entity

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

var _timer : float = randf() * 2.0

var _query : PhysicsShapeQueryParameters
var _shape : SphereShape

func _ready():
	_shape = SphereShape.new()
	_shape.radius = 50

	_query = PhysicsShapeQueryParameters.new()
	_query.collision_mask = 2
	_query.exclude = [ self ]
	_query.shape_rid = _shape.get_rid()
	
	set_physics_process(true)
	
func _physics_process(delta):
#	if (multiplayer.has_network_peer() and multiplayer.is_network_server()) or not multiplayer.has_network_peer():
	if multiplayer.has_network_peer() and multiplayer.is_network_server():
		_timer += delta
		
		if _timer > 3:
			_timer -= 3
			
			update_visibility()
		
func update_visibility() -> void:
	_query.transform = Transform(Basis(), translation)
	var res : Array = get_world().direct_space_state.intersect_shape(_query)
	
	#warning-ignore:unassigned_variable
	var currenty_sees : Array = Array()
		
	for collision in res:
		var collider = collision["collider"]
		
		if collider is Entity and not currenty_sees.has(collider):
			currenty_sees.append(collider)
	
	
	#warning-ignore:unassigned_variable
	var used_to_see : Array = Array()
	
	for i in range(gets_sees_count()):
		var ent : Entity = gets_sees(i)
		
		used_to_see.append(ent)
		
	
	#warning-ignore:unassigned_variable
	var currenty_sees_filtered : Array = Array()
	
	for e in currenty_sees:
		currenty_sees_filtered.append(e)
	
	for e in currenty_sees:
		if used_to_see.has(e):
			used_to_see.erase(e)
			currenty_sees_filtered.erase(e)
	
	for e in used_to_see:
		var ent : Entity = e as Entity
		
		if self.get_network_master() != 1:
			Entities.despawn_for(self, ent)
		
		removes_sees(ent)

	for e in currenty_sees_filtered:
		var ent : Entity = e as Entity
		
		if self.get_network_master() != 1:
			Entities.spawn_for(self, ent)
		
		adds_sees(ent)




