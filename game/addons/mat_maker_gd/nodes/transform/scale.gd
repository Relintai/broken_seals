tool
extends MMNode

export(Resource) var image : Resource
export(Resource) var input : Resource
export(Vector2) var center : Vector2 = Vector2()
export(Vector2) var scale : Vector2 = Vector2(1, 1)

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

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
	mm_graph_node.add_slot_vector2("get_center", "set_center", "Center", 0.01)
	mm_graph_node.add_slot_vector2("get_scale", "set_scale", "Scale", 0.01)

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func _get_value_for(uv : Vector2, pseed : int) -> Color:
	#$i(scale($uv, vec2(0.5+$cx, 0.5+$cy), vec2($scale_x, $scale_y)))
	return input.get_value(MMAlgos.scale(uv, center + Vector2(0.5, 0.5), scale))

#center
func get_center() -> Vector2:
	return center

func set_center(val : Vector2) -> void:
	center = val

	set_dirty(true)

#scale
func get_scale() -> Vector2:
	return scale

func set_scale(val : Vector2) -> void:
	scale = val

	set_dirty(true)
