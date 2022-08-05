tool
extends SubZoneProp

export (EntityData) var mob : EntityData
export (int) var level : int = 1
#density

func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	if !mob:
		return
	
	var cx : int = chunk.get_position_x()
	var cz : int = chunk.get_position_z()
	
	var chunk_seed : int = 123 + (cx * 231) + (cz * 123)

	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = chunk_seed
	
	if not Engine.editor_hint and spawn_mobs and rng.randi() % 4 == 0:
		chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 0)
		var oil : int = chunk.get_voxel(chunk.size_x / 2, chunk.size_z / 2, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
		
		ESS.entity_spawner.spawn_mob(mob.id, level, \
					Vector3(chunk.position_x * chunk.size_x * chunk.voxel_scale + chunk.size_x / 2,\
							((oil - 2) / 255.0) * chunk.world_height, \
							chunk.position_z * chunk.size_z * chunk.voxel_scale + chunk.size_z / 2))

func get_mob() -> EntityData:
	return mob
	
func set_mob(ed : EntityData) -> void:
	mob = ed
	emit_changed()

func get_level() -> int:
	return level
	
func set_level(val : int) -> void:
	level = val
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
	return "MobSpawner"

func get_editor_additional_text() -> String:
	return ""

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_h_separator()
	inspector.add_slot_resource("get_mob", "set_mob", "Mob", "EntityData")
	inspector.add_slot_int("get_level", "set_level", "level")

