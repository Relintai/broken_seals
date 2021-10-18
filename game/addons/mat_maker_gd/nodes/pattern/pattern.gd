tool
extends MMNode

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

export(Resource) var image : Resource
export(int, "Multiply,Add,Max,Min,Xor,Pow") var combiner_type : int = 0
export(int, "Sine,Triangle,Square,Sawtooth,Constant,Bounce") var combiner_axis_type_x : int = 0
export(int, "Sine,Triangle,Square,Sawtooth,Constant,Bounce") var combiner_axis_type_y : int = 0
export(Vector2) var repeat : Vector2 = Vector2(4, 4)

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_enum("get_combiner_type", "set_combiner_type", "Combiner Type", [ "Multiply", "Add" , "Max", "Min", "Xor", "Pow" ])
	mm_graph_node.add_slot_enum("get_combiner_axis_type_x", "set_combiner_axis_type_x", "Combiner Axis type", [ "Sine", "Triangle", "Square", "Sawtooth", "Constant", "Bounce" ])
	mm_graph_node.add_slot_enum("get_combiner_axis_type_y", "set_combiner_axis_type_y", "", [ "Sine", "Triangle", "Square", "Sawtooth", "Constant", "Bounce" ])
	mm_graph_node.add_slot_vector2("get_repeat", "set_repeat", "Repeat", 1)#, Vector2(0, 32))

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var f : float = Patterns.pattern(uv, repeat.x, repeat.y, combiner_type, combiner_axis_type_x, combiner_axis_type_y)

	return Color(f, f, f, 1)

#combiner_type
func get_combiner_type() -> int:
	return combiner_type

func set_combiner_type(val : int) -> void:
	combiner_type = val

	set_dirty(true)

#combiner_axis_type_x
func get_combiner_axis_type_x() -> int:
	return combiner_axis_type_x

func set_combiner_axis_type_x(val : int) -> void:
	combiner_axis_type_x = val

	set_dirty(true)

#combiner_axis_type_y
func get_combiner_axis_type_y() -> int:
	return combiner_axis_type_y

func set_combiner_axis_type_y(val : int) -> void:
	combiner_axis_type_y = val

	set_dirty(true)
	
#repeat
func get_repeat() -> Vector2:
	return repeat

func set_repeat(val : Vector2) -> void:
	repeat = val

	set_dirty(true)
