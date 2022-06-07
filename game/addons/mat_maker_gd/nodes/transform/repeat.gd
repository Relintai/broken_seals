tool
extends MMNode

export(Resource) var input : Resource

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

	input.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Apply    >>>"
	#input.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_COLOR
	input.output_slot_type = MMNodeUniversalProperty.SLOT_TYPE_UNIVERSAL
	input.get_value_from_owner = true
	
	register_input_property(input)
	register_output_property(input)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)

func _get_property_value(uv : Vector2):
	return input.get_value(MMAlgos.fractv2(uv), true)
