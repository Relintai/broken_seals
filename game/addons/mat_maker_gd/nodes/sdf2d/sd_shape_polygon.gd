tool
extends "res://addons/mat_maker_gd/nodes/bases/polygon_base.gd"

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var output : Resource

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
	mm_graph_node.add_slot_polygon()

func get_property_value(uv : Vector2) -> float:
	return SDF2D.sdPolygon(uv, points)

func _polygon_changed() -> void:
	emit_changed()
	output.emit_changed()
