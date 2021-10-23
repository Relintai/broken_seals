tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(float) var width : float = 0.1

var size : int = 0

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color())

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input1    "
	
	register_input_property(input)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_label_universal(input)

	mm_graph_node.add_slot_float("get_width", "set_width", "Width", 0.01)


func _render(material) -> void:
	size = max(material.image_size.x, material.image_size.y)
	
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#make_tileable_$(name)($uv, 0.5*$w)
	return make_tileable(uv, 0.5 * width)

func get_width() -> float:
	return width

func set_width(val : float) -> void:
	width = val

	set_dirty(true)


#----------------------
#make_tileable.mmg

#vec4 make_tileable_$(name)(vec2 uv, float w) {
#	vec4 a = $in(uv);
#	vec4 b = $in(fract(uv+vec2(0.5)));
#	float coef_ab = sin(1.57079632679*clamp((length(uv-vec2(0.5))-0.5+w)/w, 0.0, 1.0));
#	vec4 c = $in(fract(uv+vec2(0.25)));
#	float coef_abc = sin(1.57079632679*clamp((min(min(length(uv-vec2(0.0, 0.5)), length(uv-vec2(0.5, 0.0))), min(length(uv-vec2(1.0, 0.5)), length(uv-vec2(0.5, 1.0))))-w)/w, 0.0, 1.0));
#	return mix(c, mix(a, b, coef_ab), coef_abc);
#}

func make_tileable(uv : Vector2, w : float) -> Color:
	var a: Color = input.get_value(uv);
	var b : Color = input.get_value(Commons.fractv2(uv + Vector2(0.5, 0.5)));
	var coef_ab : float = sin(1.57079632679 * clamp(((uv - Vector2(0.5, 0.5)).length() - 0.5 + w) / w, 0.0, 1.0));
	var c: Color = input.get_value(Commons.fractv2(uv + Vector2(0.25, 0.25)));
	var coef_abc : float = sin(1.57079632679 * clamp((min(min((uv - Vector2(0.0, 0.5)).length(), (uv - Vector2(0.5, 0.0)).length()), min((uv- Vector2(1.0, 0.5)).length(), (uv - Vector2(0.5, 1.0)).length())) - w) / w, 0.0, 1.0));
	
	return lerp(c, lerp(a, b, coef_ab), coef_abc)

