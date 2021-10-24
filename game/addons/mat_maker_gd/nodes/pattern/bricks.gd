tool
extends MMNode

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

export(Resource) var out_bricks_pattern : Resource
export(Resource) var out_random_color : Resource
export(Resource) var out_position_x : Resource
export(Resource) var out_position_y : Resource
export(Resource) var out_brick_uv : Resource
export(Resource) var out_corner_uv : Resource
export(Resource) var out_direction : Resource

export(int, "Running Bond,Running Bond (2),HerringBone,Basket Weave,Spanish Bond") var type : int = 0
export(int) var repeat : int = 1
export(Vector2) var col_row : Vector2 = Vector2(4, 4)
export(float) var offset : float = 0.5
export(Resource) var mortar : Resource
export(Resource) var bevel : Resource
export(Resource) var roundness : Resource
export(float) var corner : float = 0.3

func _init_properties():
	if !out_bricks_pattern:
		out_bricks_pattern = MMNodeUniversalProperty.new()
		out_bricks_pattern.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_bricks_pattern.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_random_color:
		out_random_color = MMNodeUniversalProperty.new()
		out_random_color.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_random_color.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_position_x:
		out_position_x = MMNodeUniversalProperty.new()
		out_position_x.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_position_x.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_position_y:
		out_position_y = MMNodeUniversalProperty.new()
		out_position_y.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_position_y.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	
	if !out_brick_uv:
		out_brick_uv = MMNodeUniversalProperty.new()
		out_brick_uv.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_brick_uv.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	
	if !out_corner_uv:
		out_corner_uv = MMNodeUniversalProperty.new()
		out_corner_uv.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_corner_uv.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !out_direction:
		out_direction = MMNodeUniversalProperty.new()
		out_direction.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_direction.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !mortar:
		mortar = MMNodeUniversalProperty.new()
		mortar.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		mortar.set_default_value(0.1)

	mortar.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	mortar.slot_name = "Mortar"
	mortar.value_step = 0.01
	mortar.value_range = Vector2(0, 0.5)
	
	if !bevel:
		bevel = MMNodeUniversalProperty.new()
		bevel.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		bevel.set_default_value(0.1)

	bevel.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	bevel.slot_name = "Bevel"
	bevel.value_step = 0.01
	bevel.value_range = Vector2(0, 0.5)

	if !roundness:
		roundness = MMNodeUniversalProperty.new()
		roundness.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		roundness.set_default_value(0.1)

	roundness.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	roundness.slot_name = "Roundness"
	roundness.value_step = 0.01
	roundness.value_range = Vector2(0, 0.5)
	
	register_output_property(out_bricks_pattern)
	register_output_property(out_random_color)
	register_output_property(out_position_x)
	register_output_property(out_position_y)
	register_output_property(out_brick_uv)
	register_output_property(out_corner_uv)
	register_output_property(out_direction)
	
	register_input_property(mortar)
	register_input_property(bevel)
	register_input_property(roundness)
	

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(out_bricks_pattern)
	mm_graph_node.add_slot_texture_universal(out_random_color)
	mm_graph_node.add_slot_texture_universal(out_position_x)
	mm_graph_node.add_slot_texture_universal(out_position_y)
	mm_graph_node.add_slot_texture_universal(out_brick_uv)
	mm_graph_node.add_slot_texture_universal(out_corner_uv)
	mm_graph_node.add_slot_texture_universal(out_direction)
	
	mm_graph_node.add_slot_enum("get_type", "set_type", "Type", [ "Running Bond", "Running Bond (2)", "HerringBone", "Basket Weave", "Spanish Bond" ])
	mm_graph_node.add_slot_int("get_repeat", "set_repeat", "Repeat")
	
	mm_graph_node.add_slot_vector2("get_col_row", "set_col_row", "Col, Row")#, Vector2(1, 32))#, Vector2(0, 32))
	mm_graph_node.add_slot_float("get_offset", "set_offset", "Offset")

	mm_graph_node.add_slot_float_universal(mortar)
	mm_graph_node.add_slot_float_universal(bevel)
	mm_graph_node.add_slot_float_universal(roundness)
	
	mm_graph_node.add_slot_float("get_corner", "set_corner", "Corner")

