tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF3D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")

export(Resource) var output : Resource
export(int, "X,Y,Z") var axis : int = 2
export(float) var major_radius : float = 0.3
export(float) var minor_radius : float = 0.15

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
	mm_graph_node.add_slot_float("get_major_radius", "set_major_radius", "Major_radius", 0.01)
	mm_graph_node.add_slot_float("get_minor_radius", "set_minor_radius", "Minor_radius", 0.01)

func get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	if axis == 0:
		return SDF3D.sdf3d_torus_x(uv3, major_radius, minor_radius)
	elif axis == 1:
		return SDF3D.sdf3d_torus_y(uv3, major_radius, minor_radius)
	elif axis == 2:
		return SDF3D.sdf3d_torus_z(uv3, major_radius, minor_radius)
		
	return Vector2()

#axis
func get_axis() -> int:
	return axis

func set_axis(val : int) -> void:
	axis = val

	emit_changed()
	output.emit_changed()
	
#major_radius
func get_major_radius() -> float:
	return major_radius

func set_major_radius(val : float) -> void:
	major_radius = val

	emit_changed()
	output.emit_changed()

#minor_radius
func get_minor_radius() -> float:
	return minor_radius

func set_minor_radius(val : float) -> void:
	minor_radius = val

	emit_changed()
	output.emit_changed()
