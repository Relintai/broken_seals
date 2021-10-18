tool
extends MMNode

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

export(Resource) var image : Resource
export(float) var amplitude : float = 0.5
export(float) var frequency : float = 2
export(float) var phase : float = 0

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_float("get_amplitude", "set_amplitude", "Amplitude", 0.01)
	mm_graph_node.add_slot_float("get_frequency", "set_frequency", "Frequency", 0.1)
	mm_graph_node.add_slot_float("get_phase", "set_phase", "Phase", 0.01)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var f : float = 1.0 - abs(2.0 * (uv.y - 0.5) - amplitude *sin((frequency * uv.x + phase)*6.28318530718))

	return Color(f, f, f, 1)

#amplitude
func get_amplitude() -> float:
	return amplitude

func set_amplitude(val : float) -> void:
	amplitude = val

	set_dirty(true)

#frequency
func get_frequency() -> float:
	return frequency

func set_frequency(val : float) -> void:
	frequency = val

	set_dirty(true)
	
#phase
func get_phase() -> float:
	return phase

func set_phase(val : float) -> void:
	phase = val

	set_dirty(true)
