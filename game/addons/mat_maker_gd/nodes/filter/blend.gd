tool
extends MMNode

var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

enum BlendType {
	NORMAL = 0,
	DISSOLVE,
	MULTIPLY,
	SCREEN,
	OVERLAY,
	HARD_LIGHT,
	SOFT_LIGHT,
	BURN,
	DODGE,
	LIGHTEN,
	DARKEN,
	DIFFRENCE
}

export(Resource) var image : Resource
export(Resource) var input1 : Resource
export(Resource) var input2 : Resource
export(int, "Normal,Dissolve,Multiply,Screen,Overlay,Hard Light,Soft Light,Burn,Dodge,Lighten,Darken,Difference") var blend_type : int = 0
export(Resource) var opacity : Resource

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !input1:
		input1 = MMNodeUniversalProperty.new()
		input1.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input1.set_default_value(Color(1, 1, 1, 1))

	input1.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input1.slot_name = ">>>    Input1    "
		
	if !input2:
		input2 = MMNodeUniversalProperty.new()
		input2.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input2.set_default_value(Color(1, 1, 1, 1))
	
	input2.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input2.slot_name = ">>>    Input2    "
	
	if !opacity:
		opacity = MMNodeUniversalProperty.new()
		opacity.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		opacity.set_default_value(0.5)
		opacity.value_range = Vector2(0, 1)
		opacity.value_step = 0.01
	
	opacity.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	opacity.slot_name = "opacity"
	
	register_input_property(input1)
	register_input_property(input2)
	
	register_output_property(image)
	register_input_property(opacity)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_enum("get_blend_type", "set_blend_type", "blend_type", [ "Normal", "Dissolve", "Multiply", "Screen", "Overlay", "Hard Light", "Soft Light", "Burn", "Dodge", "Lighten", "Darken", "Difference" ])

	mm_graph_node.add_slot_label_universal(input1)
	mm_graph_node.add_slot_label_universal(input2)
	mm_graph_node.add_slot_float_universal(opacity)

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var b : Vector3 = Vector3()
	
	#vec4 $(name_uv)_s1 = $s1($uv);
	var s1 : Color = input1.get_value(uv)
	#vec4 $(name_uv)_s2 = $s2($uv);
	var s2 : Color = input2.get_value(uv)
	#float $(name_uv)_a = $amount*$a($uv);
	var a : float = opacity.get_value(uv)
	
	#vec4(blend_$blend_type($uv, $(name_uv)_s1.rgb, $(name_uv)_s2.rgb, $(name_uv)_a*$(name_uv)_s1.a), min(1.0, $(name_uv)_s2.a+$(name_uv)_a*$(name_uv)_s1.a))
	
	#"Normal,Dissolve,Multiply,Screen,Overlay,Hard Light,Soft Light,Burn,Dodge,Lighten,Darken,Difference"
	if blend_type == BlendType.NORMAL:
		b = Filter.blend_normal(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.DISSOLVE:
		b = Filter.blend_dissolve(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.MULTIPLY:
		b = Filter.blend_multiply(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.SCREEN:
		b = Filter.blend_screen(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.OVERLAY:
		b = Filter.blend_overlay(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.HARD_LIGHT:
		b = Filter.blend_hard_light(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.SOFT_LIGHT:
		b = Filter.blend_soft_light(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.BURN:
		b = Filter.blend_burn(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.DODGE:
		b = Filter.blend_dodge(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.LIGHTEN:
		b = Filter.blend_lighten(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.DARKEN:
		b = Filter.blend_darken(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)
	elif blend_type == BlendType.DIFFRENCE:
		b = Filter.blend_difference(uv, Vector3(s1.r, s1.g, s1.b), Vector3(s2.r, s2.g, s2.b), a * s1.a)

	return Color(b.x, b.y, b.z, min(1, s2.a + a * s1.a))

func get_blend_type() -> int:
	return blend_type

func set_blend_type(val : int) -> void:
	blend_type = val

	set_dirty(true)
