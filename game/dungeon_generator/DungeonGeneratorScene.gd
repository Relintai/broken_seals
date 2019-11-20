extends Navigation2D

export (PackedScene) var room : PackedScene
export (NodePath) var map_path : NodePath

var map

var tile_size : int = 3
var num_rooms : int = 50
var min_size : int = 9
var max_size : int = 20
var hspread : float = 400
var cull : float = 0.5

var path : AStar

func _ready():
	map = get_node(map_path)
	
	randomize()
	make_rooms()
	
func make_rooms():
	for i in range(num_rooms):
		var pos : Vector2 = Vector2(rand_range(-hspread, hspread), 0)
		var r : Node = room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		
		r.make_room(pos, Vector2(w, h)* tile_size)
		$Rooms.add_child(r)
		r.owner = $Rooms
		
	yield(get_tree().create_timer(1.1), 'timeout')
	#cull rooms
	var room_positions : Array = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x, room.position.y, 0))
			
	yield(get_tree(), 'idle_frame')
	
	#generate MST
	path = find_mst(room_positions)
	
	make_map()
	

func a_draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2),
				Color(0, 1, 0), false)
				
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 1, 0), 15, true)
				
func a_process(delta):
	update()
	
func a_input(event):
	if event.is_action_pressed('ui_select'):
		for n in $Rooms.get_children():
			n.queue_free()
		
		path = null
		
		make_rooms()
		
	if event.is_action_pressed('ui_focus_next'):
		make_map()
			
func find_mst(nodes : Array) -> AStar:
	#Prim's algorithm
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF
		var min_p = null
		var p = null
		
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			
			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
	
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
	
	return path
	
func make_map() -> void:
	map.clear()
	
	#for x in range(0, 200):
	#	for y in range(0, 200):
	#		tile_map.set_cell(x, y, 0)
	
	#fill tilemap with walls
	#var full_rect = Rect2()
	#carve the rooms
	var corridors = []
	var mob_count = 0
	var player_spawned = false
	for room in $Rooms.get_children():
		var top_left = room.position.floor()
		var bottom_right = (top_left + room.size).floor()
		
		for x in range(top_left.x, bottom_right.x):
			for z in range(top_left.y, bottom_right.y):
				for y in range(0, 2):
					map.draw_voxel_data_point(Vector3(x, y, z), 0, randi() % 255)
					
	
		#connection
		#var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		
		#for conn in path.get_point_connections(p):
		#	if not conn in corridors:
		#		var start = Vector2(path.get_point_position(p).x, path.get_point_position(p).y).ceil()
		#		var end = Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y).ceil()
				
		#		carve_path(start, end)
				
		#corridors.append(p)
		
		var pos : Vector2 = room.position + (room.size / 2).floor()
		if not player_spawned:
			#Entities.spawn_player(1, Vector3(pos.x, 2, pos.y))
			player_spawned = true
		else:
			if mob_count < 20:
				Entities.spawn_mob(1, randi() % 3, Vector3(pos.x, 2, pos.y))
				mob_count += 1
			
	map.build()
	
func carve_path(pos1, pos2):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	
	if x_diff == 0:
		x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0:
		y_diff = pow(-1.0, randi() % 2)
		
	var x_y = pos1
	var y_x = pos2
	
	#if (randi() % 2) > 0:
	#	x_y = pos2
	#	y_x = pos1
		
	for x in range(pos1.x, pos2.x, x_diff):
		for n in range(5):
			var tile = 1
			
			if n == 0 or n == 4:
				tile = 0
			
		#	if tile_map.get_cell(x, x_y.y + (n * y_diff)) != 1:
		#		tile_map.set_cell(x, x_y.y + (n * y_diff), tile)
			
	for y in range(pos1.y, pos2.y, y_diff):
		for n in range(5):
			var tile = 1
			
			if n == 0 or n == 4:
				tile = 0
			
		#	if tile_map.get_cell(y_x.x + (n * x_diff), y) != 1:
			#	tile_map.set_cell(y_x.x + (n * x_diff), y, tile)
		
	
		
		
	
