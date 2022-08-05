tool
extends SubZoneProp

export(PackedScene) var dungeon_teleporter : PackedScene

var voxel_scale : float = 1
var current_seed : int = 0

func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	voxel_scale = chunk.voxel_scale
	current_seed = pseed

	var cx : int = chunk.get_position_x()
	var cz : int = chunk.get_position_z()
	
	var chunk_seed : int = 123 + (cx * 231) + (cz * 123)

	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = chunk_seed
	
	var p : Vector2i = Vector2i(get_rect().size.x / 2, get_rect().size.y / 2)
	var lp : Vector2i = raycast.get_local_position()

	if p == lp:
		spawn_dungeon(chunk, chunk_seed, spawn_mobs)
	
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
	

func get_editor_rect_border_color() -> Color:
	return Color(0.8, 0.8, 0.8, 1)

func get_editor_rect_color() -> Color:
	return Color(0.8, 0.8, 0.8, 0.9)

func get_editor_rect_border_size() -> int:
	return 2

func get_editor_font_color() -> Color:
	return Color(0, 0, 0, 1)

func get_editor_class() -> String:
	return "DungeonSpawner"

func get_editor_additional_text() -> String:
	return ""

func get_dungeon_teleporter() -> PackedScene:
	return dungeon_teleporter
	
func set_dungeon_teleporter(ed : PackedScene) -> void:
	dungeon_teleporter = ed
	emit_changed()

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_h_separator()
	inspector.add_slot_resource("get_dungeon_teleporter", "set_dungeon_teleporter", "Dungeon Teleporter", "PackedScene")
