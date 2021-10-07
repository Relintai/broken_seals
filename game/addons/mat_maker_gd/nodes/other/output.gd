tool
extends MMNode

var image : Resource

func _init_properties():
	image = MMNodeUniversalProperty.new()
	image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
	image.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	image.slot_name = "radius"
	image.value_step = 0.05

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
