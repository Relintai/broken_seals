tool
extends Spatial

export(bool) var generate_on_ready : bool = true
export(PropData) var start_room : PropData
export(Array, PropData) var rooms : Array
export(PropData) var plug : PropData
export(bool) var generate : bool setget set_generate, get_generate
export(bool) var spawn_mobs : bool = true

export(int) var min_level : int = 1
export(int) var max_level : int = 2


#todo calc aabbs and store in PropData during prop conversion
var room_hulls : Dictionary
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
		
	if room in room_hulls:
		return
		
	var ps : PoolVector3Array = room.room_bounds
	
	#Convert the bounds to 2d
	#This should probably be done in 3d later
	#I found no simple way to do it for now
	#Will look later
		
	var points : PoolVector2Array = PoolVector2Array()
		
	for p in ps:
		points.push_back(Vector2(p.x, p.z))
	
	points = Geometry.convex_hull_2d(points)
	
	room_hulls[room] = points

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
		

func clear_room_data() -> void:
	portal_map.clear()
	portals.clear()
	room_hulls.clear()
	current_aabbs.clear()

func generate() -> void:
	clear()
	set_up_room_data()
	
	spawn_room(Transform(), start_room)
	
func spawn_room(room_lworld_transform : Transform, room : PropData, level : int = 0, current_portal : PropDataPortal = null) -> void:
	if level > 4:
		var plugi : PropInstanceMerger = PropInstanceMerger.new()
		plugi.prop_data = plug
		plugi.first_lod_distance_squared = 4000
		add_child(plugi)
		plugi.transform = room_lworld_transform
		
		#test_spawn_pos(room_lworld_transform)
		
		return

	var orig_room_lworld_transform : Transform = room_lworld_transform
	
	if current_portal:
		var lworld_curr_portal : Transform = current_portal.transform
		#portal center should be precalculated
		#this will only work with the current portals
		lworld_curr_portal = lworld_curr_portal.translated(Vector3(-0.5, 0, 0))
		lworld_curr_portal.basis = lworld_curr_portal.basis.rotated(Vector3(0, 1, 0), PI)
		room_lworld_transform = room_lworld_transform * lworld_curr_portal.inverse()

	var sr : PropInstanceMerger = PropInstanceMerger.new()
	sr.prop_data = room
	sr.first_lod_distance_squared = 4000
	add_child(sr)
	sr.transform = room_lworld_transform
	
	var cab : PoolVector2Array = room_hulls[room]
	var ctfab : PoolVector2Array = PoolVector2Array()
			
	for a in cab:
		var v : Vector3 = Vector3(a.x, 0, a.y)
		v = room_lworld_transform.xform(v)
		ctfab.push_back(Vector2(v.x, v.z))
		#v.y = 0
		#test_spawn_pos(Transform(Basis(), v))
	
	current_aabbs.push_back(ctfab)
	
	if spawn_mobs && level > 0 && ctfab.size() > 0:
		if randi() % 3 == 0:
			var v2 : Vector2 = ctfab[0]
			
			for i in range(1, ctfab.size()):
				v2 = v2.linear_interpolate(ctfab[i], 0.5)
				
			var gt : Transform = global_transform
			var scale : Vector3 = gt.basis.get_scale()
			v2 *= Vector2(scale.x, scale.z)
				
			ESS.entity_spawner.spawn_mob(0, min_level + (randi() % (max_level - min_level)), Vector3(v2.x, gt.origin.y, v2.y))
	
	#if Engine.editor_hint and debug:
	#	sr.owner = get_tree().edited_scene_root
		
	for pe in room.props:
		if pe is PropDataPortal:
			if pe == current_portal:
				continue
			
			var current_portal_lworld_position : Transform =  room_lworld_transform * pe.transform
			
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

			#middle of the current portal
			var offset_current_portal_lworld_position : Transform = current_portal_lworld_position
			#portal center should be precalculated
			#this will only work with the current portals
			offset_current_portal_lworld_position = offset_current_portal_lworld_position.translated(Vector3(-0.5, 0, 0))
			
			var ab : PoolVector2Array = room_hulls[new_room]
			var tfab : PoolVector2Array = PoolVector2Array()
			
			for a in ab:
				var v : Vector3 = Vector3(a.x, 0, a.y)
				v = offset_current_portal_lworld_position.xform(v)
				tfab.push_back(Vector2(v.x, v.z))
#				v.y = 0
#				test_spawn_pos(Transform(Basis(), v))
			
			#test_spawn_pos(offset_current_portal_lworld_position)
			
			var can_spawn : bool = true
			for saab in current_aabbs:
				var ohull : PoolVector2Array = saab
				
				var poly_int_res : Array = Geometry.intersect_polygons_2d(ohull, tfab)

				if poly_int_res.size() > 0:
					for poly in poly_int_res:
						var indices : PoolIntArray = Geometry.triangulate_polygon(poly)

						for i in range(0, indices.size(), 3):
							var p1 : Vector2 = poly[indices[i]]
							var p2 : Vector2 = poly[indices[i + 1]]
							var p3 : Vector2 = poly[indices[i + 2]]
							
							var pp1 : float = (p1.x * p2.y + p2.x * p3.y + p3.x * p1.y)
							var pp2 : float = (p2.x * p1.y + p3.x * p2.y + p1.x * p3.y)
							var area : float  = 0.5 * (pp1 - pp2)

							if area > 0.2:
								#print(area)
								#print(poly)
								#print(indices)
								
								#for p in poly:
								#	test_spawn_pos(Transform(Basis(), Vector3(p.x, 0, p.y)))
								
								can_spawn = false
								break
								
					if !can_spawn:
						break
						
				if !can_spawn:
					break
				
			if can_spawn:
				spawn_room(offset_current_portal_lworld_position, new_room, level + 1, new_room_portal)
			else:
				var plugi : PropInstanceMerger = PropInstanceMerger.new()
				plugi.prop_data = plug
				add_child(plugi)
				plugi.transform = offset_current_portal_lworld_position
				#test_spawn_pos(offset_current_portal_lworld_position)

func clear() -> void:
	if Engine.editor_hint and debug:
		#don't destroy the user's nodes
		for c in get_children():
			if c.owner == get_tree().edited_scene_root:
				c.queue_free()
	else:
		for c in get_children():
			c.queue_free()

func test_spawn_pos(lworld_position : Transform, color : Color = Color(1, 1, 1)):
	var testspat : ImmediateGeometry = ImmediateGeometry.new()
	add_child(testspat)
	testspat.transform = lworld_position
	testspat.begin(Mesh.PRIMITIVE_LINES)
	testspat.set_color(color)
	testspat.add_vertex(Vector3(0, -0.5, 0))
	testspat.set_color(color)
	testspat.add_vertex(Vector3(0, 0.5, 0))
	testspat.set_color(color)
	testspat.add_vertex(Vector3(-0.5, 0, 0))
	testspat.set_color(color)
	testspat.add_vertex(Vector3(0.5, 0, 0))
	testspat.set_color(color)
	testspat.add_vertex(Vector3(0, 0, -0.5))
	testspat.set_color(color)
	testspat.add_vertex(Vector3(0, 0, 0.5))
	testspat.end()


func set_generate(on) -> void:
	if on:
		generate()

func get_generate() -> bool:
	return false
