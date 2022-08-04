tool
extends "res://addons/world_generator/resources/world_gen_base_resource.gd"
class_name WorldGenWorld

export(Array) var continents : Array

func get_content() -> Array:
	return continents

func set_content(arr : Array) -> void:
	continents = arr

func create_content(item_name : String = "") -> void:
	var continent : Continent = Continent.new()
	continent.resource_name = item_name

	add_content(continent)

func add_content(entry : WorldGenBaseResource) -> void:
	var r : Rect2 = get_rect()
	r.position = Vector2()
	r.size.x /= 10.0
	r.size.y /= 10.0
	
	entry.set_rect(r)
	
	continents.append(entry)
	emit_changed()

func remove_content_entry(entry : WorldGenBaseResource) -> void:
	for i in range(continents.size()):
		if continents[i] == entry:
			continents.remove(i)
			emit_changed()
			return

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
func generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool) -> void:
	var p : Vector2 = Vector2(chunk.get_position_x(), chunk.get_position_z())

	var raycast : WorldGenRaycast = get_hit_stack(p)
	
	if raycast.size() == 0:
		_generate_terra_chunk_fallback(chunk, pseed, spawn_mobs)
		return
	
	_generate_terra_chunk(chunk, pseed, spawn_mobs, raycast)
	
	while raycast.next():
		raycast.get_resource()._generate_terra_chunk(chunk, pseed, spawn_mobs, raycast)
		
	
func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	pass
	
func _generate_terra_chunk_fallback(chunk: TerrainChunk, pseed : int, spawn_mobs: bool) -> void:
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 1)
	chunk.set_voxel(1, 0, 0, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
	
