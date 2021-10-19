tool
extends MMNode

var NoisePerlin = preload("res://addons/mat_maker_gd/nodes/common/noise_perlin.gd")

export(Resource) var image : Resource

export(Vector2) var scale : Vector2 = Vector2(4, 4)
export(int) var iterations : int = 3
export(float) var persistence : float = 0.5

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_vector2("get_scale", "set_scale", "Scale")#, Vector2(1, 10))
	mm_graph_node.add_slot_int("get_iterations", "set_iterations", "Iterations")#, Vector2(0, 1))
	mm_graph_node.add_slot_float("get_persistence", "set_persistence", "Persistence", 0.01)#, Vector2(0, 1))

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var ps : float = 1.0 / float(pseed)
	
	#perlin_color($(uv), vec2($(scale_x), $(scale_y)), int($(iterations)), $(persistence), $(seed))
	return NoisePerlin.perlin_colorc(uv, scale, iterations, persistence, ps)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_scale() -> Vector2:
	return scale
	
func set_scale(val : Vector2) -> void:
	scale = val
	
	set_dirty(true)

func get_iterations() -> int:
	return iterations
	
func set_iterations(val : int) -> void:
	iterations = val
	
	set_dirty(true)

func get_persistence() -> float:
	return persistence
	
func set_persistence(val : float) -> void:
	persistence = val
	
	set_dirty(true)
