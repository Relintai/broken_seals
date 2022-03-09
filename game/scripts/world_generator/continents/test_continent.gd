tool
extends Continent

export(float) var continent_radius : float = 0.5
export(float) var continent_bevel : float = 0.3
export(float) var continent_base : float = 0

export(PackedScene) var dungeon_teleporter : PackedScene
export(PropData) var prop_tree : PropData
export(PropData) var prop_tree2 : PropData

var voxel_scale : float = 1
var current_seed : int = 0

func get_dungeon_teleporter() -> PackedScene:
	return dungeon_teleporter
	
func set_dungeon_teleporter(ed : PackedScene) -> void:
	dungeon_teleporter = ed
	emit_changed()

func get_prop_tree() -> PropData:
	return prop_tree
	
func set_prop_tree(ed : PropData) -> void:
	prop_tree = ed
	emit_changed()

func get_prop_tree2() -> PropData:
	return prop_tree2
	
func set_prop_tree2(ed : PropData) -> void:
	prop_tree2 = ed
	emit_changed()

func get_continent_radius() -> float:
	return continent_radius
	
func set_continent_radius(ed : float) -> void:
	continent_radius = ed
	emit_changed()
	
func get_continent_bevel() -> float:
	return continent_bevel
	
func set_continent_bevel(ed : float) -> void:
	continent_bevel = ed
	emit_changed()
	
func get_continent_base() -> float:
	return continent_base
	
func set_continent_base(ed : float) -> void:
	continent_base = ed
	emit_changed()


func get_editor_rect_border_color() -> Color:
	return Color(0.8, 0.8, 0.8, 1)

func get_editor_rect_color() -> Color:
	return Color(0.8, 0.8, 0.8, 0.9)

func get_editor_rect_border_size() -> int:
	return 2

func get_editor_font_color() -> Color:
	return Color(0, 0, 0, 1)

func get_editor_class() -> String:
	return "TestContinent"

func get_editor_additional_text() -> String:
	return "TestContinent"
	
func _setup_terra_library(library : TerrainLibrary, pseed : int) -> void:
	pass

static func circle(uv : Vector2, c : Vector2, r : float) -> float:
	c.x += 0.5
	c.y += 0.5
	
	return (uv - c).length() - r;

func get_value_for(uv : Vector2) -> float:
	var f : float = circle(uv, Vector2(), continent_radius)
	
	var cf : float = clamp(continent_base - f / max(continent_bevel, 0.00001), 0.0, 1.0)
	
	return cf

