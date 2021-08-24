tool
extends Spatial

export(bool) var generate_on_ready : bool = true
export(PropData) var start_room : PropData
export(Array, PropData) var rooms : Array
export(bool) var generate : bool setget set_generate, get_generate

#todo calc aabbs and store in PropData during prop conversion
var room_aabbs : Dictionary
var portal_map : Dictionary
var portals : Array

var current_aabbs : Array

var debug : bool = true

func _enter_tree() -> void:
	if not Engine.editor_hint && generate_on_ready:
		call_deferred("generate")

func set_up_room_data() -> void:
	clear_room_data()
	
	process_prop(start_room)
	
	for r in rooms:
		process_prop(r)
		
	process_portals()
	
func process_prop(room : PropData) -> void:
	if !room:
		return
		
	if !room.is_room:
		return
		
	if room in room_aabbs:
		return
		
	var ps : PoolVector3Array = room.room_bounds
		
	var aabb : AABB = AABB()
		
	for p in ps:
		aabb.expand(p)
			
	room_aabbs[room] = aabb
		
	for i in range(room.props.size()):
		var pe : PropDataEntry = room.props[i]
		
		if pe is PropDataPortal:
			portals.append([pe, room, i])
				
		
func process_portals() -> void:
	for i in range(portals.size()):
		var pe = portals[i]
		
		var portal : PropDataPortal = pe[0]
		var room : PropData = pe[1]
		
		var portal_points : PoolVector2Array = portal.points
		
		if portal in portal_map:
			continue
			
		var map_data : Array = Array()
		
		for j in range(portals.size()):
			if i == j:
				continue
				
			var pp : Array = portals[j]
			var cportal : PropDataPortal = pp[0]
			
			var cportal_points : PoolVector2Array = cportal.points
			
			if (cportal_points.size() != portal_points.size()):
				continue
				
			var eq : bool = true
				
			for k in range(portal_points.size()):
				var p1 : Vector2 = portal_points[k]
				var p2 : Vector2 = cportal_points[k]
				
				if !p1.is_equal_approx(p2):
					eq = false
					break
			
			if !eq:
				continue
				
			var croom : PropData = pp[1]
			var cj : int = pp[2]

			map_data.append([ croom, cportal, cj ])
			
		portal_map[portal] = map_data
		
	#print(portal_map)

func clear_room_data() -> void:
	portal_map.clear()
	portals.clear()
	room_aabbs.clear()
	current_aabbs.clear()

func generate() -> void:
	clear()
	set_up_room_data()
	
	spawn_room(Transform(), start_room)
	

func spawn_room(tf : Transform, room : PropData, level : int = 0, current_portal : PropDataPortal = null) -> void:
	if level > 2:
		return
	
	var sr : PropInstanceMerger = PropInstanceMerger.new()
	sr.prop_data = start_room
	add_child(sr)
	sr.transform = tf
	
	if Engine.editor_hint and debug:
		sr.owner = get_tree().edited_scene_root
		
	var caabb : AABB = room_aabbs[room]
	caabb.position = tf.xform(Vector3())
	current_aabbs.push_back(caabb)
	
	for pe in room.props:
		if pe is PropDataPortal:
			if pe == current_portal:
				continue
			
			var ntf : Transform = pe.transform * tf

			var d : Array = portal_map[pe]
			
			if d.size() == 0:
				continue
				
			randomize()
			
			var new_room_data = d[randi() % d.size()]
			
			#[ croom, cportal, cj ]
			var new_room : PropData = new_room_data[0]
			var new_room_portal : PropDataPortal = new_room_data[1]
			
			#todo figure out the transforms
			var poffset : Vector3 = new_room_portal.transform.xform(Vector3())
			poffset.x += 1
			
			var offsert_ntf : Transform = ntf
			offsert_ntf = offsert_ntf.translated(-poffset)
			
			var ab : AABB = room_aabbs[new_room]
			ab.position = offsert_ntf.xform(Vector3())
			
			
			var can_spawn : bool = true
			for saab in current_aabbs:
				if ab.intersects(saab):
					#todo implement plugs
					can_spawn = false
					break
			
			if can_spawn:
				spawn_room(offsert_ntf, new_room, level + 1, new_room_portal)

func clear() -> void:
	if Engine.editor_hint and debug:
		#don't destroy the user's nodes
		for c in get_children():
			if c.owner == get_tree().edited_scene_root:
				c.queue_free()
	else:
		for c in get_children():
			c.queue_free()

func set_generate(on) -> void:
	if on:
		generate()

func get_generate() -> bool:
	return false
