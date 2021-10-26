tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF3D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")

export(Resource) var input : Resource
export(Resource) var output : Resource
export(int) var count : int = 5

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2
		
	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
#	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_VECTOR2
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
	
	mm_graph_node.add_slot_int("get_count", "set_count", "Count")

func get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	#todo make seed a class variable probably into MMNode
	
	var new_uv : Vector3 = SDF3D.circle_repeat_transform(uv3, count)

	return input.get_value_sdf3d(new_uv)

#count
func get_count() -> int:
	return count

func set_count(val : int) -> void:
	count = val

	emit_changed()
	output.emit_changed()

func on_input_changed() -> void:
	emit_changed()
	output.emit_changed()
