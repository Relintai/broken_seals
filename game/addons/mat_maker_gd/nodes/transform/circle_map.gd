tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Transforms = preload("res://addons/mat_maker_gd/nodes/common/transforms.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource

export(float) var radius : float = 1
export(int) var repeat : int = 1

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
	mm_graph_node.add_slot_float("get_radius", "set_radius", "Radius", 0.01)
	mm_graph_node.add_slot_int("get_repeat", "set_repeat", "Repeat")
	
func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#$in(vec2(fract($repeat*atan($uv.y-0.5, $uv.x-0.5)*0.15915494309), min(0.99999, 2.0/$radius*length($uv-vec2(0.5)))))",
	
	var nuv : Vector2 = Vector2(Commons.fractf(repeat*atan2(uv.y - 0.5, uv.x - 0.5) * 0.15915494309), min(0.99999, 2.0 / radius * (uv - Vector2(0.5, 0.5)).length()))
	
	return input.get_value(nuv)

#radius
func get_radius() -> float:
	return radius

func set_radius(val : float) -> void:
	radius = val
	
	if radius == 0:
		radius = 0.000000001

	set_dirty(true)
	
#repeat
func get_repeat() -> int:
	return repeat

func set_repeat(val : int) -> void:
	repeat = val

	set_dirty(true)
