tool
extends Dungeon

# Copyright (c) 2019-2021 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export(int) var level_room_count : int = 9
export(int) var min_room_dimension : int = 5
export(int) var max_room_dimension : int = 8
export(int) var enemy_count : int = 14

export(bool) var spawn_mobs : bool = false

export(MeshDataResource) var dung_floor : MeshDataResource = null
export(MeshDataResource) var dung_ceiling : MeshDataResource = null
export(MeshDataResource) var dung_wall_xp : MeshDataResource = null
export(MeshDataResource) var dung_wall_xn : MeshDataResource = null
export(MeshDataResource) var dung_wall_zp : MeshDataResource = null
export(MeshDataResource) var dung_wall_zn : MeshDataResource = null

export(Texture) var wall_texture : Texture
export(Texture) var floor_texture : Texture
export(Texture) var ceiling_texture : Texture

export(MeshDataResource) var dung_entrance_mdr : MeshDataResource = null
export(PackedScene) var dung_entrance_scene : PackedScene = null

var map : Array = []
var rooms : Array = []
var enemies : Array = []
#var nav_graph : AStar2D
var entrance_position : Transform = Transform()
var inner_entrance_position : Vector3 = Vector3()
var player_inner_entrance_position_x : int = 0
var player_inner_entrance_position_z : int = 0

var entrance_position_data_space : Vector3 = Vector3()
var next_level_teleporter_position_data_space : Vector3 = Vector3()

var enemy_data : Array = []

# in binary: WallXP = 00001, WallXN = 0010, WallZP = 0100, WallZN = 1000
enum NeighbourCaseCodeFlags { WallXP = 1, WallXN = 2, WallZP = 4, WallZN = 8 }
enum Tile { Wall, Floor, Door, Empty }

func _instance(p_seed, p_instance):
	._instance(p_seed, p_instance)
		
	p_instance.level_room_count = level_room_count
	p_instance.min_room_dimension = min_room_dimension
	p_instance.max_room_dimension = max_room_dimension
	p_instance.enemy_count = enemy_count
	
	p_instance.spawn_mobs = spawn_mobs
	
	p_instance.dung_floor = dung_floor
	p_instance.dung_ceiling = dung_ceiling
	p_instance.dung_wall_xp = dung_wall_xp
	p_instance.dung_wall_xn = dung_wall_xn
	p_instance.dung_wall_zp = dung_wall_zp
	p_instance.dung_wall_zn = dung_wall_zn
	
	p_instance.wall_texture = wall_texture
	p_instance.floor_texture = floor_texture
	p_instance.ceiling_texture = ceiling_texture
	
	p_instance.dung_entrance_mdr = dung_entrance_mdr
	p_instance.dung_entrance_scene = dung_entrance_scene
	
	return p_instance

func _setup():
	if sizex == 0 || sizey == 0 || sizez == 0:
		print("Dungeon size is 0!")
		return
	
#	entrance_position.origin = Vector3(7, 5, 7)
	
#	if data.get_dungeon_start_room_data_count() == 0:
#		return
#
#	var drd : DungeonRoom = data.get_dungeon_start_room_data(0)
#
#	var dung : DungeonRoom = drd.instance()
#
#	dung.posx = posx
#	dung.posy = posy
#	dung.posz = posz
#	dung.current_seed = current_seed
#	dung.data = drd
#	dung.setup()
#
#	add_dungeon_start_room(dung)

	build()

func _setup_terra_library(library):
	._setup_terra_library(library)
	
	if library is TerramanLibraryMerger:
		library.get_prop_packer().add_texture(wall_texture)
		library.get_prop_packer().add_texture(floor_texture)
		library.get_prop_packer().add_texture(ceiling_texture)

