tool
extends MMNode

export(Resource) var output : Resource
export(Vector2) var translation : Vector2 = Vector2(0, 0)

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
	
	mm_graph_node.add_slot_vector2("get_translation", "set_translation", "Translation", 0.01)

func get_property_value(uv : Vector2):
	return output.get_value(uv - translation, true)

#a
func get_translation() -> Vector2:
	return translation

func set_translation(val : Vector2) -> void:
	translation = val
	
	emit_changed()
	output.emit_changed()
	
