tool
extends MMNode

var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var output : Resource
export(float) var angle : float = 0

func _init_properties():
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		
	output.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	#output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	output.slot_name = ">>>    Apply    >>>"
	output.get_value_from_owner = true

	register_input_property(output)
	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(output)
	
	mm_graph_node.add_slot_float("get_angle", "set_angle", "Angle", 1)

func get_property_value(uv : Vector2):
	#$in(sdf2d_rotate($uv, $a*0.01745329251))",
	return output.get_value(SDF2D.sdf2d_rotate(uv, angle * 0.01745329251), true)

#angle
func get_angle() -> float:
	return angle

func set_angle(val : float) -> void:
	angle = val
	
	emit_changed()
	output.emit_changed()
	
