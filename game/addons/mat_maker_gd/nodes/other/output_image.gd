tool
extends MMNode

export(Resource) var image : Resource

export(String) var postfix : String = ""

func _init_properties():
	image = MMNodeUniversalProperty.new()
	image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
	image.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	image.slot_name = "image"
	
	register_input_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_line_edit("get_postfix", "set_postfix", "postfix")

func _render(material) -> void:
	if !image:
		return
	
	var img : Image = image.get_active_image()
	
	if !img:
		return
	
	var matpath : String = material.get_path()
	
	if matpath == "":
		return
		
	var matbn : String = matpath.get_basename()
	var final_file_name : String = matbn + postfix + ".png"
	
	img.save_png(final_file_name)

func get_postfix() -> String:
	return postfix
	
func set_postfix(pf : String) -> void:
	postfix = pf
	
	set_dirty(true)
