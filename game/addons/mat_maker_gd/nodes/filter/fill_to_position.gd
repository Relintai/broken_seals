tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Transforms = preload("res://addons/mat_maker_gd/nodes/common/transforms.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(int, "X,Y,Radial") var axis : int = 2

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
	mm_graph_node.add_slot_enum("get_axis", "set_axis", "Axis", [ "X", "Y", "Radial" ])

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var c : Color = input.get_value(uv)
	#vec2 $(name_uv)_c = fract($in($uv).xy+0.5*$in($uv).zw);
	var cnv : Vector2 = Commons.fractv2(Vector2(c.r, c.g) + 0.5 * Vector2(c.b, c.a))

	#X, $(name_uv)_c.x
	#Y, $(name_uv)_c.y
	#Radial, length($(name_uv)_c-vec2(0.5))

	if axis == 0:
		return Color(cnv.x, cnv.x, cnv.x, 1)
	elif axis == 1:
		return Color(cnv.y, cnv.y, cnv.y, 1)
	elif axis == 2:
		var f : float = (cnv - Vector2(0.5, 0.5)).length()
		
		return Color(f, f, f, 1)
		
	return Color(0, 0, 0, 1)

#axis
func get_axis() -> int:
	return axis

func set_axis(val : int) -> void:
	axis = val

	set_dirty(true)
