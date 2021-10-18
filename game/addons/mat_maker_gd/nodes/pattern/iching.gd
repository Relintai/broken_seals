tool
extends MMNode

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

export(Resource) var image : Resource
export(Vector2) var size : Vector2 = Vector2(4, 4)

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_vector2("get_size", "set_size", "Size", 1)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var ps : float = 1.0 / float(pseed)
	
	#IChing(vec2($columns, $rows)*$uv, float($seed))
	return Patterns.IChingc(uv, size, ps)

#size
func get_size() -> Vector2:
	return size

func set_size(val : Vector2) -> void:
	size = val

	set_dirty(true)
