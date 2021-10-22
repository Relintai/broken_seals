tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF3D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")

export(Resource) var output : Resource
export(float) var radius : float = 0.5

func _init_properties():
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2
		
	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	output.slot_name = ">>>   Output    >>>"
	output.get_value_from_owner = true

	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(output)
	
	mm_graph_node.add_slot_float("get_radius", "set_radius", "Radius", 0.01)

func get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	return SDF3D.sdf3d_sphere(uv3, radius)

#radius
func get_radius() -> float:
	return radius

func set_radius(val : float) -> void:
	radius = val

	emit_changed()
	output.emit_changed()
