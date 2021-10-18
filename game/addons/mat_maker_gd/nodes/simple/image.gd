tool
extends MMNode

export(Resource) var image : Resource
export(String) var image_path : String

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)
	
func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_image_path_universal(image, "get_image_path", "set_image_path")

#func _render(material) -> void:
#	var img : Image = render_image(material)
#
#	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return image.get_value(uv)

func get_image_path() -> String:
	return image_path

func set_image_path(val : String) -> void:
	image_path = val
	
	var img : Image = Image.new()
	
	if image_path && image_path != "":
		img.load(image_path)

	image.set_value(img)

	set_dirty(true)

