tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

export(Resource) var out_main : Resource
export(Resource) var out_random_color : Resource
export(Resource) var out_uv_map : Resource

export(Vector2) var size : Vector2 = Vector2(4, 4)

func _init_properties():
	if !out_main:
		out_main = MMNodeUniversalProperty.new()
		out_main.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_main.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_random_color:
		out_random_color = MMNodeUniversalProperty.new()
		out_random_color.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_random_color.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_uv_map:
		out_uv_map = MMNodeUniversalProperty.new()
		out_uv_map.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_uv_map.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(out_main)
	register_output_property(out_random_color)
	register_output_property(out_uv_map)
	

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(out_main)
	mm_graph_node.add_slot_texture_universal(out_random_color)
	mm_graph_node.add_slot_texture_universal(out_uv_map)
	
	mm_graph_node.add_slot_vector2("get_size", "set_size", "Size")#, Vector2(1, 32))#, Vector2(0, 32))


func _render(material) -> void:
	var main_pattern : Image = Image.new()
	var random_color : Image = Image.new()
	var uv_map : Image = Image.new()
	
	main_pattern.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	random_color.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	uv_map.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	main_pattern.lock()
	random_color.lock()
	uv_map.lock()
	
	var w : float = material.image_size.x
	var h : float = material.image_size.y
	
	var pseed : float = randf() + randi()
	
	for x in range(material.image_size.x):
		for y in range(material.image_size.y):
			var uv : Vector2 = Vector2(x / w, y / h)
			
			var ps : float = 1.0 / float(pseed)
			
			#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
			#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);
			var beehive_uv : Vector2 = uv * size;
			var beehive_uv_center : Color = Patterns.beehive_center(beehive_uv);

			#Output (float) - Shows the greyscale pattern
			#1.0-2.0*beehive_dist($(name_uv)_center.xy)
			var f : float = 1.0 - 2.0 * Patterns.beehive_dist(Vector2(beehive_uv_center.r, beehive_uv_center.g))
			var main_pattern_col : Color = Color(f, f, f, 1)

			#Random color (rgb) - Shows a random color for each hexagonal tile
			#rand3(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed)))
			var rcv3 : Vector3 = Commons.rand3(Commons.fractv2(Vector2(beehive_uv_center.b, beehive_uv_center.a) / size) + Vector2(ps, ps))
			var random_color_col : Color = Color(rcv3.x, rcv3.y, rcv3.z, 1)

			#UV map (rgb) - Shows an UV map to be connected to the UV map port of the Custom UV node
			#vec3(vec2(0.5)+$(name_uv)_center.xy, rand(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed))))
			var uvm1 : Vector2 = Vector2(0.5, 0.5) + Vector2(beehive_uv_center.r, beehive_uv_center.g)
			var uvm2 : Vector2 = Commons.rand2(Commons.fractv2(Vector2(beehive_uv_center.b, beehive_uv_center.a) / size) + Vector2(ps, ps))
			
			var uv_map_col : Color = Color(uvm1.x, uvm1.y, uvm2.x, 1)

			main_pattern.set_pixel(x, y, main_pattern_col)
			random_color.set_pixel(x, y, random_color_col)
			uv_map.set_pixel(x, y, uv_map_col)

	main_pattern.unlock()
	random_color.unlock()
	uv_map.unlock()
	
	out_main.set_value(main_pattern)
	out_random_color.set_value(random_color)
	out_uv_map.set_value(uv_map)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return Color()

#size
func get_size() -> Vector2:
	return size

func set_size(val : Vector2) -> void:
	size = val

	set_dirty(true)
