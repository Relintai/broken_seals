tool
extends MMNode

var NoisePerlin = preload("res://addons/mat_maker_gd/nodes/common/noise_perlin.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

var seed_o12297 = -26656;
var p_o12297_scale_x = 4.000000000;
var p_o12297_scale_y = 4.000000000;
var p_o12297_iterations = 3.000000000;
var p_o12297_persistence = 0.500000000;

func get_value_for(uv : Vector2, slot_idx : int) -> Color:
	var a = NoisePerlin.perlinc(uv, Vector2(p_o12297_scale_x, p_o12297_scale_y), int(p_o12297_iterations), p_o12297_persistence, seed_o12297)
	return a

func register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture(0, 0, "recalculate_image", "")

