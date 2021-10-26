tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF3D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")

export(Resource) var input : Resource
export(Resource) var output : Resource
export(Vector2) var col_row : Vector2 = Vector2(3, 3)
export(float) var rotation : float = 0.3

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2
		
	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
#	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR2
	input.slot_name = ">>>   Input        "
	
	if !input.is_connected("changed", self, "on_input_changed"):
		input.connect("changed", self, "on_input_changed")
	
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2
		
	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	output.slot_name = ">>>   Output    >>>"
	output.get_value_from_owner = true

	register_input_property(input)
	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_label_universal(output)
	
	mm_graph_node.add_slot_vector2("get_col_row", "set_col_row", "Col,Row", 1)
	mm_graph_node.add_slot_float("get_rotation", "set_rotation", "Rotation", 0.01)

func get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	#todo make seed a class variable probably into MMNode
	
	var new_uv : Vector3 = SDF3D.sdf3d_repeat(uv3, col_row, rotation, 1)

	return input.get_value_sdf3d(new_uv)

#col_row
func get_col_row() -> Vector2:
	return col_row

func set_col_row(val : Vector2) -> void:
	col_row = val

	emit_changed()
	output.emit_changed()

#rotation
func get_rotation() -> float:
	return rotation

func set_rotation(val : float) -> void:
	rotation = val

	emit_changed()
	output.emit_changed()

func on_input_changed() -> void:
	emit_changed()
	output.emit_changed()
