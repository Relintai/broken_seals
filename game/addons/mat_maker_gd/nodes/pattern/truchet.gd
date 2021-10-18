tool
extends MMNode

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

export(Resource) var image : Resource
export(int, "Line,Circle") var shape : int = 0
export(float) var size : float = 4

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_enum("get_shape", "set_shape", "Shape", [ "Line", "Circle" ])
	mm_graph_node.add_slot_float("get_size", "set_size", "Size", 1)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	if shape == 0:
		return Patterns.truchet1c(uv, size, pseed)
	elif shape == 1:
		return Patterns.truchet2c(uv, size, pseed)
	
	return Color()

#shape
func get_shape() -> int:
	return shape

func set_shape(val : int) -> void:
	shape = val

	set_dirty(true)

#size
func get_size() -> float:
	return size

func set_size(val : float) -> void:
	size = val

	set_dirty(true)
