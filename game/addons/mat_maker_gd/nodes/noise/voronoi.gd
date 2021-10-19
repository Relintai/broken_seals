tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var NoiseVoronoi = preload("res://addons/mat_maker_gd/nodes/common/noise_voronoi.gd")

export(Resource) var out_nodes : Resource
export(Resource) var out_borders : Resource
export(Resource) var out_random_color : Resource
export(Resource) var out_fill : Resource

export(Vector2) var scale : Vector2 = Vector2(4, 4)
export(Vector2) var stretch : Vector2 = Vector2(1, 1)
export(float) var intensity : float = 1
export(float) var randomness : float = 0.85

func _init_properties():
	if !out_nodes:
		out_nodes = MMNodeUniversalProperty.new()
		out_nodes.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_nodes.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	
	if !out_borders:
		out_borders = MMNodeUniversalProperty.new()
		out_borders.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_borders.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_random_color:
		out_random_color = MMNodeUniversalProperty.new()
		out_random_color.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_random_color.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_fill:
		out_fill = MMNodeUniversalProperty.new()
		out_fill.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_fill.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(out_nodes)
	register_output_property(out_borders)
	register_output_property(out_random_color)
	register_output_property(out_fill)
	

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(out_nodes)
	mm_graph_node.add_slot_texture_universal(out_borders)
	mm_graph_node.add_slot_texture_universal(out_random_color)
	mm_graph_node.add_slot_texture_universal(out_fill)
	
	mm_graph_node.add_slot_vector2("get_scale", "set_scale", "Scale", 0.1)#, Vector2(1, 32))#, Vector2(0, 32))
	mm_graph_node.add_slot_vector2("get_stretch", "set_stretch", "stretch", 0.01)#, Vector2(1, 32))#, Vector2(0, 32))
	mm_graph_node.add_slot_float("get_intensity", "set_intensity", "Intensity", 0.01)#, Vector2(1, 32))#, Vector2(0, 32))
	mm_graph_node.add_slot_float("get_randomness", "set_randomness", "Randomness", 0.01)#, Vector2(1, 32))#, Vector2(0, 32))




func _render(material) -> void:
	var nodes : Image = Image.new()
	var borders : Image = Image.new()
	var random_color : Image = Image.new()
	var fill : Image = Image.new()
	
	nodes.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	borders.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	random_color.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	fill.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	nodes.lock()
	borders.lock()
	random_color.lock()
	fill.lock()
	
	var w : float = material.image_size.x
	var h : float = material.image_size.y
	
	var pseed : float = randf() + randi()
	
	for x in range(material.image_size.x):
		for y in range(material.image_size.y):
			var uv : Vector2 = Vector2(x / w, y / h)
			
			var ps : float = 1.0 / float(pseed)

			#vec4 $(name_uv)_xyzw = voronoi($uv, vec2($scale_x, $scale_y), vec2($stretch_y, $stretch_x), $intensity, $randomness, $seed);
			var voronoi : Color = NoiseVoronoi.voronoi(uv, scale, stretch, intensity, randomness, ps)

			#Nodes - float - A greyscale pattern based on the distance to cell centers
			#$(name_uv)_xyzw.z
			var nodes_col : Color = Color(voronoi.b, voronoi.b, voronoi.b, 1)

			#Borders - float - A greyscale pattern based on the distance to borders
			#$(name_uv)_xyzw.w
			var borders_col : Color = Color(voronoi.a, voronoi.a, voronoi.a, 1)

			#Random color - rgb - A color pattern that assigns a random color to each cell
			#rand3(fract(floor($(name_uv)_xyzw.xy)/vec2($scale_x, $scale_y)))
			var rv3 : Vector3 = Commons.rand3(Commons.fractv2(Vector2(voronoi.r, voronoi.g) / scale))
			var random_color_col : Color = Color(rv3.x, rv3.y, rv3.z, 1)

			#Fill - rgba - An output that should be plugged into a Fill companion node
			#vec4(fract(($(name_uv)_xyzw.xy-1.0)/vec2($scale_x, $scale_y)), vec2(2.0)/vec2($scale_x, $scale_y))
			var fv21 : Vector2 = Commons.fractv2((Vector2(voronoi.r, voronoi.g) - Vector2(1, 1)) / scale)
			var fv22 : Vector2 = Vector2(2, 2) / scale
			var fill_col : Color = Color(fv21.x, fv21.y, fv22.x, fv22.y)

			nodes.set_pixel(x, y, nodes_col)
			borders.set_pixel(x, y, borders_col)
			random_color.set_pixel(x, y, random_color_col)
			fill.set_pixel(x, y, fill_col)

	nodes.unlock()
	borders.unlock()
	random_color.unlock()
	fill.unlock()
	
	out_nodes.set_value(nodes)
	out_borders.set_value(borders)
	out_random_color.set_value(random_color)
	out_fill.set_value(fill)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return Color()

#scale
func get_scale() -> Vector2:
	return scale

func set_scale(val : Vector2) -> void:
	scale = val

	set_dirty(true)

#stretch
func get_stretch() -> Vector2:
	return stretch

func set_stretch(val : Vector2) -> void:
	stretch = val

	set_dirty(true)
	
#intensity
func get_intensity() -> float:
	return intensity

func set_intensity(val : float) -> void:
	intensity = val

	set_dirty(true)
	
#randomness
func get_randomness() -> float:
	return randomness

func set_randomness(val : float) -> void:
	randomness = val

	set_dirty(true)
