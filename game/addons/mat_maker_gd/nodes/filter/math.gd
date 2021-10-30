tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Fills = preload("res://addons/mat_maker_gd/nodes/common/fills.gd")

export(Resource) var image : Resource
export(Resource) var a : Resource
export(Resource) var b : Resource
export(Resource) var output : Resource

export(int, "A+B,A-B,A*B,A/B,log(A),log2(A),pow(A; B),abs(A),round(A),floor(A),ceil(A),trunc(A),fract(A),min(A; B),max(A; B),A<B,cos(A*B),sin(A*B),tan(A*B),sqrt(1-A*A)") var operation : int = 0
export(bool) var clamp_result : bool = false

func _init_properties():
	if !a:
		a = MMNodeUniversalProperty.new()
		a.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		a.set_default_value(0)

	a.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	a.slot_name = ">>>    A    "
	a.value_step = 0.01
	a.value_range = Vector2(0, 1)
	
	if !b:
		b = MMNodeUniversalProperty.new()
		b.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		b.set_default_value(0)

	b.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	b.slot_name = ">>>    B    "
	b.value_step = 0.01
	b.value_range = Vector2(0, 1)
	

	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	#image.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	#image.force_override = true

	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		output.set_default_value(0)

	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	output.slot_name = "     Output    >>>"
	output.get_value_from_owner = true

	register_input_property(a)
	register_input_property(b)
	register_output_property(output)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(a)
	mm_graph_node.add_slot_label_universal(b)
	mm_graph_node.add_slot_label_universal(output)
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_enum("get_operation", "set_operation", "Operation", [ "A+B", "A-B", "A*B", "A/B", "log(A)", "log2(A)", "pow(A, B)", "abs(A)", "round(A)", "floor(A)", "ceil(A)", "trunc(A)", "fract(A)", "min(A, B)", "max(A, B)", "A<B", "cos(A*B)", "sin(A*B)", "tan(A*B)", "sqrt(1-A*A)" ])
	mm_graph_node.add_slot_bool("get_clamp_result", "set_clamp_result", "Clamp result")

func get_property_value(uv : Vector2) -> float:
	var af : float = a.get_value(uv)
	var bf : float = b.get_value(uv)
	
	var f : float = 0
	
	if operation == 0:#"A+B",
		f = af + bf
	elif operation == 1:#"A-B", 
		f = af - bf
	elif operation == 2:#"A*B", 
		f = af * bf
	elif operation == 3:#"A/B",
		if bf == 0:
			bf = 0.000001
		f = af / bf
	elif operation == 4:#"log(A)", 
		#todo needs to be implemented
		f = log(af)
	elif operation == 5:#"log2(A)", 
		#todo needs to be implemented
		f = log(af)
	elif operation == 6:#"pow(A, B)", 
		f = pow(af, bf)
	elif operation == 7:#"abs(A)", 
		f = abs(af)
	elif operation == 8:#"round(A)", 
		f = round(af)
	elif operation == 9:#"floor(A)", 
		f = floor(af)
	elif operation == 10:#"ceil(A)", 
		f = ceil(af)
	elif operation == 11:#"trunc(A)", 
		f = int(af)
	elif operation == 12:#"fract(A)", 
		f = Commons.fractf(af)
	elif operation == 13:#"min(A, B)", 
		f = min(af, bf)
	elif operation == 14:#"max(A, B)", 
		f = max(af, bf)
	elif operation == 15:#"A<B", 
		f = af < bf
	elif operation == 16:#"cos(A*B)", 
		f = cos(af * bf)
	elif operation == 17:#"sin(A*B)", 
		f = sin(af * bf)
	elif operation == 18:#"tan(A*B)", 
		f = tan(af * bf)
	elif operation == 19:#"sqrt(1-A*A)"
		f = sqrt(1 - af * af)

	if clamp_result:
		f = clamp(f, 0, 1)
		
	return f

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var f : float = get_property_value(uv)

	return Color(f, f, f, 1)

#operation
func get_operation() -> int:
	return operation

func set_operation(val : int) -> void:
	operation = val

	set_dirty(true)
	output.emit_changed()

#clamp_result
func get_clamp_result() -> bool:
	return clamp_result

func set_clamp_result(val : bool) -> void:
	clamp_result = val

	set_dirty(true)
	output.emit_changed()
