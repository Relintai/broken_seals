tool
extends "res://addons/mat_maker_gd/nodes/bases/gradient_base.gd"

var Gradients = preload("res://addons/mat_maker_gd/nodes/common/gradients.gd")

export(Resource) var image : Resource
export(float) var repeat : float = 1

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_float("get_repeat", "set_repeat", "repeat")
	mm_graph_node.add_slot_gradient()

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	if interpolation_type == 0:
		return Gradients.circular_gradient_type_1(uv, repeat, points)
	elif interpolation_type == 1:
		return Gradients.circular_gradient_type_2(uv, repeat, points)
	elif interpolation_type == 2:
		return Gradients.circular_gradient_type_3(uv, repeat, points)
	elif interpolation_type == 3:
		return Gradients.circular_gradient_type_4(uv, repeat, points)

	return Color(1, 1, 1, 1)
	

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

func get_repeat() -> float:
	return repeat

func set_repeat(val : float) -> void:
	repeat = val

	set_dirty(true)

