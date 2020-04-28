extends Entity

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019-2020 Péter Magyar

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
	_query.transform = Transform(Basis(), get_body().translation)
	var res : Array = get_body().get_world().direct_space_state.intersect_shape(_query)
	
	#warning-ignore:unassigned_variable
	var currenty_sees : Array = Array()
		
	for collision in res:
		var collider = collision["collider"]
		
		if collider is Entity and not currenty_sees.has(collider):
			currenty_sees.append(collider)
	
	
	#warning-ignore:unassigned_variable
	var used_to_see : Array = Array()
	
	for i in range(sees_gets_count()):
		var ent : Entity = sees_gets(i)
		
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
			ESS.entity_spawner.despawn_for(self, ent)
		
		sees_removes(ent)

	for e in currenty_sees_filtered:
		var ent : Entity = e as Entity
		
		if self.get_network_master() != 1:
			ESS.entity_spawner.spawn_for(self, ent)
		
		sees_adds(ent)




