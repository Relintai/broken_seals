tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(int, "Lightness,Average,Luminosity,Min,Max") var type : int = 2

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
	mm_graph_node.add_slot_enum("get_type", "set_type", "Type", [ "Lightness", "Average", "Luminosity", "Min", "Max" ])

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var c : Color = input.get_value(uv)
	
	var f : float = 0
	
	if type == 0:
		f = Filter.grayscale_lightness(Vector3(c.r, c.g, c.b))
	elif type == 1:
		f = Filter.grayscale_average(Vector3(c.r, c.g, c.b))
	elif type == 2:
		f = Filter.grayscale_luminosity(Vector3(c.r, c.g, c.b))
	elif type == 3:
		f = Filter.grayscale_min(Vector3(c.r, c.g, c.b))
	elif type == 4:
		f = Filter.grayscale_max(Vector3(c.r, c.g, c.b))
	
	return Color(f, f, f, c.a)

#type
func get_type() -> int:
	return type

func set_type(val : int) -> void:
	type = val

	set_dirty(true)
