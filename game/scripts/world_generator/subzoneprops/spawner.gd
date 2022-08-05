tool
extends SubZoneProp

export (EntityData) var trainer : EntityData
export (EntityData) var vendor : EntityData

func _is_spawner() -> bool:
	return true
	
func _get_spawn_local_position() -> Vector2:
	return Vector2(get_rect().size.x / 2, get_rect().size.y / 2)

func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	if !spawn_mobs:
		return
	
	if trainer == null || vendor == null:
		return
		
	var p : Vector2i = Vector2i(get_rect().size.x / 2, get_rect().size.y / 2)
	var lp : Vector2i = raycast.get_local_position()

	if p == lp:
		var pos : Vector3 = Vector3(chunk.get_position_x() * chunk.get_size_x() * chunk.voxel_scale + 4, 50 * chunk.voxel_scale, chunk.get_position_z() * chunk.get_size_z() * chunk.voxel_scale + 4)
		ESS.entity_spawner.spawn_mob(trainer.id, 1, pos)
		pos = Vector3(chunk.get_position_x() * chunk.get_size_x() * chunk.voxel_scale + 2, 50 * chunk.voxel_scale, chunk.get_position_z() * chunk.get_size_z() * chunk.voxel_scale + 2)
		ESS.entity_spawner.spawn_mob(vendor.id, 1, pos)

func get_trainer() -> EntityData:
	return trainer
	
func set_trainer(ed : EntityData) -> void:
	trainer = ed
	emit_changed()
	
func get_vendor() -> EntityData:
	return vendor
	
func set_vendor(ed : EntityData) -> void:
	vendor = ed
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
	return "Spawner"

func get_editor_additional_text() -> String:
	return ""

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_h_separator()
	inspector.add_slot_resource("get_trainer", "set_trainer", "Trainer", "EntityData")
	inspector.add_slot_resource("get_vendor", "set_vendor", "Vendor", "EntityData")
