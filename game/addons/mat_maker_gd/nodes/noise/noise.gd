tool
extends MMNode

var Noises = preload("res://addons/mat_maker_gd/nodes/common/noises.gd")

export(Resource) var image : Resource

export(int) var grid_size : int = 16
export(float) var density : float = 0.5

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_int("get_grid_size", "set_grid_size", "Grid Size")#, Vector2(1, 10))
	mm_graph_node.add_slot_float("get_density", "set_density", "Density", 0.01)#, Vector2(0, 1))

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var ps : float = 1.0 / float(pseed)
	
	#return dots(uv, 1.0/$(size), $(density), $(seed));
	var f : float = Noises.dots(uv, 1.0 / float(grid_size), density, ps)
	
	return Color(f, f, f, 1)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_grid_size() -> int:
	return grid_size
	
func set_grid_size(val : int) -> void:
	grid_size = val
	
	set_dirty(true)

func get_density() -> float:
	return density
	
func set_density(val : float) -> void:
	density = val
	
	set_dirty(true)
