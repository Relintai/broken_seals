tool
extends MMNode

var Shapes = preload("res://addons/mat_maker_gd/nodes/common/shapes.gd")

enum ShapeType {
	SHAPE_TYPE_CIRCLE = 0,
	SHAPE_TYPE_POLYGON = 1,
	SHAPE_TYPE_STAR = 2,
	SHAPE_TYPE_CURVED_STAR = 3,
	SHAPE_TYPE_RAYS = 4,
}

export(int, "Circle,Polygon,Star,Curved Star,Rays") var shape_type : int = 0
export(int) var sides : int = 6
export(float) var radius : float = 0.845361000; #univ input todo
export(float) var edge : float = 0.051546000; #univ input todo

func get_value_for(uv : Vector2, slot_idx : int, pseed : int) -> Color:
	var c : float = 0
	
	if shape_type == ShapeType.SHAPE_TYPE_CIRCLE:
		c = Shapes.shape_circle(uv, sides, radius * 1.0, edge * 1.0)
	elif shape_type == ShapeType.SHAPE_TYPE_POLYGON:
		c = Shapes.shape_polygon(uv, sides, radius * 1.0, edge * 1.0)
	elif shape_type == ShapeType.SHAPE_TYPE_STAR:
		c = Shapes.shape_star(uv, sides, radius * 1.0, edge * 1.0)
	elif shape_type == ShapeType.SHAPE_TYPE_CURVED_STAR:
		c = Shapes.shape_curved_star(uv, sides, radius * 1.0, edge * 1.0)
	elif shape_type == ShapeType.SHAPE_TYPE_RAYS:
		c = Shapes.shape_rays(uv, sides, radius * 1.0, edge * 1.0)
		
	return Color(c, c, c, 1)

func register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_IMAGE, "recalculate_image", "")
	mm_graph_node.add_slot_enum(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_NONE, "get_shape_typoe", "set_shape_typoe", "shape_type", [ "Circle", "Polygon", "Star", "Curved Star", "Rays" ])
	mm_graph_node.add_slot_int(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_NONE, "get_sides", "set_sides", "sides")#, Vector2(1, 10))
	#mm_graph_node.add_slot_float(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_NONE, "get_persistence", "set_persistence", "persistence", 0.05)#, Vector2(0, 1))
	#mm_graph_node.add_slot_vector2(SlotTypes.SLOT_TYPE_NONE, SlotTypes.SLOT_TYPE_NONE, "get_scale", "set_scale", "scale", 1)#, Vector2(1, 32))

func get_shape_typoe() -> int:
	return shape_type

func set_shape_typoe(val : int) -> void:
	shape_type = val

	emit_changed()

func get_sides() -> int:
	return sides

func set_sides(val : int) -> void:
	sides = val

	emit_changed()
