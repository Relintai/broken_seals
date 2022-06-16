tool
extends GradientBase

export(Resource) var image : Resource
export(Resource) var input : Resource

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_FLOAT
		input.set_default_value(1)

	input.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input1    "
	
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_IMAGE
		
	#image.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_FLOAT
	image.output_slot_type = MMNodeUniversalProperty.SLOT_TYPE_IMAGE
	#image.force_override = true

	register_input_property(input)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_gradient()

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func _get_value_for(uv : Vector2, pseed : int) -> Color:
	var f : float = input.get_value(uv)
	
	return get_gradient_color(f)
#	return Color(0.5, 0.5, 0.5, 1)

func get_gradient_color(x : float) -> Color:
	if interpolation_type == 0:
		return MMAlgos.gradient_type_1(x, points)
	elif interpolation_type == 1:
		return MMAlgos.gradient_type_2(x, points)
	elif interpolation_type == 2:
		return MMAlgos.gradient_type_3(x, points)
	elif interpolation_type == 3:
		return MMAlgos.gradient_type_4(x, points)

	return Color(1, 1, 1, 1)
