tool
extends MMNode

export(Resource) var output : Resource
export(float) var radius : float = 0

func _init_properties():
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_FLOAT
		
	output.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_UNIVERSAL
	output.output_slot_type = MMNodeUniversalProperty.SLOT_TYPE_UNIVERSAL
	#output.output_slot_type = MMNodeUniversalProperty.SLOT_TYPE_FLOAT
	output.slot_name = ">>>    Apply    >>>"
	output.get_value_from_owner = true

	register_input_property(output)
	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(output)
	
	mm_graph_node.add_slot_float("get_radius", "set_radius", "Radius", 0.01)

func _get_property_value(uv : Vector2):
	var val : float = output.get_value(uv, true)
	
	return MMAlgos.sdf_rounded_shape(val, radius)

#radius
func get_radius() -> float:
	return radius

func set_radius(val : float) -> void:
	radius = val
	
	emit_changed()
	output.emit_changed()
	