func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 0)

	var s : FastNoise = FastNoise.new()
	s.set_noise_type(FastNoise.TYPE_SIMPLEX)
	s.set_seed(current_seed)
	
	var sdet : FastNoise = FastNoise.new()
	sdet.set_noise_type(FastNoise.TYPE_SIMPLEX)
	sdet.set_seed(current_seed)
	
	var luv : Vector2 = raycast.get_local_uv()
	
	var lhit_world_pos : Vector2 = raycast.get_local_position()
	lhit_world_pos.x *= chunk.size_x
	lhit_world_pos.y *= chunk.size_z
	
	var world_rect_size : Vector2 = get_rect().size
	world_rect_size.x *= chunk.size_x
	world_rect_size.y *= chunk.size_z

	for x in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
		for z in range(-chunk.margin_start, chunk.size_z + chunk.margin_end):
			var vx : int = x + (chunk.position_x * chunk.size_x)
			var vz : int = z + (chunk.position_z * chunk.size_z)
			
			var lwp : Vector2 = lhit_world_pos + Vector2(x, z)
			var local_uv : Vector2 = lwp / world_rect_size
			var interp : float = get_value_for(local_uv)
			
			var val : float = (s.get_noise_2d(vx * 0.2, vz * 0.2))
			val *= val
			val += abs(sdet.get_noise_2d(vx * 0.3, vz * 0.3)) * 10
			val += 110
			
			var oil : int = chunk.get_voxel(x, z, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
			
			oil += float(val) * interp

			chunk.set_voxel(oil, x, z, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)

func _generate_terra_chunka(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	voxel_scale = chunk.voxel_scale
	current_seed = pseed

	var cx : int = chunk.get_position_x()
	var cz : int = chunk.get_position_z()
	
	var chunk_seed : int = 123 + (cx * 231) + (cz * 123)

	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = chunk_seed
	
	gen_terra_chunk(chunk, rng)
	
	if chunk.position_x == 0 && chunk.position_z == 0:
		#test
		spawn_dungeon(chunk, chunk_seed, spawn_mobs)
	else:
		if rng.randi() % 10 == 0:
			spawn_dungeon(chunk, chunk_seed, spawn_mobs)
	
	if not Engine.editor_hint and spawn_mobs and rng.randi() % 4 == 0:
		var level : int = 1

		if chunk.get_voxel_world().has_method("get_mob_level"):
			level  = chunk.get_voxel_world().get_mob_level()

		ESS.entity_spawner.spawn_mob(0, level, \
					Vector3(chunk.position_x * chunk.size_x * chunk.voxel_scale + chunk.size_x / 2,\
							100, \
							chunk.position_z * chunk.size_z * chunk.voxel_scale + chunk.size_z / 2))

func gen_terra_chunk(chunk: TerrainChunk, rng : RandomNumberGenerator) -> void:
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 0)

	var s : FastNoise = FastNoise.new()
	s.set_noise_type(FastNoise.TYPE_SIMPLEX)
	s.set_seed(current_seed)
	
	var sdet : FastNoise = FastNoise.new()
	sdet.set_noise_type(FastNoise.TYPE_SIMPLEX)
	sdet.set_seed(current_seed)
	
	for x in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
		for z in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
			var vx : int = x + (chunk.position_x * chunk.size_x)
			var vz : int = z + (chunk.position_z * chunk.size_z)
			
			var val : float = (s.get_noise_2d(vx * 0.05, vz * 0.05) + 2)
			val *= val
			val *= 20.0
			val += abs(sdet.get_noise_2d(vx * 0.8, vz * 0.8)) * 20
			val += 100

			chunk.set_voxel(val, x, z, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)

			if val < 150:
				chunk.set_voxel(2, x, z, TerrainChunkDefault.DEFAULT_CHANNEL_TYPE)
			elif val > 190:
				chunk.set_voxel(4, x, z, TerrainChunkDefault.DEFAULT_CHANNEL_TYPE)
			else:
				if chunk.position_x == 0 && chunk.position_z == 0:
					continue
					
				if rng.randf() > 0.992:
					var tr : Transform = Transform()
					
					tr = tr.rotated(Vector3(0, 1, 0), rng.randf() * PI)
					tr = tr.rotated(Vector3(1, 0, 0), rng.randf() * 0.2 - 0.1)
					tr = tr.rotated(Vector3(0, 0, 1), rng.randf() * 0.2 - 0.1)
					tr = tr.scaled(Vector3(0.9 + rng.randf() * 0.2, 0.9 + rng.randf() * 0.2, 0.9 + rng.randf() * 0.2))
					tr.origin = Vector3((x + chunk.position_x * chunk.size_x), ((val - 2) / 255.0) * chunk.world_height, (z + chunk.position_z * chunk.size_z))

					chunk.voxel_world.prop_add(tr, prop_tree)

func spawn_dungeon(chunk: TerrainChunk, dungeon_seed : int, spawn_mobs : bool) -> void:
	var world_space_data_coordinates_x : int = chunk.position_x * chunk.size_x
	var world_space_data_coordinates_z : int = chunk.position_z * chunk.size_z
	
	var vpx : int = 6
	var vpz : int = 6
	
	var x : float = (world_space_data_coordinates_x + vpx) * chunk.voxel_scale
	var z : float = (world_space_data_coordinates_z + vpz) * chunk.voxel_scale
	
	var vh : int = chunk.get_voxel(vpx, vpz, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
	
	var orx : int = (randi() % 3) + 2
	var orz : int = (randi() % 3) + 2
	
	for wx in range(vpx - orx, vpx + orx + 1):
		for wz in range(vpz - orz, vpz + orz + 1):
			chunk.set_voxel(vh, wx, wz, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
	var vwh : float = chunk.get_voxel_scale() * chunk.get_world_height() * (vh / 255.0)
	
	var dt : Spatial = dungeon_teleporter.instance()
	chunk.voxel_world.add_child(dt)
	dt.owner_chunk = chunk
	
	var level : int = 2
		
	if chunk.get_voxel_world().has_method("get_mob_level"):
		level  = chunk.get_voxel_world().get_mob_level()
	
	dt.min_level = level - 1
	dt.max_level = level + 1
	dt.dungeon_seed = dungeon_seed
	dt.spawn_mobs = spawn_mobs
	dt.transform = Transform(Basis().scaled(Vector3(chunk.voxel_scale, chunk.voxel_scale, chunk.voxel_scale)), Vector3(x, vwh, z))
	
func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_h_separator()
	inspector.add_slot_resource("get_dungeon_teleporter", "set_dungeon_teleporter", "Dungeon Teleporter", "PackedScene")
	inspector.add_slot_resource("get_prop_tree", "set_prop_tree", "Prop Tree", "PropData")
	inspector.add_slot_resource("get_prop_tree2", "set_prop_tree2", "Prop Tree2", "PropData")
	
	inspector.add_h_separator()
	inspector.add_slot_float("get_continent_radius", "set_continent_radius", "Continent Radius", 0.01)
	inspector.add_slot_float("get_continent_bevel", "get_continent_bevel", "Continent Bevel", 0.01)
	inspector.add_slot_float("get_continent_base", "set_continent_base", "Continent Base", 0.01)
