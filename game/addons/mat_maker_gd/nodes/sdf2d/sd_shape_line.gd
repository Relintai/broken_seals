tool
extends "res://addons/mat_maker_gd/nodes/bases/curve_base.gd"

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")
var Curves = preload("res://addons/mat_maker_gd/nodes/common/curves.gd")

export(Resource) var output : Resource
export(Vector2) var A : Vector2 = Vector2(-0.3, -0.3)
export(Vector2) var B : Vector2 = Vector2(0.3, 0.3)
export(float) var width : float = 0.1

func _init():
	init_points_11()

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
	
	mm_graph_node.add_slot_vector2("get_a", "set_a", "A", 0.01)
	mm_graph_node.add_slot_vector2("get_b", "set_b", "B", 0.01)
	mm_graph_node.add_slot_float("get_width", "set_width", "Width", 0.01)
	mm_graph_node.add_slot_curve()

func get_property_value(uv : Vector2) -> float:
	var line : Vector2 = SDF2D.sdf_line(uv, A, B, width)
	
	#$(name_uv)_sdl.x - $r * $profile($(name_uv)_sdl.y)
	
	return line.x - width * Curves.curve(line.y, points)

#a
func get_a() -> Vector2:
	return A

func set_a(val : Vector2) -> void:
	A = val
	
	emit_changed()
	output.emit_changed()
	
#b
func get_b() -> Vector2:
	return B

func set_b(val : Vector2) -> void:
	B = val
	
	emit_changed()
	output.emit_changed()
	
#width
func get_width() -> float:
	return width

func set_width(val : float) -> void:
	width = val
	
	emit_changed()
	output.emit_changed()

func _curve_changed() -> void:
	emit_changed()
	output.emit_changed()
