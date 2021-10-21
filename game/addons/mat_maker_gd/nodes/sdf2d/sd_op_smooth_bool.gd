tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var input1 : Resource
export(Resource) var input2 : Resource
export(Resource) var output : Resource
export(int, "Union,Substraction,Intersection") var operation : int = 0
export(float) var smoothness : float = 0.15

func _init_properties():
	if !input1:
		input1 = MMNodeUniversalProperty.new()
		input1.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		
	input1.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
#	input1.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	input1.slot_name = ">>>   Input 1       "
	if !input1.is_connected("changed", self, "on_input_changed"):
		input1.connect("changed", self, "on_input_changed")
	
	if !input2:
		input2 = MMNodeUniversalProperty.new()
		input2.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		
	input2.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
#	input2.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	input2.slot_name = ">>>   Input 2       "
	
	if !input2.is_connected("changed", self, "on_input_changed"):
		input2.connect("changed", self, "on_input_changed")

	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		
	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
#	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	output.slot_name = "       Output    >>>"
	output.get_value_from_owner = true
	
	register_input_property(input1)
	register_input_property(input2)
	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input1)
	mm_graph_node.add_slot_label_universal(input2)
	mm_graph_node.add_slot_label_universal(output)

	mm_graph_node.add_slot_enum("get_operation", "set_operation", "Operation", [ "Union", "Substraction", "Intersection" ])
	mm_graph_node.add_slot_float("get_smoothness", "set_smoothness", "Smoothness", 0.01)

func get_property_value(uv : Vector2) -> float:
	if operation == 0:
		return SDF2D.sdf_smooth_boolean_union(input1.get_value(uv), input2.get_value(uv), smoothness)
	elif operation == 1:
		return SDF2D.sdf_smooth_boolean_substraction(input1.get_value(uv), input2.get_value(uv), smoothness)
	elif operation == 2:
		return SDF2D.sdf_smooth_boolean_intersection(input1.get_value(uv), input2.get_value(uv), smoothness)
	
	return 0.0

#operation
func get_operation() -> int:
	return operation

func set_operation(val : int) -> void:
	operation = val
	
	emit_changed()
	output.emit_changed()

#smoothness
func get_smoothness() -> float:
	return smoothness

func set_smoothness(val : float) -> void:
	smoothness = val
	
	emit_changed()
	output.emit_changed()

func on_input_changed() -> void:
	emit_changed()
	output.emit_changed()
