tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(int, "0,1,R,-R,G,-G,B,-B,A,-A") var op_r : int = 2
export(int, "0,1,R,-R,G,-G,B,-B,A,-A") var op_g : int = 4
export(int, "0,1,R,-R,G,-G,B,-B,A,-A") var op_b : int = 6
export(int, "0,1,R,-R,G,-G,B,-B,A,-A") var op_a : int = 8

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
	
	mm_graph_node.add_slot_enum("get_op_r", "set_op_r", "R", [ "0", "1", "R", "-R", "G", "-G", "B", "-B", "A","-A" ])
	mm_graph_node.add_slot_enum("get_op_g", "set_op_g", "G", [ "0", "1", "R", "-R", "G", "-G", "B", "-B", "A","-A" ])
	mm_graph_node.add_slot_enum("get_op_b", "set_op_b", "B", [ "0", "1", "R", "-R", "G", "-G", "B", "-B", "A","-A" ])
	mm_graph_node.add_slot_enum("get_op_a", "set_op_a", "A", [ "0", "1", "R", "-R", "G", "-G", "B", "-B", "A","-A" ])

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func apply(op : int, val : Color) -> float:
	if op == 0:
		return 0.0
	elif op == 1:
		return 1.0
	elif op == 2:
		return val.r
	elif op == 3:
		return 1.0 - val.r
	elif op == 4:
		return val.g
	elif op == 5:
		return 1.0 - val.g
	elif op == 6:
		return val.b
	elif op == 7:
		return 1.0 - val.b
	elif op == 8:
		return val.a
	elif op == 9:
		return 1.0 - val.a
		
	return 0.0

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var c : Color = input.get_value(uv)
	
	return Color(apply(op_r, c), apply(op_g, c), apply(op_b, c), apply(op_a, c))

#op_r
func get_op_r() -> int:
	return op_r

func set_op_r(val : int) -> void:
	op_r = val

	set_dirty(true)

#op_g
func get_op_g() -> int:
	return op_g

func set_op_g(val : int) -> void:
	op_g = val

	set_dirty(true)
	
#op_b
func get_op_b() -> int:
	return op_b

func set_op_b(val : int) -> void:
	op_b = val

	set_dirty(true)
	
#op_a
func get_op_a() -> int:
	return op_a

func set_op_a(val : int) -> void:
	op_a = val

	set_dirty(true)
