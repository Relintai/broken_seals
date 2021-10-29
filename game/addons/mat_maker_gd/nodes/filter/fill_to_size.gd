tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Fills = preload("res://addons/mat_maker_gd/nodes/common/fills.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(int, "Area,Width,Height,Max(W,H)") var formula : int = 0

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
	mm_graph_node.add_slot_enum("get_formula", "set_formula", "Formula", [ "Area", "Width", "Height", "Max(W,H)" ])

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#vec4 $(name_uv)_bb = $in($uv);
	var c : Color = input.get_value(uv)
	
	var f : float = 0

	#"Area" sqrt($(name_uv)_bb.z*$(name_uv)_bb.w)
	#"Width" $(name_uv)_bb.z
	#"Height" $(name_uv)_bb.w
	#"max(W, H)" max($(name_uv)_bb.z, $(name_uv)_bb.w)

	if formula == 0:
		f = sqrt(c.b * c.a)
	elif formula == 1:
		f = c.b
	elif formula == 2:
		f = c.a
	elif formula == 3:
		f = max(c.b, c.a)

	return Color(f, f, f, 1)

#formula
func get_formula() -> int:
	return formula

func set_formula(val : int) -> void:
	formula = val

	set_dirty(true)