func _generate_voxel_chunk(chunk, spawn_mobs):
	var aabb : AABB = AABB(Vector3(posx - 1, posy - 1, posz - 1) * Vector3(chunk.voxel_scale, chunk.voxel_scale, chunk.voxel_scale), Vector3(sizex + 2, sizey + 2, sizez + 2) * Vector3(chunk.voxel_scale, chunk.voxel_scale, chunk.voxel_scale))
	var chunk_aabb : AABB = AABB(chunk.get_position() * Vector3(chunk.size_x, chunk.size_y, chunk.size_z) * Vector3(chunk.voxel_scale, chunk.voxel_scale, chunk.voxel_scale), Vector3(chunk.size_x, chunk.size_y, chunk.size_z) * Vector3(chunk.voxel_scale, chunk.voxel_scale, chunk.voxel_scale))
	
	if dung_entrance_scene && chunk_aabb.has_point(entrance_position.origin):
		inner_entrance_position = Vector3(player_inner_entrance_position_x * chunk.voxel_scale, (posy + 4) * chunk.voxel_scale + 0.3, player_inner_entrance_position_z * chunk.voxel_scale)
		call_deferred("spawn_teleporter_scene", dung_entrance_scene, entrance_position, chunk, inner_entrance_position)
	
	if !aabb.intersects(chunk_aabb):
		return

	var px : int = chunk.position_x * chunk.size_x - posx
	var pz : int = chunk.position_z * chunk.size_z - posz
	
	var tox : int = px + chunk.size_x
	var toz : int = pz + chunk.size_z
	
	if tox > sizex:
		tox = sizex

	if toz > sizez:
		toz = sizez
	
	var floor_pos : int = posy - chunk.position_y * chunk.size_y
	var ceiling_pos : int = floor_pos + sizey
	
	var draw_floor : bool = true
	var draw_ceiling : bool = true
	
	if floor_pos > chunk.size_y:
		return
		
	if ceiling_pos < 0:
		return
	
	if floor_pos < 0: 
		floor_pos = 0
		draw_floor = false
		
	if ceiling_pos > chunk.size_y:
		ceiling_pos = chunk.size_y
		draw_ceiling = false

	var xx : int = 0
	var zz : int = 0
	for x in range(px, tox):
		for z in range(pz, toz):
			var tile : int = map[x][z]
			#we can safely check like this
			if tile > Tile.Wall:
				#grab the wall data, by just right shifting it back. (binary) XXXXYYYY -> 0000XXXX
				var walls : int = tile >> 4

				if walls > 0:
					#(binary) XXXX & 0001 -> 000X
					if walls & NeighbourCaseCodeFlags.WallXP != 0:
						add_wall(chunk, xx, zz, floor_pos, ceiling_pos, dung_wall_xp, wall_texture)
						
					#(binary) XXXX & 0010 -> 00X0
					if walls & NeighbourCaseCodeFlags.WallXN != 0:
						#+ 1 offsets it to be at the proper place
						add_wall(chunk, xx + 1, zz, floor_pos, ceiling_pos, dung_wall_xn, wall_texture)
						
					#etc
					if walls & NeighbourCaseCodeFlags.WallZP != 0:
						add_wall(chunk, xx, zz - 1, floor_pos, ceiling_pos, dung_wall_zp, wall_texture)
						
					if walls & NeighbourCaseCodeFlags.WallZN != 0:
						#+ 1 offsets it to be at the proper place
						add_wall(chunk, xx, zz, floor_pos, ceiling_pos, dung_wall_zn, wall_texture)
						
				if draw_floor:
					chunk.add_mesh_data_resourcev(Vector3(xx, floor_pos, zz), dung_floor, floor_texture)
					
				if draw_ceiling:
					chunk.add_mesh_data_resourcev(Vector3(xx, ceiling_pos, zz), dung_ceiling, ceiling_texture)
				
			zz += 1
		xx += 1
		zz = 0
		
	if spawn_mobs:
		for enemy in enemy_data:
			var bp = enemy[0]
			var pos : Vector3 = Vector3(bp.x * chunk.voxel_scale, (posy + 4) * chunk.voxel_scale, bp.y * chunk.voxel_scale)

			if chunk_aabb.has_point(pos):
				ESS.entity_spawner.spawn_mob(enemy[1], enemy[2], pos)
	#		entities.app

#	for i in range(get_dungeon_start_room_count()):
#		get_dungeon_start_room(i).generate_chunk(chunk, spawn_mobs)

func add_wall(chunk : TerraChunk, x : int, z : int, floor_pos : int, ceiling_pos : int, wall : MeshDataResource, tex : Texture):
	for y in range(floor_pos, ceiling_pos):
		chunk.add_mesh_data_resourcev(Vector3(x, y, z), wall, tex)

func spawn_teleporter_scene(scene : PackedScene, transform : Transform, chunk : TerraChunk, teleports_to : Vector3):
	var s = scene.instance()
	chunk.get_voxel_world().add_child(s)
	s.transform = transform
	s.teleport_to = teleports_to
	
#	print("spawn_teleporter_scene at: " + str(transform.origin) + " points to: " + str(teleports_to))

func build():
#	randomize()
	build_level()

	#Place player
	var start_room = rooms.front()
	player_inner_entrance_position_x = start_room.position.x + 1 + randi() % int(start_room.size.x  - 2)
	player_inner_entrance_position_z = start_room.position.y + 1 + randi() % int(start_room.size.y  - 2)
	inner_entrance_position = Vector3(10,10,10)
	
	#inner_entrance_position!
