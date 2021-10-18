tool
extends MMNode

export(Resource) var uniform : Resource

func _init_properties():
	if !uniform:
		uniform = MMNodeUniversalProperty.new()
		uniform.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		uniform.set_default_value(Color(1, 1, 1, 1))
		
	uniform.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_COLOR

	register_output_property(uniform)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_color_universal(uniform)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return uniform.get_value(uv)
