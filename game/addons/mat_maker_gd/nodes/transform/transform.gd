tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Transforms = preload("res://addons/mat_maker_gd/nodes/common/transforms.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource

export(Resource) var translate_x : Resource
export(Resource) var translate_y : Resource
export(Resource) var rotate : Resource
export(Resource) var scale_x : Resource
export(Resource) var scale_y : Resource
export(int, "Clamp,Repeat,Extend") var mode : int = 0

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

	if !translate_x:
		translate_x = MMNodeUniversalProperty.new()
		translate_x.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		translate_x.set_default_value(0)
		translate_x.value_step = 0.01

	translate_x.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	translate_x.slot_name = "Translate X"

	if !translate_y:
		translate_y = MMNodeUniversalProperty.new()
		translate_y.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		translate_y.set_default_value(0)
		translate_y.value_step = 0.01

	translate_y.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	translate_y.slot_name = "Translate Y"

	if !rotate:
		rotate = MMNodeUniversalProperty.new()
		rotate.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		rotate.set_default_value(0)
		rotate.value_step = 0.01

	rotate.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	rotate.slot_name = "Rotate"
	
	if !scale_x:
		scale_x = MMNodeUniversalProperty.new()
		scale_x.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		scale_x.set_default_value(1)
		scale_x.value_step = 0.01

	scale_x.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	scale_x.slot_name = "Scale X"
	
	if !scale_y:
		scale_y = MMNodeUniversalProperty.new()
		scale_y.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		scale_y.set_default_value(1)
		scale_y.value_step = 0.01

	scale_y.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	scale_y.slot_name = "Scale Y"

	register_input_property(input)
	register_output_property(image)
	register_input_property(translate_x)
	register_input_property(translate_y)
	register_input_property(rotate)
	register_input_property(scale_x)
	register_input_property(scale_y)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_texture_universal(image)
	
	mm_graph_node.add_slot_float_universal(translate_x)
	mm_graph_node.add_slot_float_universal(translate_y)
	mm_graph_node.add_slot_float_universal(rotate)
	mm_graph_node.add_slot_float_universal(scale_x)
	mm_graph_node.add_slot_float_universal(scale_y)

	mm_graph_node.add_slot_enum("get_mode", "set_mode", "Mode", [ "Clamp", "Repeat", "Extend" ])

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#$i($mode(transform2($uv, vec2($translate_x*(2.0*$tx($uv)-1.0), $translate_y*(2.0*$ty($uv)-1.0)), $rotate*0.01745329251*(2.0*$r($uv)-1.0), vec2($scale_x*(2.0*$sx($uv)-1.0), $scale_y*(2.0*$sy($uv)-1.0)))))",
	
	#Mode:
	#Clamp -> transform2_clamp
	#Repeat -> fract
	#Extend -> ""

	var tr : Vector2 = Vector2(translate_x.get_default_value() * (2.0 * translate_x.get_value_or_zero(uv) - 1.0), translate_y.get_default_value() *(2.0 * translate_y.get_value_or_zero(uv) - 1.0))
	var rot : float = rotate.get_default_value() * 0.01745329251*(2.0 * rotate.get_value_or_zero(uv) - 1.0)
	var sc : Vector2 = Vector2(scale_x.get_default_value() *(2.0 * scale_x.get_value_or_zero(uv) - 1.0), scale_y.get_default_value() *(2.0 * scale_y.get_value_or_zero(uv) - 1.0))
	
	var nuv : Vector2 = Transforms.transform2(uv, tr, rot, sc)
	
	if mode == 0:
		nuv = Transforms.transform2_clamp(nuv)
	elif mode == 1:
		nuv = Commons.fractv2(nuv)
	
	return input.get_value(nuv)

#mode
func get_mode() -> int:
	return mode

func set_mode(val : int) -> void:
	mode = val

	set_dirty(true)
