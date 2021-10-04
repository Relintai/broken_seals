tool
extends MMNode

var NoisePerlin = preload("res://addons/mat_maker_gd/nodes/common/noise_perlin.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var scale : Vector2 = Vector2(4, 4)
export(int) var iterations : int = 3
export(float) var persistence : float = 0.5

func get_value_for(uv : Vector2, slot_idx : int, pseed : int) -> Color:
	return NoisePerlin.perlinc(uv, scale, iterations, persistence, pseed)

func register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_IMAGE, "recalculate_image", "")
	mm_graph_node.add_slot_int(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_NONE, "get_iterations", "set_iterations", "iterations")
	mm_graph_node.add_slot_float(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_NONE, "get_persistence", "set_persistence", "persistence")
	mm_graph_node.add_slot_vector2(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_NONE, "get_scale", "set_scale", "scale")

func get_iterations() -> int:
	return iterations
	
func set_iterations(val : int) -> void:
	iterations = val
	
	emit_changed()

func get_persistence() -> float:
	return persistence
	
func set_persistence(val : float) -> void:
	persistence = val
	
	emit_changed()

func get_scale() -> Vector2:
	return scale
	
func set_scale(val : Vector2) -> void:
	scale = val
	
	emit_changed()
