tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(int, "Horizontal,Vertical") var direction : int = 0
export(float) var amount : float = 1
export(float) var center : float = 0

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input    "
	
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	#image.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	#image.force_override = true

	register_input_property(input)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_enum("get_direction", "set_direction", "Direction", [ "Horizontal", "Vertical" ])
	mm_graph_node.add_slot_float("get_amount", "set_amount", "Amount", 0.01)
	mm_graph_node.add_slot_float("get_center", "set_center", "Center", 0.01)

func _render(material) -> void:
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	#$in($uv+$amount*($uv.yx-vec2($center))*vec2($direction))

	if direction == 0:
		return input.get_value(uv + amount * (Vector2(uv.y, uv.x) - Vector2(center, center)) * Vector2(1, 0))
	elif direction == 1:
		return input.get_value(uv + amount * (Vector2(uv.y, uv.x) - Vector2(center, center)) * Vector2(0, 1))
		
	return Color(0, 0, 0, 1)

#direction
func get_direction() -> int:
	return direction

func set_direction(val : int) -> void:
	direction = val

	set_dirty(true)

#amount
func get_amount() -> float:
	return amount

func set_amount(val : float) -> void:
	amount = val

	set_dirty(true)
	
#center
func get_center() -> float:
	return center

func set_center(val : float) -> void:
	center = val

	set_dirty(true)
