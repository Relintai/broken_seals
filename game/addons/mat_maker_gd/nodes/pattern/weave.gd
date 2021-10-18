tool
extends MMNode

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

export(Resource) var out_main : Resource
export(Resource) var out_horizontal_map : Resource
export(Resource) var out_vertical_map : Resource

export(Vector2) var size : Vector2 = Vector2(4, 4)
export(Resource) var width : Resource
export(int) var stitch : int = 1

func _init_properties():
	if !out_main:
		out_main = MMNodeUniversalProperty.new()
		out_main.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_main.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_horizontal_map:
		out_horizontal_map = MMNodeUniversalProperty.new()
		out_horizontal_map.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_horizontal_map.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_vertical_map:
		out_vertical_map = MMNodeUniversalProperty.new()
		out_vertical_map.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_vertical_map.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !width:
		width = MMNodeUniversalProperty.new()
		width.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2
		width.set_default_value(Vector2(0.9, 0.9))

	width.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	width.slot_name = "Width"
	width.value_step = 0.01
	width.value_range = Vector2(0, 1)
	
	register_output_property(out_main)
	register_output_property(out_horizontal_map)
	register_output_property(out_vertical_map)
	
	register_input_property(width)
	

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(out_main)
	mm_graph_node.add_slot_texture_universal(out_horizontal_map)
	mm_graph_node.add_slot_texture_universal(out_vertical_map)
	
	mm_graph_node.add_slot_vector2("get_size", "set_size", "Size")#, Vector2(1, 32))#, Vector2(0, 32))
	mm_graph_node.add_slot_vector2_universal(width)
	
	mm_graph_node.add_slot_int("get_stitch", "set_stitch", "Stitch")


func _render(material) -> void:
	var main_pattern : Image = Image.new()
	var horizontal_map : Image = Image.new()
	var vertical_map : Image = Image.new()
	
	main_pattern.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	horizontal_map.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	vertical_map.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	main_pattern.lock()
	horizontal_map.lock()
	vertical_map.lock()
	
	var w : float = material.image_size.x
	var h : float = material.image_size.y
	
	var pseed : float = randf() + randi()
	
	for x in range(material.image_size.x):
		for y in range(material.image_size.y):
			var uv : Vector2 = Vector2(x / w, y / h)
			
			var width_val : Vector2 = width.get_value(uv)
			
			#vec3 $(name_uv) = weave2($uv, vec2($columns, $rows), $stitch, $width_x*$width_map($uv), $width_y*$width_map($uv));
			var weave : Vector3 = Patterns.weave2(uv, size, stitch, width_val.x, width_val.y);

			#Outputs:

			#Output (float) - Shows the generated greyscale weave pattern.
			#$(name_uv).x
			var main_pattern_col : Color = Color(weave.x, weave.x, weave.x, 1)

			#Horizontal mask (float) - Horizontal mask
			#$(name_uv).y
			var horizontal_map_col : Color = Color(weave.y, weave.y, weave.y, 1)

			#Vertical mask (float) - Mask for vertical stripes
			#$(name_uv).z
			var vertical_map_col : Color = Color(weave.z, weave.z, weave.z, 1)
			
			main_pattern.set_pixel(x, y, main_pattern_col)
			horizontal_map.set_pixel(x, y, horizontal_map_col)
			vertical_map.set_pixel(x, y, vertical_map_col)

	main_pattern.unlock()
	horizontal_map.unlock()
	vertical_map.unlock()
	
	out_main.set_value(main_pattern)
	out_horizontal_map.set_value(horizontal_map)
	out_vertical_map.set_value(vertical_map)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return Color()

#size
func get_size() -> Vector2:
	return size

func set_size(val : Vector2) -> void:
	size = val

	set_dirty(true)

#stitch
func get_stitch() -> int:
	return stitch

func set_stitch(val : int) -> void:
	stitch = val

	set_dirty(true)
	
