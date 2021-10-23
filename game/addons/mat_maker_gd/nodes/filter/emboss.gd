tool
extends MMNode

var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(float) var angle : float = 0
export(float) var amount : float = 5
export(float) var width : float = 1

var size : int = 0

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		input.set_default_value(1)

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input1    "
		
	register_input_property(input)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_label_universal(input)

	mm_graph_node.add_slot_float("get_angle", "set_angle", "Angle", 0.1)
	mm_graph_node.add_slot_float("get_amount", "set_amount", "Amount", 0.1)
	mm_graph_node.add_slot_float("get_width", "set_width", "Width", 1)


func _render(material) -> void:
	size = max(material.image_size.x, material.image_size.y)
	
	var img : Image = render_image(material)

	image.set_value(img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var f : float = 0

	f = emboss(uv, size, angle, amount, width)

	return Color(f, f, f, 1)

func get_angle() -> float:
	return angle

func set_angle(val : float) -> void:
	angle = val

	set_dirty(true)

func get_amount() -> float:
	return amount

func set_amount(val : float) -> void:
	amount = val

	set_dirty(true)

func get_width() -> float:
	return width

func set_width(val : float) -> void:
	width = val

	set_dirty(true)

#float $(name)_fct(vec2 uv) {
#	float pixels = max(1.0, $width);
#	float e = 1.0/$size;
#	float rv = 0.0;
#
#	for (float dx = -pixels; dx <= pixels; dx += 1.0) {
#		for (float dy = -pixels; dy <= pixels; dy += 1.0) {
#			if (abs(dx) > 0.5 || abs(dy) > 0.5) {
#				rv += $in(uv+e*vec2(dx, dy))*cos(atan(dy, dx)-$angle*3.14159265359/180.0)/length(vec2(dx, dy));
#			}
#		}
#	}
#
#	return $amount*rv/pixels+0.5;
#}

func emboss(uv : Vector2, psize : float, pangle : float, pamount : float, pwidth : float) -> float:
	var pixels : float = max(1.0, pwidth)
	var e : float = 1.0 / psize
	var rv : float = 0.0
	
	var dx : float = -pixels
	var dy : float = -pixels
	
	while dx <= pixels: #for (float dx = -pixels; dx <= pixels; dx += 1.0) {
		while dy <= pixels: #for (float dy = -pixels; dy <= pixels; dy += 1.0) {
			if (abs(dx) > 0.5 || abs(dy) > 0.5):
				rv += input.get_value(uv + e * Vector2(dx, dy)) * cos(atan2(dy, dx) - pangle * 3.14159265359 / 180.0) / Vector2(dx, dy).length()
				
			dx += 1
			dy += 1

	return pamount * rv / pixels + 0.5

