tool
extends Zone

export(float) var zone_radius : float = 0.5
export(float) var zone_bevel : float = 0.3
export(float) var zone_base : float = 0

var voxel_scale : float = 1
var current_seed : int = 0

func get_zone_radius() -> float:
	return zone_radius
	
func set_zone_radius(ed : float) -> void:
	zone_radius = ed
	emit_changed()
	
func get_zone_bevel() -> float:
	return zone_bevel
	
func set_zone_bevel(ed : float) -> void:
	zone_bevel = ed
	emit_changed()
	
func get_zone_base() -> float:
	return zone_base
	
func set_zone_base(ed : float) -> void:
	zone_base = ed
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
	return "TestZone"

func get_editor_additional_text() -> String:
	return ""

static func circle(uv : Vector2, c : Vector2, r : float) -> float:
	c.x += 0.5
	c.y += 0.5
	
	return (uv - c).length() - r;

func get_value_for(uv : Vector2) -> float:
	var f : float = circle(uv, Vector2(), zone_radius)
	
	var cf : float = clamp(zone_base - f / max(zone_bevel, 0.00001), 0.0, 1.0)
	
	return cf

func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	voxel_scale = chunk.voxel_scale
	current_seed = pseed

	var cx : int = chunk.get_position_x()
	var cz : int = chunk.get_position_z()
	
	var chunk_seed : int = 123 + (cx * 231) + (cz * 123)

	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = chunk_seed
	
	gen_terra_chunk(chunk, rng, raycast)
	
func gen_terra_chunk(chunk: TerrainChunk, rng : RandomNumberGenerator, raycast : WorldGenRaycast) -> void:
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
		for z in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
			var vx : int = x + (chunk.position_x * chunk.size_x)
			var vz : int = z + (chunk.position_z * chunk.size_z)
			var lwp : Vector2 = lhit_world_pos + Vector2(x, z)
			var local_uv : Vector2 = lwp / world_rect_size
			var interp : float = get_value_for(local_uv)
			
			var val : float = (s.get_noise_2d(vx * 0.05, vz * 0.05) + 2)
			val *= val
			#val *= 10.0
			val += abs(sdet.get_noise_2d(vx * 0.8, vz * 0.8)) * 5
			
			var oil : int = chunk.get_voxel(x, z, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
			
			oil += float(val) * interp

			chunk.set_voxel(oil, x, z, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
			
			if interp < 0.2:
				continue
				
			chunk.set_voxel(1, x, z, TerrainChunkDefault.DEFAULT_CHANNEL_TYPE)

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_h_separator()
	inspector.add_slot_float("get_zone_radius", "set_zone_radius", "Zone Radius", 0.01)
	inspector.add_slot_float("get_zone_bevel", "set_zone_bevel", "Zone Bevel", 0.01)
	inspector.add_slot_float("get_zone_base", "set_zone_base", "Zone Base", 0.01)
