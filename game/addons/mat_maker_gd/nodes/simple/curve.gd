tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

export(Resource) var image : Resource

export(Resource) var input : Resource
export(Vector2) var a : Vector2 = Vector2(-0.35, -0.2)
export(Vector2) var b : Vector2 = Vector2(0, 0.5)
export(Vector2) var c : Vector2 = Vector2(0.35, -0.2)
export(float) var width : float = 0.05
export(int) var repeat : int = 1

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		input.set_default_value(1.0)
		
	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input    "

	register_input_property(input)
	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_label_universal(input)
	
	mm_graph_node.add_slot_vector2("get_a", "set_a", "A", 0.01)
	mm_graph_node.add_slot_vector2("get_b", "set_b", "B", 0.01)
	mm_graph_node.add_slot_vector2("get_c", "set_c", "C", 0.01)
	mm_graph_node.add_slot_float("get_width", "set_width", "Width", 0.01)
	mm_graph_node.add_slot_int("get_repeat", "set_repeat", "Repeat")

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var nuv : Vector2 = transform_uv(uv)
	
	var f : float = 0
	
	if nuv.x != 0 && nuv.y != 0:
		f = input.get_value(nuv)

	return Color(f, f, f, 1)

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func transform_uv(uv : Vector2) -> Vector2:
	#vec2 $(name_uv)_bezier = sdBezier($uv, vec2($ax+0.5, $ay+0.5), vec2($bx+0.5, $by+0.5), vec2($cx+0.5, $cy+0.5));
	var bezier : Vector2 = SDF2D.sdBezier(uv, Vector2(a.x + 0.5, a.y + 0.5), Vector2(b.x + 0.5, b.y + 0.5), Vector2(c.x + 0.5, c.y + 0.5))
	
	#vec2 $(name_uv)_uv = vec2($(name_uv)_bezier.x, $(name_uv)_bezier.y / $width+0.5);
	var new_uv : Vector2 = Vector2(bezier.x, bezier.y / width + 0.5)
	
	#vec2 $(name_uv)_uvtest = step(vec2(0.5), abs($(name_uv)_uv-vec2(0.5)));
	var uv_test : Vector2 = Commons.stepv2(Vector2(0.5, 0.5), Commons.absv2(new_uv - Vector2(0.5, 0.5)))
	
	#$(name_uv)_uv = mix(vec2(fract($repeat*$(name_uv)_uv.x), $(name_uv)_uv.y), vec2(0.0), max($(name_uv)_uvtest.x, $(name_uv)_uvtest.y));
	var final_uv : Vector2 = lerp(Vector2(Commons.fract(repeat * new_uv.x), new_uv.y), Vector2(), max(uv_test.x, uv_test.y))
	
	return final_uv

#b
func get_a() -> Vector2:
	return a

func set_a(val : Vector2) -> void:
	a = val
	
	set_dirty(true)
	
#b
func get_b() -> Vector2:
	return b

func set_b(val : Vector2) -> void:
	b = val
	
	set_dirty(true)
	
#c
func get_c() -> Vector2:
	return c

func set_c(val : Vector2) -> void:
	c = val
	
	set_dirty(true)
	
#width
func get_width() -> float:
	return width

func set_width(val : float) -> void:
	width = val
	
	set_dirty(true)

#repeat
func get_repeat() -> int:
	return repeat

func set_repeat(val : int) -> void:
	repeat = val
	
	set_dirty(true)
	