#	entrance_position.origin = Vector2(player_x * tile_size + tile_size / 2, player_y * tile_size + tile_size / 2)
#	_player = ESS.entity_spawner.load_player(_player_file_name, pos, 1) as Entity
	#Server.sset_seed(_player.sseed)
	
	var end_room = rooms[rooms.size() - 1]
	var erx = start_room.position.x + 1 + randi() % int(start_room.size.x  - 2)
	var erz = start_room.position.y + 1 + randi() % int(start_room.size.y  - 2)
	next_level_teleporter_position_data_space = Vector3(erx, posy, erz)
	
	#Place enemies
	if spawn_mobs:
		for i in range(enemy_count):
			var room = rooms[1 + randi() % (rooms.size() - 1)]
			var x = room.position.x + 1 + randi() % int (room.size.x - 2)
			var y = room.position.y + 1 + randi() % int (room.size.y - 2)
	
			var blocked = false
			for enemy in enemy_data:
				var bp = enemy[0]
				if bp.x == x && bp.y == y:
					blocked = true
					break
	
			if !blocked:
				enemy_data.append([Vector2(x, y), 1, 1])
	#			var enemy = ESS.entity_spawner.spawn_mob(1, 1, Vector3(t.x, t.y, 0), get_path())

func build_level():
	rooms.clear()
	map.clear()
	
	for e in enemies:
		e.queue_free()
		
	enemies.clear()
	
	for x in range(sizex):
		map.append([])
		for y in range(sizez):
			map[x].append(Tile.Wall)
			
	var free_regions = [Rect2(Vector2(2, 2), Vector2(sizex, sizez) - Vector2(4, 4))]

	for i in range(level_room_count):
		add_room(free_regions)
		
		if free_regions.empty():
			break
			
	connect_rooms()
	
	#post process walls, so they have the correct type
	var neighbours : int = 0
	for x in range(sizex):
		for z in range(sizez):
			if map[x][z] == Tile.Floor:
				if x != 0:
					if map[x - 1][z] <= Tile.Wall:
						neighbours |= NeighbourCaseCodeFlags.WallXP
					
				if x != sizex - 1:
					if map[x + 1][z] <= Tile.Wall:
						neighbours |= NeighbourCaseCodeFlags.WallXN
					
				if z != 0:
					if map[x][z - 1] <= Tile.Wall:
						neighbours |= NeighbourCaseCodeFlags.WallZP
					
				if z != sizez - 1:
					if map[x][z + 1] <= Tile.Wall:
						neighbours |= NeighbourCaseCodeFlags.WallZN
					
				#left shift all bits by 4 -> (binary) 0000XXXX -> XXXX0000
				neighbours = neighbours << 4
				#bitwise or them together -> (Tile.Floor = 1 = 00000001) -> (binary) 000000001 | XXXX0000 -> XXXX0001
				map[x][z] = Tile.Floor | neighbours
				neighbours = 0
			

func connect_rooms():
	var stone_graph : AStar2D = AStar2D.new()
	var point_id : int = 0
	
	for x in range(sizex):
		for y in range(sizez):
			if map[x][y] == Tile.Wall:
				stone_graph.add_point(point_id, Vector2(x, y))
				
				#connect to left if also stone
				if x > 0 && map[x - 1][y] == Tile.Wall:
					var left_point = stone_graph.get_closest_point(Vector2(x - 1, y))
					stone_graph.connect_points(point_id, left_point)
					
				#connect to above if also stone
				if y > 0 && map[x][y - 1] == Tile.Wall:
					var above_point = stone_graph.get_closest_point(Vector2(x, y - 1))
					stone_graph.connect_points(point_id, above_point)
					
				point_id += 1
				
	#Build an AStar graph of room connections
	var room_graph  : AStar2D = AStar2D.new()
	point_id = 0
	for room in rooms:
		var room_center = room.position + room.size / 2
		room_graph.add_point(point_id, Vector2(room_center.x, room_center.y))
		point_id += 1
		
	#Add random connections until everything is connected
	while !is_everything_connected(room_graph):
		add_random_connection(stone_graph, room_graph)
			
func is_everything_connected(graph : AStar2D):
	var points = graph.get_points()
	var start = points.pop_back()
	
	for point in points:
		var path = graph.get_point_path(start, point)
		
		if !path:
			return false
			
	return true
	
func add_random_connection(stone_graph : AStar2D, room_graph : AStar2D):
	#Pick rooms to connect
	
	var start_room_id = get_least_connected_point(room_graph)
	var end_room_id = get_nearest_unconnected_point(room_graph, start_room_id)
	
	#Pick door locations
	var start_position = pick_random_door_location(rooms[start_room_id])
	var end_position = pick_random_door_location(rooms[end_room_id])
	
	#Find a path to connect the doors to each other
	var closest_start_point = stone_graph.get_closest_point(start_position)
	var closest_end_point = stone_graph.get_closest_point(end_position)
	
	var path = stone_graph.get_point_path(closest_start_point, closest_end_point)
	assert(path)
	
	#Add path to the map
	set_tile(start_position.x, start_position.y, Tile.Door)
	set_tile(end_position.x, end_position.y, Tile.Door)
	
	for position in path:
		set_tile(position.x, position.y, Tile.Floor)
		
	room_graph.connect_points(start_room_id, end_room_id)
	
	
