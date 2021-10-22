tool
extends MMNode

var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var output : Resource
export(int) var x : int = 3
export(int) var y : int = 3
export(float) var random_rotation : float = 0.5

func _init_properties():
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		
	output.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	#output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	output.slot_name = ">>>    Apply    >>>"
	output.get_value_from_owner = true

	register_input_property(output)
	register_output_property(output)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(output)
	
	mm_graph_node.add_slot_int("get_x", "set_x", "X")
	mm_graph_node.add_slot_int("get_y", "set_y", "Y")
	mm_graph_node.add_slot_float("get_random_rotation", "set_random_rotation", "Random rotation", 0.01)

func get_property_value(uv : Vector2):
	#todo add this as a parameter
	var pseed : int = 123123
	
	#$in(repeat_2d($uv, vec2(1.0/$rx, 1.0/$ry), float($seed), $r))
	var new_uv : Vector2 = SDF2D.repeat_2d(uv, Vector2(1.0 / float(x), 1.0/ float(y)), 1.0/float(pseed), random_rotation) 
	
	return output.get_value(new_uv, true)
#x
func get_x() -> int:
	return x

func set_x(val : int) -> void:
	x = val
	
	emit_changed()
	output.emit_changed()
	
#y
func get_y() -> int:
	return y

func set_y(val : int) -> void:
	y = val
	
	emit_changed()
	output.emit_changed()

#random_rotation
func get_random_rotation() -> float:
	return random_rotation

func set_random_rotation(val : float) -> void:
	random_rotation = val
	
	emit_changed()
	output.emit_changed()
