tool
extends "res://addons/mat_maker_gd/nodes/bases/gradient_base.gd"

var Gradients = preload("res://addons/mat_maker_gd/nodes/common/gradients.gd")

export(Resource) var image : Resource

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	image.force_override = true

	register_output_property(image)
	register_input_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_gradient()

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var c : Color = image.get_value(uv)
	
	return get_gradient_color(c.r)

func get_gradient_color(x : float) -> Color:
	if interpolation_type == 0:
		return Gradients.gradient_type_1(x, points)
	elif interpolation_type == 1:
		return Gradients.gradient_type_2(x, points)
	elif interpolation_type == 2:
		return Gradients.gradient_type_3(x, points)
	elif interpolation_type == 3:
		return Gradients.gradient_type_4(x, points)

	return Color(1, 1, 1, 1)
