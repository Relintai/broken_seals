tool
extends MMNode

var Noises = preload("res://addons/mat_maker_gd/nodes/common/noises.gd")

export(Resource) var image : Resource

export(int) var size : int = 8

#----------------------
#color_noise.mmg

#Outputs:

#Output - (rgb) - Shows the noise pattern
#color_dots($(uv), 1.0/$(size), $(seed))

#Inputs:
#size, float, default: 8, min: 2, max: 12, step: 1


func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_int("get_size", "set_size", "Size")#, Vector2(1, 10))

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var ps : float = 1.0 / float(pseed)
	
	#color_dots($(uv), 1.0/$(size), $(seed))
	return Noises.noise_color(uv, float(size), ps)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_size() -> int:
	return size
	
func set_size(val : int) -> void:
	size = val
	
	set_dirty(true)
