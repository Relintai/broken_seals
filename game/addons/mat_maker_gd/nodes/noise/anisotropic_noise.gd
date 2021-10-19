tool
extends MMNode

var Noises = preload("res://addons/mat_maker_gd/nodes/common/noises.gd")

export(Resource) var image : Resource

export(Vector2) var scale : Vector2 = Vector2(4, 256)
export(float) var smoothness : float = 1
export(float) var interpolation : float = 1

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_vector2("get_scale", "set_scale", "Scale", 1)#, Vector2(1, 10))
	mm_graph_node.add_slot_float("get_smoothness", "set_smoothness", "Smoothness", 0.01)#, Vector2(0, 1))
	mm_graph_node.add_slot_float("get_interpolation", "set_interpolation", "Interpolation", 0.01)#, Vector2(0, 1))

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var ps : float = 1.0 / float(pseed)
	
	#anisotropic($(uv), vec2($(scale_x), $(scale_y)), $(seed), $(smoothness), $(interpolation))
	return Noises.anisotropicc(uv, scale, ps, smoothness, interpolation)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_scale() -> Vector2:
	return scale
	
func set_scale(val : Vector2) -> void:
	scale = val
	
	set_dirty(true)

func get_smoothness() -> float:
	return smoothness
	
func set_smoothness(val : float) -> void:
	smoothness = val
	
	set_dirty(true)

func get_interpolation() -> float:
	return interpolation
	
func set_interpolation(val : float) -> void:
	interpolation = val
	
	set_dirty(true)
