tool
extends SubZone

export(PropData) var prop_tree : PropData
export(PropData) var prop_tree2 : PropData

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

func get_editor_rect_border_color() -> Color:
	return Color(0.8, 0.8, 0.8, 1)

func get_editor_rect_color() -> Color:
	return Color(0.8, 0.8, 0.8, 0.9)

func get_editor_rect_border_size() -> int:
	return 2

func get_editor_font_color() -> Color:
	return Color(0, 0, 0, 1)

func get_editor_class() -> String:
	return "Forest"

func get_editor_additional_text() -> String:
	return ""

func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:

	var cx : int = chunk.get_position_x()
	var cz : int = chunk.get_position_z()
	
	var chunk_seed : int = 123 + (cx * 231) + (cz * 123)

	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = chunk_seed
	
	#chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 0)
	
	# TODO refactor this, it's inefficient
	for x in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
		for z in range(-chunk.margin_start, chunk.size_x + chunk.margin_end):
			if rng.randf() > 0.992:
				var oil : int = chunk.get_voxel(x, z, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
				
				var tr : Transform = Transform()
					
				tr = tr.rotated(Vector3(0, 1, 0), rng.randf() * PI)
				tr = tr.rotated(Vector3(1, 0, 0), rng.randf() * 0.2 - 0.1)
				tr = tr.rotated(Vector3(0, 0, 1), rng.randf() * 0.2 - 0.1)
				tr = tr.scaled(Vector3(0.9 + rng.randf() * 0.2, 0.9 + rng.randf() * 0.2, 0.9 + rng.randf() * 0.2))
				tr.origin = Vector3((x + chunk.position_x * chunk.size_x), ((oil - 2) / 255.0) * chunk.world_height, (z + chunk.position_z * chunk.size_z))

				chunk.voxel_world.prop_add(tr, prop_tree)

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_h_separator()
	inspector.add_slot_resource("get_prop_tree", "set_prop_tree", "Prop Tree", "PropData")
	inspector.add_slot_resource("get_prop_tree2", "set_prop_tree2", "Prop Tree2", "PropData")
