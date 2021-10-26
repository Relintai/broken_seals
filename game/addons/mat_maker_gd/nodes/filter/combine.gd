tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input_r : Resource
export(Resource) var input_g : Resource
export(Resource) var input_b : Resource
export(Resource) var input_a : Resource

func _init_properties():
	if !input_r:
		input_r = MMNodeUniversalProperty.new()
		input_r.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		input_r.set_default_value(0)

	input_r.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input_r.slot_name = ">>>    R    "
	
	if !input_g:
		input_g = MMNodeUniversalProperty.new()
		input_g.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		input_g.set_default_value(0)

	input_g.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input_g.slot_name = ">>>    G    "
	
	if !input_b:
		input_b = MMNodeUniversalProperty.new()
		input_b.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		input_b.set_default_value(0)

	input_b.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input_b.slot_name = ">>>    B    "
	
	if !input_a:
		input_a = MMNodeUniversalProperty.new()
		input_a.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		input_a.set_default_value(1)

	input_a.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input_a.slot_name = ">>>    A    "
	
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	#image.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	#image.force_override = true

	register_input_property(input_r)
	register_input_property(input_g)
	register_input_property(input_b)
	register_input_property(input_a)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input_r)
	mm_graph_node.add_slot_label_universal(input_g)
	mm_graph_node.add_slot_label_universal(input_b)
	mm_graph_node.add_slot_label_universal(input_a)
	mm_graph_node.add_slot_texture_universal(image)

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var r : float = input_r.get_value(uv)
	var g : float = input_g.get_value(uv)
	var b : float = input_b.get_value(uv)
	var a : float = input_a.get_value(uv)
	
	return Color(r, g, b, a)
