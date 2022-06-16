tool
extends PolygonBase

export(Resource) var output : Resource

func _init_properties():
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.DEFAULT_TYPE_FLOAT
		
	output.output_slot_type = MMNodeUniversalProperty.SLOT_TYPE_FLOAT
	output.slot_name = ">>>   Output    >>>"
	output.get_value_from_owner = true

	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(output)
	mm_graph_node.add_slot_polygon()

func _get_property_value(uv : Vector2) -> float:
	return MMAlgos.sdPolygon(uv, points)

func _polygon_changed() -> void:
	emit_changed()
	output.emit_changed()
