tool
extends MMNode

var Gradients = preload("res://addons/mat_maker_gd/nodes/common/gradients.gd")

export(Resource) var image : Resource
export(float) var repeat : float = 1
export(float) var rotate : float = 0

export(int) var interpolation_type : int = 1 setget set_interpolation_type, get_interpolation_type
export(PoolRealArray) var points : PoolRealArray = PoolRealArray()

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_float("get_repeat", "set_repeat", "repeat")
	mm_graph_node.add_slot_float("get_rotate", "set_rotate", "rotate")
	mm_graph_node.add_slot_gradient()

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	if interpolation_type == 0:
		return Gradients.normal_gradient_type_1(uv, repeat, rotate, points)
	elif interpolation_type == 1:
		return Gradients.normal_gradient_type_2(uv, repeat, rotate, points)
	elif interpolation_type == 2:
		return Gradients.normal_gradient_type_3(uv, repeat, rotate, points)
	elif interpolation_type == 3:
		return Gradients.normal_gradient_type_4(uv, repeat, rotate, points)

	return Color(1, 1, 1, 1)

func get_gradient_color(x : float) -> Color:
	if interpolation_type == 0:
		return Gradients.gradient_type_1(x, points)
	elif interpolation_type == 1:
		return Gradients.gradient_type_2(x, points)
	elif interpolation_type == 2:
		return Gradients.gradient_type_3(x, points)
	elif interpolation_type == 3:
		return Gradients.gradient_type_4(x, points)

	return Color(1, 1, 1, 1)

func get_repeat() -> float:
	return repeat

func set_repeat(val : float) -> void:
	repeat = val

	set_dirty(true)

func get_rotate() -> float:
	return rotate

func set_rotate(val : float) -> void:
	rotate = val

	set_dirty(true)

func get_interpolation_type() -> int:
	return interpolation_type

func set_interpolation_type(val : int) -> void:
	interpolation_type = val

	set_dirty(true)
	
func get_points() -> PoolRealArray:
	return points

func set_points(val : PoolRealArray) -> void:
	points = val

	set_dirty(true)

func get_point_value(index : int) -> float:
	return points[index * 5]
	
func get_point_color(index : int) -> Color:
	var indx : int = index * 5
	
	return Color(points[indx + 1], points[indx + 2], points[indx + 3], points[indx + 4])

func add_point(val : float, color : Color) -> void:
	var s : int = points.size()
	points.resize(s + 5)
	
	points[s] = val
	
	points[s + 1] = color.r
	points[s + 2] = color.g
	points[s + 3] = color.b
	points[s + 4] = color.a
	
	set_dirty(true)

func get_point_count() -> int:
	return points.size() / 5

func clear() -> void:
	points.resize(0)
	
	set_dirty(true)
