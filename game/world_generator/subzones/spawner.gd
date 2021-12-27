tool
extends SubZone

export (EntityData) var trainer : EntityData
export (EntityData) var vendor : EntityData

var main_chunk_pos_x : int = 0
var main_chunk_pos_z : int = 0

func _setup() -> void:
	main_chunk_pos_x = get_parent_pos().x + get_rect().position.x + get_rect().size.x / 2
	main_chunk_pos_z = get_parent_pos().y + get_rect().position.y + get_rect().size.y / 2
	
func get_spawn_chunk_position() -> Vector2:
	return Vector2(main_chunk_pos_x, main_chunk_pos_z)

func _generate_terra_chunk(chunk: TerraChunk, pseed : int, spawn_mobs: bool, stack : Array, stack_index : int) -> void:
	if !spawn_mobs:
		return
	
	if trainer == null || vendor == null:
		return
		
	if chunk.position_x == main_chunk_pos_x && chunk.position_z == main_chunk_pos_z:
		var pos : Vector3 = Vector3(main_chunk_pos_x * chunk.get_size_x() * chunk.voxel_scale + 4, 50 * chunk.voxel_scale, main_chunk_pos_z * chunk.get_size_z() * chunk.voxel_scale + 4)
		ESS.entity_spawner.spawn_mob(trainer.id, 1, pos)
		pos = Vector3(main_chunk_pos_x * chunk.get_size_x() * chunk.voxel_scale + 2, 50 * chunk.voxel_scale, main_chunk_pos_z * chunk.get_size_z() * chunk.voxel_scale + 2)
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
	return "Spawner"

func setup_property_inspector(inspector) -> void:
	.setup_property_inspector(inspector)
	
	inspector.add_slot_resource("get_trainer", "set_trainer", "Trainer", "EntityData")
	inspector.add_slot_resource("get_vendor", "set_vendor", "Vendor", "EntityData")
