tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(int) var steps : int = 4

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
	mm_graph_node.add_slot_int("get_steps", "set_steps", "Steps")

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var c : Color = input.get_value(uv)

	#vec4(floor($in($uv).rgb*$steps)/$steps, $in($uv).a)
	var v : Vector3 = Commons.floorv3(Vector3(c.r, c.g, c.b) * steps) / float(steps)
	
	return Color(v.x, v.y, v.z, c.a)

#steps
func get_steps() -> int:
	return steps

func set_steps(val : int) -> void:
	steps = val

	set_dirty(true)
