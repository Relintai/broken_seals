tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var output : Resource
export(Vector2) var center : Vector2 = Vector2(0, 0)
export(float) var radius : float = 0.4

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
	
	mm_graph_node.add_slot_vector2("get_center", "set_center", "Center", 0.01)
	mm_graph_node.add_slot_float("get_radius", "set_radius", "Radius", 0.01)

func get_property_value(uv : Vector2) -> float:
	return SDF2D.sdf_circle(uv, center, radius)

#center
func get_center() -> Vector2:
	return center

func set_center(val : Vector2) -> void:
	center = val
	
	emit_changed()
	output.emit_changed()
	
#radius
func get_radius() -> float:
	return radius

func set_radius(val : float) -> void:
	radius = val

	emit_changed()
	output.emit_changed()
