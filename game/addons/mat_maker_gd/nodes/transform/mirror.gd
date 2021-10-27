tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Transforms = preload("res://addons/mat_maker_gd/nodes/common/transforms.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(int, "Horizontal,Vertical") var direction : int = 0
export(float) var offset : float = 0

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
	mm_graph_node.add_slot_enum("get_direction", "set_direction", "Direction", [ "Horizontal", "Vertical" ])
	mm_graph_node.add_slot_float("get_offset", "set_offset", "offset", 0.01)

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#$i(uvmirror_$direction($uv, $offset))

	if direction == 0:
		return input.get_value(Transforms.uvmirror_h(uv, offset))
	elif direction == 1:
		return input.get_value(Transforms.uvmirror_v(uv, offset))
		
	return Color(0, 0, 0, 1)

#direction
func get_direction() -> int:
	return direction

func set_direction(val : int) -> void:
	direction = val

	set_dirty(true)

#offset
func get_offset() -> float:
	return offset

func set_offset(val : float) -> void:
	offset = val

	set_dirty(true)
