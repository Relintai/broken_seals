tool
extends "res://addons/mat_maker_gd/nodes/bases/curve_base.gd"

var Curves = preload("res://addons/mat_maker_gd/nodes/common/curves.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource

func _init():
	init_points_01()

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		input.set_default_value(0)

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
	mm_graph_node.add_slot_curve()

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var f : float = input.get_value(uv)
	
	var cf : float = Curves.curve(f, points)
	
	return Color(cf, cf, cf, 1)

func _curve_changed() -> void:
	set_dirty(true)
