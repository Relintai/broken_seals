tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF3D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")

export(Resource) var input : Resource
export(Resource) var output : Resource
export(float) var length : float = 0.25

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		
	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
#	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	input.slot_name = ">>>   Input        "
	
	if !input.is_connected("changed", self, "on_input_changed"):
		input.connect("changed", self, "on_input_changed")
	
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2
		
	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	output.slot_name = ">>>   Output    >>>"
	output.get_value_from_owner = true

	register_input_property(input)
	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_label_universal(output)
	
	mm_graph_node.add_slot_float("get_length", "set_length", "Length", 0.01)

func get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	#vec2 $(name_uv)_w = vec2($in($uv.xz+vec2(0.5)),abs($uv.y)-$d);
	#ret min(max($(name_uv)_w.x,$(name_uv)_w.y),0.0)+length(max($(name_uv)_w,0.0))
	
	var f : float = input.get_value(Vector2(uv3.x, uv3.z) + Vector2(0.5, 0.5))
	var w : Vector2 = Vector2(f, abs(uv3.y) - length)
	
	var ff : float = min(max(w.x,w.y),0.0) + Commons.maxv2(w, Vector2()).length()
	
	return Vector2(ff, 0)

#length
func get_length() -> float:
	return length

func set_length(val : float) -> void:
	length = val

	emit_changed()
	output.emit_changed()

func on_input_changed() -> void:
	emit_changed()
	output.emit_changed()
