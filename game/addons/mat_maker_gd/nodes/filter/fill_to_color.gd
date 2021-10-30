tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Fills = preload("res://addons/mat_maker_gd/nodes/common/fills.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(Resource) var color_map : Resource
export(Color) var edge_color : Color = Color(1, 1, 1, 1)

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input    "
	
	if !color_map:
		color_map = MMNodeUniversalProperty.new()
		color_map.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		color_map.set_default_value(Color(1, 1, 1, 1))

	color_map.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	color_map.slot_name = ">>>  Color Map  "
	
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	#image.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	#image.force_override = true

	register_input_property(input)
	register_input_property(color_map)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_label_universal(color_map)
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_color("get_edge_color", "set_edge_color")

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#vec4 $(name_uv)_bb = $in($uv);
	var c : Color = input.get_value(uv)
	
	#mix($edgecolor, $map(fract($(name_uv)_bb.xy+0.5*$(name_uv)_bb.zw)), step(0.0000001, dot($(name_uv)_bb.zw, vec2(1.0))))
	
	var rc : Color = color_map.get_value(Commons.fractv2(Vector2(c.r, c.g) + 0.5 * Vector2(c.b, c.a)))
	var s : float = Commons.step(0.0000001, Vector2(c.b, c.a).dot(Vector2(1, 1)))
	
	return lerp(edge_color, rc, s)

#edge_color
func get_edge_color() -> Color:
	return edge_color

func set_edge_color(val : Color) -> void:
	edge_color = val

	set_dirty(true)
