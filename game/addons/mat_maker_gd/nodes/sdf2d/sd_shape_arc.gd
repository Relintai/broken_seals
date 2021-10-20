tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var output : Resource
export(Vector2) var angle : Vector2 = Vector2(30, 150)
export(float) var radius : float = 0.3
export(float) var width : float = 0.1

func _init_properties():
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		
	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	output.slot_name = ">>>   Output    >>>"
	output.get_value_from_owner = true

	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(output)
	
	mm_graph_node.add_slot_vector2("get_angle", "set_angle", "Angle", 1)
	mm_graph_node.add_slot_float("get_radius", "set_radius", "Radius", 0.01)
	mm_graph_node.add_slot_float("get_width", "set_width", "Width", 0.01)

func get_property_value(uv : Vector2) -> float:
	return SDF2D.sdf_arc(uv, angle, Vector2(radius, width))

#angle
func get_angle() -> Vector2:
	return angle

func set_angle(val : Vector2) -> void:
	angle = val
	
	emit_changed()
	output.emit_changed()
	
#radius
func get_radius() -> float:
	return radius

func set_radius(val : float) -> void:
	radius = val
	
	emit_changed()
	output.emit_changed()

#width
func get_width() -> float:
	return width

func set_width(val : float) -> void:
	width = val
	
	emit_changed()
	output.emit_changed()
