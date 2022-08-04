tool
extends "res://addons/world_generator/resources/world_gen_world.gd"

export(int) var normal_surface_id : int = 2
export(int) var base_iso_level : int = 0
export(int) var water_iso_level : int = 100
export(int) var water_surface_id : int = 5
export(FastnoiseNoiseParams) var base_noise : FastnoiseNoiseParams = null

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_slot_int("get_normal_surface_id", "set_normal_surface_id", "Normal Surface ID")
	inspector.add_slot_int("get_base_iso_level", "set_base_iso_level", "Base Isolevel")
	inspector.add_slot_int("get_water_iso_level", "set_water_iso_level", "Water Isolevel")
	inspector.add_slot_int("get_water_surface_id", "set_water_surface_id", "Water Surface ID")
	
	inspector.add_slot_resource("get_base_noise_params", "set_base_noise_params", "Base Noise Params", "FastnoiseNoiseParams")


func generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool) -> void:
	var p : Vector2 = Vector2(chunk.get_position_x(), chunk.get_position_z())
	var raycast : WorldGenRaycast = get_hit_stack(p)
	
	_generate_terra_chunk(chunk, pseed, spawn_mobs, raycast)
	
	while raycast.next():
		raycast.get_resource()._generate_terra_chunk(chunk, pseed, spawn_mobs, raycast)
		
	_generate_terra_chunk_ocean(chunk, pseed, spawn_mobs)
	
func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	_generate_terra_chunk_fallback(chunk, pseed, spawn_mobs)
	
func _generate_terra_chunk_fallback(chunk: TerrainChunk, pseed : int, spawn_mobs: bool) -> void:
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_TYPE, normal_surface_id)
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, base_iso_level)
	#chunk.set_voxel(1, 0, 0, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
	
func _generate_terra_chunk_ocean(chunk: TerrainChunk, pseed : int, spawn_mobs: bool) -> void:
	if !chunk.channel_is_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_TYPE):
		return
		
	if !chunk.channel_is_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL):
		return
	
	var ensured_channels : bool = false
	
	for x in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
		for z in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
			var iso_level : int = chunk.get_voxel(x, z, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
			
			if iso_level < water_iso_level:
				if !ensured_channels:
					ensured_channels = true
					
					chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_LIQUID_TYPE, 0)
					chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_LIQUID_ISOLEVEL, water_iso_level)

				chunk.set_voxel(water_surface_id, x, z, TerrainChunkDefault.DEFAULT_CHANNEL_LIQUID_TYPE)
				chunk.set_voxel(water_iso_level, x, z, TerrainChunkDefault.DEFAULT_CHANNEL_LIQUID_ISOLEVEL)

func get_normal_surface_id() -> int:
	return normal_surface_id
	
func set_normal_surface_id(ed : int) -> void:
	normal_surface_id = ed
	emit_changed()

func get_base_iso_level() -> int:
	return base_iso_level
	
func set_base_iso_level(ed : int) -> void:
	base_iso_level = ed
	emit_changed()

func get_water_iso_level() -> int:
	return water_iso_level
	
func set_water_iso_level(ed : int) -> void:
	water_iso_level = ed
	emit_changed()
	
func get_water_surface_id() -> int:
	return water_surface_id
	
func set_water_surface_id(ed : int) -> void:
	water_surface_id = ed
	emit_changed()

func get_base_noise_params() -> FastnoiseNoiseParams:
	return base_noise
	
func set_base_noise_params(ed : FastnoiseNoiseParams) -> void:
	base_noise = ed
	emit_changed()
