tool
extends MMNode

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var NoiseVoronoi = preload("res://addons/mat_maker_gd/nodes/common/noise_voronoi.gd")

export(Resource) var input : Resource
export(Resource) var out_r : Resource
export(Resource) var out_g : Resource
export(Resource) var out_b : Resource
export(Resource) var out_a : Resource

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input    "
	
	if !out_r:
		out_r = MMNodeUniversalProperty.new()
		out_r.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_r.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	
	if !out_g:
		out_g = MMNodeUniversalProperty.new()
		out_g.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_g.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_b:
		out_b = MMNodeUniversalProperty.new()
		out_b.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_b.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_a:
		out_a = MMNodeUniversalProperty.new()
		out_a.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_a.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_input_property(input)
	register_output_property(out_r)
	register_output_property(out_g)
	register_output_property(out_b)
	register_output_property(out_a)
	

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_texture_universal(out_r)
	mm_graph_node.add_slot_texture_universal(out_g)
	mm_graph_node.add_slot_texture_universal(out_b)
	mm_graph_node.add_slot_texture_universal(out_a)
	

func _render(material) -> void:
	var img_r : Image = Image.new()
	var img_g : Image = Image.new()
	var img_b : Image = Image.new()
	var img_a : Image = Image.new()
	
	img_r.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	img_g.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	img_b.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	img_a.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	img_r.lock()
	img_g.lock()
	img_b.lock()
	img_a.lock()
	
	var w : float = material.image_size.x
	var h : float = material.image_size.y
	
	var pseed : float = randf() + randi()
	
	for x in range(material.image_size.x):
		for y in range(material.image_size.y):
			var uv : Vector2 = Vector2(x / w, y / h)
			
			var c : Color = input.get_value(uv)

			img_r.set_pixel(x, y, Color(c.r, c.r, c.r, 1))
			img_g.set_pixel(x, y, Color(c.g, c.g, c.g, 1))
			img_b.set_pixel(x, y, Color(c.b, c.b, c.b, 1))
			img_a.set_pixel(x, y, Color(c.a, c.a, c.a, c.a))

	img_r.unlock()
	img_g.unlock()
	img_b.unlock()
	img_a.unlock()
	
	out_r.set_value(img_r)
	out_g.set_value(img_g)
	out_b.set_value(img_b)
	out_a.set_value(img_a)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return Color()
