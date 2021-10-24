tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(Resource) var value : Resource
export(int, "R,G,B,A") var channel : int = 3

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color())

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input1    "
	
	if !value:
		value = MMNodeUniversalProperty.new()
		value.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		value.set_default_value(1)

	value.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	value.value_step = 0.01
	value.value_range = Vector2(0, 1)
	
	register_input_property(input)
	register_output_property(image)
	register_input_property(value)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_float_universal(value)
	mm_graph_node.add_slot_enum("get_channel", "set_channel", "Channel", [ "R", "G", "B", "A" ])


func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var col : Color = input.get_value(uv)
	
	if channel == 0:
		col.r = value.get_value(uv)
	if channel == 1:
		col.g = value.get_value(uv)
	if channel == 2:
		col.b = value.get_value(uv)
	if channel == 3:
		col.a = value.get_value(uv)
	
	return col

func get_channel() -> int:
	return channel

func set_channel(val : int) -> void:
	channel = val

	set_dirty(true)
