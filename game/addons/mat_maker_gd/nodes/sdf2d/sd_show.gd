tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(float) var bevel : float = 0
export(float) var base : float = 0

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
	
	#for some reason this doesn't work, todo check
#	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = "Input"

	register_output_property(image)
	register_input_property(input)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_label_universal(input)
	
	mm_graph_node.add_slot_float("get_bevel", "set_bevel", "Bevel", 0.01)
	mm_graph_node.add_slot_float("get_base", "set_base", "Base", 0.01)

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var f : float = input.get_value(uv)
	
	#clamp($base-$in($uv)/max($bevel, 0.00001), 0.0, 1.0)
	var cf : float = clamp(base - f / max(bevel, 0.00001), 0.0, 1.0)
	
	return Color(cf, cf, cf, 1)

#bevel
func get_bevel() -> float:
	return bevel

func set_bevel(val : float) -> void:
	bevel = val

	set_dirty(true)
	
#base
func get_base() -> float:
	return base

func set_base(val : float) -> void:
	base = val

	set_dirty(true)
