tool
extends MMNode

var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var output : Resource
export(float) var scale : float = 1

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
	
	mm_graph_node.add_slot_float("get_scale", "set_scale", "Scale", 0.01)

func get_property_value(uv : Vector2):
	#$in(($uv-vec2(0.5))/$s+vec2(0.5))*$s
	return output.get_value(((uv - Vector2(0.5, 0.5)) / scale + Vector2(0.5, 0.5)), true)

#scale
func get_scale() -> float:
	return scale

func set_scale(val : float) -> void:
	scale = val
	
	emit_changed()
	output.emit_changed()
	