func get_least_connected_point(graph : AStar2D):
	var point_ids = graph.get_points()
	
	var least
	var tied_for_least = []
	
	for point in point_ids:
		var count = graph.get_point_connections(point).size()
		
		if !least || count < least:
			least = count
			tied_for_least = [point]
		elif count == least:
			tied_for_least.append(point)
			
	return tied_for_least[randi() % tied_for_least.size()]
	
func get_nearest_unconnected_point(graph : AStar2D, target_point):
	var target_position = graph.get_point_position(target_point)
	var point_ids = graph.get_points()
	
	var nearest
	var tied_for_nearest = []
	
	for point in point_ids:
		if point == target_point:
			continue
		
		var path = graph.get_point_path(point, target_point)
		
		if path:
			continue
			
		var dist = (graph.get_point_position(point) - target_position).length()
		
		if !nearest || dist < nearest:
			nearest = dist
			tied_for_nearest = [point]
		elif dist == nearest:
			tied_for_nearest.append(point)
			
	return tied_for_nearest[randi() % tied_for_nearest.size()]
			
func pick_random_door_location(room):
	var options = []
	
	#Top and bottom walls
	for x in range(room.position.x + 1, room.end.x - 2):
		options.append(Vector2(x, room.position.y))
		options.append(Vector2(x, room.end.y))
		
	#Left and right walls
	for y in range(room.position.y + 1, room.end.y - 2):
		options.append(Vector2(room.position.x, y))
		options.append(Vector2(room.end.x, y))
		
	return options[randi() % options.size()]
			
func add_room(free_regions):
	var region = free_regions[randi() % free_regions.size()]
	
	var size_x = min_room_dimension
	if region.size.x > min_room_dimension:
		size_x += randi() % int(region.size.x - min_room_dimension)
		
	var size_y = min_room_dimension
	if region.size.y > min_room_dimension:
		size_y += randi() % int(region.size.y - min_room_dimension)
		
	size_x = min(size_x, min_room_dimension)
	size_y = min(size_y, min_room_dimension)
	
	var start_x = region.position.x
	if region.size.x > size_x:
		start_x += randi() % int(region.size.x - size_x)
		
	var start_y = region.position.y
	if region.size.y > size_y:
		start_y += randi() % int(region.size.y - size_y)
		
	var room = Rect2(start_x, start_y, size_x, size_y)
	rooms.append(room)
	
	for x in range(start_x, start_x + size_x):
		set_tile(x, start_y, Tile.Wall)
		set_tile(x, start_y + size_y - 1, Tile.Wall)
		
	for y in range(start_y, start_y + size_y):
		set_tile(start_x, y, Tile.Wall)
		set_tile(start_x + size_x - 1, y, Tile.Wall)
		
		for x in range(start_x + 1, start_x + size_x - 1):
			set_tile(x, y, Tile.Floor)
			
	cut_regions(free_regions, room)

func cut_regions(free_regions, region_to_remove):
	var removal_queue = []
	var addition_queue = []
	
	for region in free_regions:
		if region.intersects(region_to_remove):
			removal_queue.append(region)
			
			var leftover_left = region_to_remove.position.x - region.position.x - 1
			var leftover_right = region_to_remove.end.x - region_to_remove.end.x - 1
			var leftover_above = region_to_remove.position.y - region.position.y - 1
			var leftover_below = region.end.y - region_to_remove.end.y - 1
			
			if leftover_left >= min_room_dimension:
				addition_queue.append(Rect2(region.position, Vector2(leftover_left, region.size.y)))
				
			if leftover_right >= min_room_dimension:
				addition_queue.append(Rect2(Vector2(region_to_remove.end.x + 1, region.position.y), Vector2(leftover_right, region.size.y)))
				
			if leftover_above >= min_room_dimension:
				addition_queue.append(Rect2(region.position, Vector2(region.size.x, leftover_above)))
				
			if leftover_below >= min_room_dimension:
				addition_queue.append(Rect2(Vector2(region.position.x, region_to_remove.end.y + 1), Vector2(region.size.x, leftover_below)))
				
	for region in removal_queue:
		free_regions.erase(region)
	
	for region in addition_queue:
		free_regions.append(region)

func set_tile(x, y, type):
	map[x][y] = type
	
func has_entrance_position():
	return true
