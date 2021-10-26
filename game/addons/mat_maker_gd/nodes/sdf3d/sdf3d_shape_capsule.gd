tool
extends "res://addons/mat_maker_gd/nodes/bases/curve_base.gd"

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF3D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")
var Curves = preload("res://addons/mat_maker_gd/nodes/common/curves.gd")

export(Resource) var output : Resource
export(int, "X,Y,Z") var axis : int = 1
export(float) var length : float = 0.3
export(float) var radius : float = 0.2

func _init():
	init_points_11()

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
	mm_graph_node.add_slot_curve()

func get_property_value_sdf3d(uv3 : Vector3) -> Vector2:
	if axis == 0:
		return sdf3d_capsule_x(uv3, radius, length)
	elif axis == 1:
		return sdf3d_capsule_y(uv3, radius, length)
	elif axis == 2:
		return sdf3d_capsule_z(uv3, radius, length)
		
	return Vector2()

#vec3 $(name_uv)_p = $uv;
#$(name_uv)_p.$axis -= clamp($(name_uv)_p.$axis, -$l, $l);
#return length($(name_uv)_p) - $r * $profile(clamp(0.5+0.5*($uv).$axis/$l, 0.0, 1.0))

func sdf3d_capsule_y(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector3 = p;
	v.y -= clamp(v.y, -l, l);
	
	var cx : float = clamp(0.5 + 0.5 * p.y / l, 0.0, 1.0)
	var cp : float = Curves.curve(cx, points)
	var f : float = v.length() - r * cp

	return Vector2(f, 0.0);

func sdf3d_capsule_x(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector3 = p;
	v.x -= clamp(v.x, -l, l);
	
	var cx : float = clamp(0.5 + 0.5 * p.x / l, 0.0, 1.0)
	var cp : float = Curves.curve(cx, points)
	var f : float = v.length() - r * cp

	return Vector2(f, 0.0);

func sdf3d_capsule_z(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector3 = p;
	v.z -= clamp(v.z, -l, l);
	
	var cx : float = clamp(0.5 + 0.5 * p.z / l, 0.0, 1.0)
	var cp : float = Curves.curve(cx, points)
	var f : float = v.length() - r * cp

	return Vector2(f, 0.0);

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

func _curve_changed() -> void:
	emit_changed()
	output.emit_changed()
