tool
extends MMNode

var NoisePerlin = preload("res://addons/mat_maker_gd/nodes/common/noise_perlin.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var scale : Vector2 = Vector2(4, 4)
export(int) var iterations : int = 3
export(float) var persistence : float = 0.5

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return NoisePerlin.perlinc(uv, scale, iterations, persistence, pseed)

func _register_methods(mm_graph_node) -> void:
	#mm_graph_node.add_slot_texture(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE, "render_image", "")
	mm_graph_node.add_slot_int(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, "get_iterations", "set_iterations", "iterations")#, Vector2(1, 10))
	mm_graph_node.add_slot_float(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, "get_persistence", "set_persistence", "persistence", 0.05)#, Vector2(0, 1))
	mm_graph_node.add_slot_vector2(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, "get_scale", "set_scale", "scale", 1)#, Vector2(1, 32))

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
