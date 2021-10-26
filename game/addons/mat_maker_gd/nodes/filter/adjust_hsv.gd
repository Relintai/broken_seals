tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(float) var hue : float = 0
export(float) var saturation : float = 1
export(float) var value : float = 1

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input1    "
	
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
	mm_graph_node.add_slot_float("get_hue", "set_hue", "Hue", 0.01)
	mm_graph_node.add_slot_float("get_saturation", "set_saturation", "Saturation", 0.01)
	mm_graph_node.add_slot_float("get_value", "set_value", "Value", 0.01)

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var c : Color = input.get_value(uv)
	
	return Filter.adjust_hsv(c, hue, saturation, value)

#hue
func get_hue() -> float:
	return hue

func set_hue(val : float) -> void:
	hue = val

	set_dirty(true)

#saturation
func get_saturation() -> float:
	return saturation

func set_saturation(val : float) -> void:
	saturation = val

	set_dirty(true)

#value
func get_value() -> float:
	return value

func set_value(val : float) -> void:
	value = val

	set_dirty(true)
