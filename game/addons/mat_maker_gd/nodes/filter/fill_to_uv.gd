tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Fills = preload("res://addons/mat_maker_gd/nodes/common/fills.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(int, "Stretch,Square") var mode : int = 0

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
	mm_graph_node.add_slot_enum("get_mode", "set_mode", "Mode", [ "Stretch", "Square" ])

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#vec4 $(name_uv)_bb = $in($uv);
	var c : Color = input.get_value(uv)
	
	#fill_to_uv_$mode($uv, $(name_uv)_bb, float($seed))
	var r : Vector3 = Vector3()

	if mode == 0:
		r = Fills.fill_to_uv_stretch(uv, c, float(pseed))
	elif mode == 1:
		r = Fills.fill_to_uv_square(uv, c, float(pseed))

	return Color(r.x, r.y, r.z, 1)

#mode
func get_mode() -> int:
	return mode

func set_mode(val : int) -> void:
	mode = val

	set_dirty(true)
