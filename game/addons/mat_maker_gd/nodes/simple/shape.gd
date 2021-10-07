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

export(Resource) var image : Resource
export(int, "Circle,Polygon,Star,Curved Star,Rays") var shape_type : int = 0
export(int) var sides : int = 6
export(Resource) var radius : Resource
export(Resource) var edge : Resource

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !radius:
		radius = MMNodeUniversalProperty.new()
		radius.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		radius.set_default_value(0.34375)

	radius.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	radius.slot_name = "radius"
	radius.value_step = 0.05
		
	if !edge:
		edge = MMNodeUniversalProperty.new()
		edge.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		edge.set_default_value(0.2)
	
	edge.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	edge.slot_name = "edge"
	edge.value_step = 0.05

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE, "recalculate_image", "")
	mm_graph_node.add_slot_enum(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, "get_shape_typoe", "set_shape_typoe", "shape_type", [ "Circle", "Polygon", "Star", "Curved Star", "Rays" ])
	mm_graph_node.add_slot_int(MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_NONE, "get_sides", "set_sides", "sides")#, Vector2(1, 10))
	mm_graph_node.add_slot_float_universal(radius)
	mm_graph_node.add_slot_float_universal(edge)

func get_value_for(uv : Vector2, slot_idx : int, pseed : int) -> Color:
	var c : float = 0
	
	if shape_type == ShapeType.SHAPE_TYPE_CIRCLE:
		c = Shapes.shape_circle(uv, sides, radius.get_value(uv) * 1.0, edge.get_value(uv) * 1.0)
	elif shape_type == ShapeType.SHAPE_TYPE_POLYGON:
		c = Shapes.shape_polygon(uv, sides, radius.get_value(uv) * 1.0, edge.get_value(uv) * 1.0)
	elif shape_type == ShapeType.SHAPE_TYPE_STAR:
		c = Shapes.shape_star(uv, sides, radius.get_value(uv) * 1.0, edge.get_value(uv) * 1.0)
	elif shape_type == ShapeType.SHAPE_TYPE_CURVED_STAR:
		c = Shapes.shape_curved_star(uv, sides, radius.get_value(uv) * 1.0, edge.get_value(uv) * 1.0)
	elif shape_type == ShapeType.SHAPE_TYPE_RAYS:
		c = Shapes.shape_rays(uv, sides, radius.get_value(uv) * 1.0, edge.get_value(uv) * 1.0)
		
	return Color(c, c, c, 1)

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
