tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF3D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")

export(Resource) var output : Resource
export(int, "X,Y,Z") var axis : int = 1
export(float) var length : float = 0.25
export(float) var radius : float = 0.25

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
	
	mm_graph_node.add_slot_enum("get_axis", "set_axis", "Axis", [ "X", "Y", "Z" ])
	mm_graph_node.add_slot_float("get_length", "set_length", "Length", 0.01)
	mm_graph_node.add_slot_float("get_radius", "set_radius", "Radius", 0.01)

func get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	if axis == 0:
		return SDF3D.sdf3d_cylinder_x(uv3, radius, length)
	elif axis == 1:
		return SDF3D.sdf3d_cylinder_y(uv3, radius, length)
	elif axis == 2:
		return SDF3D.sdf3d_cylinder_z(uv3, radius, length)
		
	return Vector2()

#axis
func get_axis() -> int:
	return axis

func set_axis(val : int) -> void:
	axis = val

	emit_changed()
	output.emit_changed()
	
#length
func get_length() -> float:
	return length

func set_length(val : float) -> void:
	length = val

	emit_changed()
	output.emit_changed()

#radius
func get_radius() -> float:
	return radius

func set_radius(val : float) -> void:
	radius = val

	emit_changed()
	output.emit_changed()
