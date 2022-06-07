tool
extends MMNode

export(Resource) var image : Resource
export(Resource) var input : Resource
export(float) var edge_color : float = 1

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

	input.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input    "
	
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
	mm_graph_node.add_slot_float("get_edge_color", "set_edge_color", "Edge color", 0.01)

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func _get_value_for(uv : Vector2, pseed : int) -> Color:
	#vec4 $(name_uv)_bb = $in($uv);
	var c : Color = input.get_value(uv)
	
	#mix($edgecolor, rand(vec2(float($seed), rand(vec2(rand($(name_uv)_bb.xy), rand($(name_uv)_bb.zw))))), step(0.0000001, dot($(name_uv)_bb.zw, vec2(1.0))))
	var r1 : float = MMAlgos.rand(Vector2(c.r, c.g))
	var r2 : float = MMAlgos.rand(Vector2(c.b, c.a))
	var s : float = MMAlgos.step(0.0000001, Vector2(c.b, c.a).dot(Vector2(1, 1)))
	
	var f : float = lerp(edge_color, MMAlgos.rand(Vector2(1.0 / float(pseed), MMAlgos.rand(Vector2(r1, r2)))), s)
	return Color(f, f, f, 1)

#edge_color
func get_edge_color() -> float:
	return edge_color

func set_edge_color(val : float) -> void:
	edge_color = val

	set_dirty(true)
