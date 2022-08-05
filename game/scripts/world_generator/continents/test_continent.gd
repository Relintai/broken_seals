tool
extends Continent

export(float) var continent_radius : float = 0.5
export(float) var continent_bevel : float = 0.3
export(float) var continent_base : float = 0

var voxel_scale : float = 1
var current_seed : int = 0

func _eitor_draw_additional(control : Control) -> void:
	gui_draw_continent_radius(control, Color(0.6, 0.6, 0.6, 1))
	gui_draw_continent_bevel(control, Color(1, 1, 1, 1))

func _eitor_draw_additional_background(control : Control) -> void:
	gui_draw_continent_radius(control, Color(0.3, 0.3, 0.3, 1))
	gui_draw_continent_bevel(control, Color(0.6, 0.6, 0.6, 1))

func gui_draw_continent_radius(control : Control, color : Color) -> void:
	var s : Vector2 = control.get_size()
	
	var points : PoolVector2Array
	var ofsx : float = (1 - (continent_radius * 2)) * s.x / 2.0
	var ofsy : float = (1 - (continent_radius * 2)) * s.y / 2.0
	
	for i in range(16):
		var ifl : float = float(i)
		var n : float = ifl / 16.0 * 2 * PI
		var n1 : float = (ifl + 1.0) / 16.0 * 2 * PI
		
		points.push_back(Vector2((sin(n) + 1.0) * 0.5 * continent_radius * 2 * s.x + ofsx, (cos(n) + 1.0) * 0.5 * continent_radius * 2 * s.y + ofsy))
		points.push_back(Vector2((sin(n1) + 1.0) * 0.5 * continent_radius * 2 * s.x + ofsx, (cos(n1) + 1.0) * 0.5 * continent_radius * 2 * s.y + ofsy))
		
	control.draw_polyline(points, color, 1)

func gui_draw_continent_bevel(control : Control, color : Color) -> void:
	var s : Vector2 = control.get_size()
	
	var points : PoolVector2Array
	var bevel_radius : float =  (min(continent_radius, continent_bevel) / continent_radius) / 2.0
	var ofsx : float = (1 - (bevel_radius * 2)) * s.x / 2.0
	var ofsy : float = (1 - (bevel_radius * 2)) * s.y / 2.0
	
	for i in range(16):
		var ifl : float = float(i)
		var n : float = ifl / 16.0 * 2 * PI
		var n1 : float = (ifl + 1.0) / 16.0 * 2 * PI
		
		points.push_back(Vector2((sin(n) + 1.0) * 0.5 * bevel_radius * 2 * s.x + ofsx, (cos(n) + 1.0) * 0.5 * bevel_radius * 2 * s.y + ofsy))
		points.push_back(Vector2((sin(n1) + 1.0) * 0.5 * bevel_radius * 2 * s.x + ofsx, (cos(n1) + 1.0) * 0.5 * bevel_radius * 2 * s.y + ofsy))
		
	control.draw_polyline(points, color, 1)

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
	return ""
	
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

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_h_separator()
	inspector.add_slot_float("get_continent_radius", "set_continent_radius", "Continent Radius", 0.01)
	inspector.add_slot_float("get_continent_bevel", "set_continent_bevel", "Continent Bevel", 0.01)
	inspector.add_slot_float("get_continent_base", "set_continent_base", "Continent Base", 0.01)
