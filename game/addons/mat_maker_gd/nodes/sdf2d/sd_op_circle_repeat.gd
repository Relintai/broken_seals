tool
extends MMNode

export(Resource) var output : Resource
export(int) var count : int = 6

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
	
	mm_graph_node.add_slot_int("get_count", "set_count", "Count")

func _get_property_value(uv : Vector2):
	#$in(circle_repeat_transform_2d($uv-vec2(0.5), $c)+vec2(0.5))
	var new_uv : Vector2 = MMAlgos.circle_repeat_transform_2d(uv - Vector2(0.5, 0.5), count) + Vector2(0.5, 0.5)
	
	return output.get_value(new_uv, true)

#count
func get_count() -> int:
	return count

func set_count(val : int) -> void:
	count = val
	
	emit_changed()
	output.emit_changed()
	
