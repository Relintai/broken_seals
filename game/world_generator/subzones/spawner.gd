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
		
	#var r : Rect2 = get_rect()
	#var cpx : int = r.position.x + (r.size.x / 2)
	
	if chunk.position_x == main_chunk_pos_x && chunk.position_z == main_chunk_pos_z:
		var pos : Vector3 = Vector3(4 * chunk.voxel_scale, 8 * chunk.voxel_scale, 4 * chunk.voxel_scale)
		ESS.entity_spawner.spawn_mob(trainer.id, 1, pos)
		pos = Vector3(2 * chunk.voxel_scale, 8 * chunk.voxel_scale, 2 * chunk.voxel_scale)
		ESS.entity_spawner.spawn_mob(vendor.id, 1, pos)


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
