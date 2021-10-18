tool
extends MMNode

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

export(Resource) var image : Resource
export(Vector2) var size : Vector2 = Vector2(0.25, 0.4)
export(int) var layers : int = 4
export(float) var waviness : float = 0.51
export(int) var angle : int = 0
export(float) var randomness : float = 0.44

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_vector2("get_size", "set_size", "Size", 0.01)
	mm_graph_node.add_slot_int("get_layers", "set_layers", "Layers")
	mm_graph_node.add_slot_float("get_waviness", "set_waviness", "Waviness", 0.01)
	mm_graph_node.add_slot_int("get_angle", "set_angle", "Angle")
	mm_graph_node.add_slot_float("get_randomness", "set_randomness", "Randomness", 0.01)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#scratches($uv, int($layers), vec2($length, $width), $waviness, $angle, $randomness, vec2(float($seed), 0.0))
	return Patterns.scratchesc(uv, layers, size, waviness, angle, randomness, Vector2(pseed, 0.0))

#size
func get_size() -> Vector2:
	return size

func set_size(val : Vector2) -> void:
	size = val

	set_dirty(true)

#layers
func get_layers() -> int:
	return layers

func set_layers(val : int) -> void:
	layers = val

	set_dirty(true)
	
#waviness
func get_waviness() -> float:
	return waviness

func set_waviness(val : float) -> void:
	waviness = val

	set_dirty(true)

#angle
func get_angle() -> int:
	return angle

func set_angle(val : int) -> void:
	angle = val

	set_dirty(true)
	
#randomness
func get_randomness() -> float:
	return randomness

func set_randomness(val : float) -> void:
	randomness = val

	set_dirty(true)
