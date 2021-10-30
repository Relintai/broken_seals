tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Fills = preload("res://addons/mat_maker_gd/nodes/common/fills.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(Color) var edge_color : Color = Color(1, 1, 1, 1)

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input    "
	
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	#image.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	#image.force_override = true

	register_input_property(input)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_color("get_edge_color", "set_edge_color")

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#vec4 $(name_uv)_bb = $in($uv);
	var c : Color = input.get_value(uv)
	
	#mix($edgecolor.rgb, rand3(vec2(float($seed), rand(vec2(rand($(name_uv)_bb.xy), rand($(name_uv)_bb.zw))))), step(0.0000001, dot($(name_uv)_bb.zw, vec2(1.0))))

	var r1 : float = Commons.rand(Vector2(c.r, c.g))
	var r2 : float = Commons.rand(Vector2(c.b, c.a))
	var s : float = Commons.step(0.0000001, Vector2(c.b, c.a).dot(Vector2(1, 1)))
	
	var f : Vector3 = lerp(Vector3(edge_color.r, edge_color.g, edge_color.b), Commons.rand3(Vector2(1.0 / float(pseed), Commons.rand(Vector2(r1, r2)))), s)
	return Color(f.x, f.y, f.z, 1)

#edge_color
func get_edge_color() -> Color:
	return edge_color

func set_edge_color(val : Color) -> void:
	edge_color = val

	set_dirty(true)
