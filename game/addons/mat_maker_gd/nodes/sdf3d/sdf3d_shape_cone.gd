tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF3D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")

export(Resource) var output : Resource
export(int, "+X,-X,+Y,-Y,+Z,-Z") var axis : int = 2
export(float) var angle : float = 30

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
	
	mm_graph_node.add_slot_enum("get_axis", "set_axis", "Axis", [ "+X", "-X", "+Y", "-Y", "+Z", "-Z" ])
	mm_graph_node.add_slot_float("get_angle", "set_angle", "Angle", 1)

func get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	if axis == 0:
		return SDF3D.sdf3d_cone_px(uv3, angle)
	elif axis == 1:
		return SDF3D.sdf3d_cone_nx(uv3, angle)
	elif axis == 2:
		return SDF3D.sdf3d_cone_py(uv3, angle)
	elif axis == 3:
		return SDF3D.sdf3d_cone_ny(uv3, angle)
	elif axis == 4:
		return SDF3D.sdf3d_cone_pz(uv3, angle)
	elif axis == 5:
		return SDF3D.sdf3d_cone_nz(uv3, angle)
		
	return Vector2()

#axis
func get_axis() -> int:
	return axis

func set_axis(val : int) -> void:
	axis = val

	emit_changed()
	output.emit_changed()
	
#angle
func get_angle() -> float:
	return angle

func set_angle(val : float) -> void:
	angle = val

	emit_changed()
	output.emit_changed()

