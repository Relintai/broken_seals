tool
extends MMNode

export(Resource) var uniform : Resource

func _init_properties():
	if !uniform:
		uniform = MMNodeUniversalProperty.new()
		uniform.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		uniform.set_default_value(0.5)
		uniform.slot_name = "Value (Color)"
		uniform.value_step = 0.01
		uniform.value_range = Vector2(0, 1)
		
	uniform.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_COLOR

	register_output_property(uniform)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_float_universal(uniform)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var f : float = uniform.get_value(uv)
	
	return Color(f, f, f, 1)