func _render(material) -> void:
	var bricks_pattern : Image = Image.new()
	var random_color : Image = Image.new()
	var position_x : Image = Image.new()
	var position_y : Image = Image.new()
	var brick_uv : Image = Image.new()
	var corner_uv : Image = Image.new()
	var direction : Image = Image.new()
	
	bricks_pattern.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	random_color.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	position_x.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	position_y.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	brick_uv.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	corner_uv.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	direction.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	bricks_pattern.lock()
	random_color.lock()
	position_x.lock()
	position_y.lock()
	brick_uv.lock()
	corner_uv.lock()
	direction.lock()
	
	var w : float = material.image_size.x
	var h : float = material.image_size.y
	
	var pseed : float = randf() + randi()
	
	for x in range(material.image_size.x):
		for y in range(material.image_size.y):
			var uv : Vector2 = Vector2(x / w, y / h)
			
			#vec4 $(name_uv)_rect = bricks_$pattern($uv, vec2($columns, $rows), $repeat, $row_offset);
			var brick_rect : Color = Color()
			
			#"Running Bond,Running Bond (2),HerringBone,Basket Weave,Spanish Bond"
			
			if type == 0:
				brick_rect = Patterns.bricks_rb(uv, col_row, repeat, offset)
			elif type == 1:
				brick_rect = Patterns.bricks_rb2(uv, col_row, repeat, offset)
			elif type == 2:
				brick_rect = Patterns.bricks_hb(uv, col_row, repeat, offset)
			elif type == 3:
				brick_rect = Patterns.bricks_bw(uv, col_row, repeat, offset)
			elif type == 4:
				brick_rect = Patterns.bricks_sb(uv, col_row, repeat, offset)
			
			
			#vec4 $(name_uv) = brick($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $round*$round_map($uv), max(0.001, $bevel*$bevel_map($uv)));
			var brick : Color = Patterns.brick(uv, Vector2(brick_rect.r, brick_rect.g), Vector2(brick_rect.b, brick_rect.a), mortar.get_value(uv), roundness.get_value(uv), max(0.001, bevel.get_value(uv)))
			
			#Bricks pattern (float) - A greyscale image that shows the bricks pattern
			#$(name_uv).x
			var bricks_pattern_col : Color = Color(brick.r, brick.r, brick.r, 1)

			#Random color (rgb) - A random color for each brick
			#brick_random_color($(name_uv)_rect.xy, $(name_uv)_rect.zw, float($seed))
			var brc : Vector3 = Patterns.brick_random_color(Vector2(brick_rect.r, brick_rect.g), Vector2(brick_rect.b, brick_rect.a), 1 / float(pseed))
			var random_color_col : Color = Color(brc.x, brc.y, brc.z, 1)

			#Position.x (float) - The position of each brick along the X axis",
			#$(name_uv).y
			var position_x_col : Color = Color(brick.g, brick.g, brick.g, 1)

			#Position.y (float) - The position of each brick along the Y axis
			#$(name_uv).z
			var position_y_col : Color = Color(brick.b, brick.b, brick.b, 1)

			#Brick UV (rgb) - An UV map output for each brick, to be connected to the Map input of a CustomUV node
			#brick_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, float($seed))
			var buv : Vector3 = Patterns.brick_uv(uv, Vector2(brick_rect.r, brick_rect.g), Vector2(brick_rect.b, brick_rect.a), pseed)
			var brick_uv_col : Color = Color(buv.x, buv.y, buv.z, 1)

			#Corner UV (rgb) - An UV map output for each brick corner, to be connected to the Map input of a CustomUV node
			#brick_corner_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $corner, float($seed))
			var bcuv : Vector3 = Patterns.brick_corner_uv(uv, Vector2(brick_rect.r, brick_rect.g), Vector2(brick_rect.b, brick_rect.a), mortar.get_value(uv), corner, pseed)
			var corner_uv_col : Color = Color(bcuv.x, bcuv.y, bcuv.z, 1)

			#Direction (float) - The direction of each brick (white: horizontal, black: vertical)
			#0.5*(sign($(name_uv)_rect.z-$(name_uv)_rect.x-$(name_uv)_rect.w+$(name_uv)_rect.y)+1.0)
			var d : float = 0.5 * (sign(brick_rect.b - brick_rect.r - brick_rect.a + brick_rect.g) + 1.0)
			var direction_col : Color = Color(d, d, d, 1)

			bricks_pattern.set_pixel(x, y, bricks_pattern_col)
			random_color.set_pixel(x, y, random_color_col)
			position_x.set_pixel(x, y, position_x_col)
			position_y.set_pixel(x, y, position_y_col)
			brick_uv.set_pixel(x, y, brick_uv_col)
			corner_uv.set_pixel(x, y, corner_uv_col)
			direction.set_pixel(x, y, direction_col)

	bricks_pattern.unlock()
	random_color.unlock()
	position_x.unlock()
	position_y.unlock()
	brick_uv.unlock()
	corner_uv.unlock()
	direction.unlock()
	
	out_bricks_pattern.set_value(bricks_pattern)
	out_random_color.set_value(random_color)
	out_position_x.set_value(position_x)
	out_position_y.set_value(position_y)
	out_brick_uv.set_value(brick_uv)
	out_corner_uv.set_value(corner_uv)
	out_direction.set_value(direction)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return Color()

#type
func get_type() -> int:
	return type

func set_type(val : int) -> void:
	type = val

	set_dirty(true)

#repeat
func get_repeat() -> int:
	return repeat

func set_repeat(val : int) -> void:
	repeat = val

	set_dirty(true)

#col_row
func get_col_row() -> Vector2:
	return col_row

func set_col_row(val : Vector2) -> void:
	col_row = val

	set_dirty(true)

#offset
func get_offset() -> float:
	return offset

func set_offset(val : float) -> void:
	offset = val

	set_dirty(true)
	
#corner
func get_corner() -> float:
	return corner

func set_corner(val : float) -> void:
	corner = val

	set_dirty(true)


