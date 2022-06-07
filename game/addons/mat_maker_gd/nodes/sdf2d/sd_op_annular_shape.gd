tool
extends MMNode

export(Resource) var output : Resource
export(float) var width : float = 0.1
export(int) var ripples : int = 1

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
	
	mm_graph_node.add_slot_float("get_width", "set_width", "Width", 0.01)
	mm_graph_node.add_slot_int("get_ripples", "set_ripples", "Ripples")

func _get_property_value(uv : Vector2):
	var val : float = output.get_value(uv, true)
	
	return MMAlgos.sdRipples(val, width, ripples)

#width
func get_width() -> float:
	return width

func set_width(val : float) -> void:
	width = val
	
	emit_changed()
	output.emit_changed()
	
#ripples
func get_ripples() -> int:
	return ripples

func set_ripples(val : int) -> void:
	ripples = val
	
	emit_changed()
	output.emit_changed()
