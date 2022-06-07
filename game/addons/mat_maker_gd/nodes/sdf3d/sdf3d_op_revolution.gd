tool
extends MMNode

export(Resource) var input : Resource
export(Resource) var output : Resource
export(float) var offset : float = 0.25

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_FLOAT
		
	input.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_UNIVERSAL
#	input.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_FLOAT
	input.slot_name = ">>>   Input        "
	
	if !input.is_connected("changed", self, "on_input_changed"):
		input.connect("changed", self, "on_input_changed")
	
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_VECTOR2
		
	output.output_slot_type = MMNodeUniversalProperty.SLOT_TYPE_FLOAT
	output.slot_name = ">>>   Output    >>>"
	output.get_value_from_owner = true

	register_input_property(input)
	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_label_universal(output)
	
	mm_graph_node.add_slot_float("get_offset", "set_offset", "Offset", 0.01)

func _get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	#vec2 $(name_uv)_q = vec2(length($uv.xy) - $d + 0.5, $uv.z + 0.5);
	
	var uv : Vector2 = Vector2(Vector2(uv3.x, uv3.y).length() - offset + 0.5, uv3.z + 0.5)
	var f : float = input.get_value(uv)
	
	return Vector2(f, 0)

#offset
func get_offset() -> float:
	return offset

func set_offset(val : float) -> void:
	offset = val

	emit_changed()
	output.emit_changed()

func on_input_changed() -> void:
	emit_changed()
	output.emit_changed()
