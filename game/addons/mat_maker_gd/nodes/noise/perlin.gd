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

