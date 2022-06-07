tool
extends MMNode

export(Resource) var input : Resource
export(Resource) var output : Resource
export(Vector3) var rotation : Vector3 = Vector3()

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_VECTOR2
		
	input.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_UNIVERSAL
#	input.input_slot_type = MMNodeUniversalProperty.SLOT_TYPE_VECTOR2
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
	
	mm_graph_node.add_slot_vector3("get_rotation", "set_rotation", "Rotation", 0.01)

func _get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	#$in(rotate3d($uv, -vec3($ax, $ay, $az)*0.01745329251))

	return input.get_value_sdf3d(MMAlgos.rotate3d(uv3, -rotation * 0.01745329251))

#rotation
func get_rotation() -> Vector3:
	return rotation

func set_rotation(val : Vector3) -> void:
	rotation = val

	emit_changed()
	output.emit_changed()

func on_input_changed() -> void:
	emit_changed()
	output.emit_changed()
