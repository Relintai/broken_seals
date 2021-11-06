tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

export(Resource) var input : Resource
export(Resource) var in_mask : Resource

export(Resource) var output : Resource
export(Resource) var instance_map : Resource

export(Vector2) var tile : Vector2 = Vector2(4, 4)
export(float) var overlap : float = 1
export(int, "1,4,16") var select_inputs : int = 0
export(Vector2) var scale : Vector2 = Vector2(0.5, 0.5)
export(float) var fixed_offset : float = 0
export(float) var rnd_offset : float = 0.25
export(float) var rnd_rotate : float = 45
export(float) var rnd_scale : float = 0.2
export(float) var rnd_opacity : float = 0
export(bool) var variations : bool = false

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color(0, 0, 0, 1))

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input    "
	
	if !in_mask:
		in_mask = MMNodeUniversalProperty.new()
		in_mask.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		in_mask.set_default_value(1)

	in_mask.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	in_mask.slot_name = ">>>    Mask    "
	
	if !output:
		output = MMNodeUniversalProperty.new()
		output.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	output.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !instance_map:
		instance_map = MMNodeUniversalProperty.new()
		instance_map.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	instance_map.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	
	register_input_property(input)
	register_input_property(in_mask)
	register_output_property(output)
	register_output_property(instance_map)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_label_universal(in_mask)
	mm_graph_node.add_slot_texture_universal(output)
	mm_graph_node.add_slot_texture_universal(instance_map)
	
	mm_graph_node.add_slot_vector2("get_tile", "set_tile", "Tile", 1)
	mm_graph_node.add_slot_float("get_overlap", "set_overlap", "Overlap", 1)
	mm_graph_node.add_slot_enum("get_select_inputs", "set_select_inputs", "Select inputs", [ "1", "4", "16" ])
	mm_graph_node.add_slot_vector2("get_scale", "set_scale", "Scale", 0.01)
	mm_graph_node.add_slot_float("get_fixed_offset", "set_fixed_offset", "Fixed Offset", 0.01)
	mm_graph_node.add_slot_float("get_rnd_offset", "set_rnd_offset", "Rnd Offset", 0.01)
	mm_graph_node.add_slot_float("get_rnd_rotate", "set_rnd_rotate", "Rnd Rotate", 0.1)
	mm_graph_node.add_slot_float("get_rnd_scale", "set_rnd_scale", "Rnd Scale", 0.01)
	mm_graph_node.add_slot_float("get_rnd_opacity", "set_rnd_opacity", "Rnd Opacity", 0.01)
	#mm_graph_node.add_slot_bool("get_variations", "set_variations", "Variations")

func _render(material) -> void:
	var output_img : Image = Image.new()
	var instance_map_img : Image = Image.new()
	
	output_img.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	instance_map_img.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	output_img.lock()
	instance_map_img.lock()
	
	var w : float = material.image_size.x
	var h : float = material.image_size.y
	
	var pseed : float = randf() + randi()
	
	var ps : float = 1.0 / float(pseed)
	
	var ix : int = int(material.image_size.x)
	var iy : int = int(material.image_size.y)
	
	for x in range(ix):
		for y in range(iy):
			var uv : Vector2 = Vector2(x / w, y / h)
			
			#vec3 $(name_uv)_random_color;
			#vec4 $(name_uv)_tiled_output = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), vec2(float($seed)), $(name_uv)_random_color);
			var rch : PoolColorArray = tiler_calc(uv, tile, overlap, Vector2(ps, ps))
			
			output_img.set_pixel(x, y, rch[1])
			instance_map_img.set_pixel(x, y, rch[0])

	output_img.unlock()
	instance_map_img.unlock()
	
	output.set_value(output_img)
	instance_map.set_value(instance_map_img)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return Color()

#tile
func get_tile() -> Vector2:
	return tile

func set_tile(val : Vector2) -> void:
	tile = val

	set_dirty(true)

#overlap
func get_overlap() -> float:
	return overlap

func set_overlap(val : float) -> void:
	overlap = val

	set_dirty(true)

#select_inputs
func get_select_inputs() -> int:
	return select_inputs

func set_select_inputs(val : int) -> void:
	select_inputs = val

	set_dirty(true)

#scale
func get_scale() -> Vector2:
	return scale

func set_scale(val : Vector2) -> void:
	scale = val

	set_dirty(true)

#fixed_offset
func get_fixed_offset() -> float:
	return fixed_offset

func set_fixed_offset(val : float) -> void:
	fixed_offset = val

	set_dirty(true)
	
#rnd_offset
func get_rnd_offset() -> float:
	return rnd_offset

func set_rnd_offset(val : float) -> void:
	rnd_offset = val

	set_dirty(true)
	
	
#rnd_rotate
func get_rnd_rotate() -> float:
	return rnd_rotate

func set_rnd_rotate(val : float) -> void:
	rnd_rotate = val

	set_dirty(true)
	
#rnd_scale
func get_rnd_scale() -> float:
	return rnd_scale

func set_rnd_scale(val : float) -> void:
	rnd_scale = val

	set_dirty(true)

#rnd_opacity
func get_rnd_opacity() -> float:
	return rnd_opacity

func set_rnd_opacity(val : float) -> void:
	rnd_opacity = val

	set_dirty(true)
	
#variations
func get_variations() -> bool:
	return variations

func set_variations(val : bool) -> void:
	variations = val

	set_dirty(true)

#----------------------
#color_tiler.mmg
#Tiles several occurences of an input image while adding randomness.

#vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, vec2 _seed, out vec3 random_color) {
#	vec4 c = vec4(0.0);
#	vec3 rc = vec3(0.0);
#	vec3 rc1;
#
#	for (int dx = -overlap; dx <= overlap; ++dx) {
#		for (int dy = -overlap; dy <= overlap; ++dy) {
#			vec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));
#			vec2 seed = rand2(pos+_seed);
#			rc1 = rand3(seed);
#			pos = fract(pos+vec2($fixed_offset/tile.x, 0.0)*floor(mod(pos.y*tile.y, 2.0))+$offset*seed/tile);
#			float mask = $mask(fract(pos+vec2(0.5)));
#			if (mask > 0.01) {
#				vec2 pv = fract(uv - pos)-vec2(0.5);
#				seed = rand2(seed);
#				float angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;
#				float ca = cos(angle);
#				float sa = sin(angle);
#				pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);
#				pv *= (seed.y-0.5)*2.0*$scale+1.0;
#				pv /= vec2($scale_x, $scale_y);
#				pv += vec2(0.5);
#				pv = clamp(pv, vec2(0.0), vec2(1.0));
#
#				$select_inputs
#
#				vec4 n = $in.variation(pv, $variations ? seed.x : 0.0);
#
#				seed = rand2(seed);
#				float na = n.a*mask*(1.0-$opacity*seed.x);
#				float a = (1.0-c.a)*(1.0*na);
#
#				c = mix(c, n, na);
#				rc = mix(rc, rc1, n.a);
#			}
#		}
#	}
#
#	random_color = rc;
#	return c;
#}


#select_inputs enum
#1,  " "
#4, "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#16, "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"

func tiler_calc(uv : Vector2, tile : Vector2, overlap : int, _seed : Vector2) -> PoolColorArray:
	var c : Color = Color()
	var rc : Vector3 = Vector3()
	var rc1 : Vector3 = Vector3()
	
	for dx in range(-overlap, overlap): #for (int dx = -overlap; dx <= overlap; ++dx) {
		for dy in range(-overlap, overlap): #for (int dy = -overlap; dy <= overlap; ++dy) {
			var pos : Vector2 = Commons.fractv2((Commons.floorv2(uv * tile) + Vector2(dx, dy) + Vector2(0.5, 0.5)) / tile - Vector2(0.5, 0.5))
			var vseed : Vector2 = Commons.rand2(pos + _seed)
			rc1 = Commons.rand3(vseed)
			pos = Commons.fractv2(pos + Vector2(fixed_offset / tile.x, 0.0) * floor(Commons.modf(pos.y * tile.y, 2.0)) + rnd_offset * vseed / tile)
			var mask : float = in_mask.get_value(Commons.fractv2(pos + Vector2(0.5, 0.5)))

			if (mask > 0.01):
				var pv : Vector2 = Commons.fractv2(uv - pos) - Vector2(0.5, 0.5)
				vseed = Commons.rand2(vseed)
				var angle : float = (vseed.x * 2.0 - 1.0) * rnd_rotate * 0.01745329251
				var ca : float = cos(angle)
				var sa : float = sin(angle)
				pv = Vector2(ca * pv.x + sa * pv.y, -sa * pv.x + ca * pv.y)
				pv *= (vseed.y-0.5) * 2.0 * rnd_scale + 1.0
				pv /= scale
				pv += Vector2(0.5, 0.5)
				pv = Commons.clampv2(pv, Vector2(), Vector2(1, 1))
					
				#1,  " "
				#4, "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
				#16, "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"
					
				if select_inputs == 1:
					pv = Commons.clampv2(0.5*(pv + Commons.floorv2(Commons.rand2(vseed)*2.0)), Vector2(), Vector2(1, 1));
				elif select_inputs == 2:
					pv = Commons.clampv2(0.25*(pv + Commons.floorv2(Commons.rand2(vseed)*4.0)), Vector2(), Vector2(1, 1));

#				vec4 n = $in.variation(pv, $variations ? seed.x : 0.0);
				var n : Color = input.get_value(pv) * mask * (1.0 - rnd_opacity * vseed.x)

				vseed = Commons.rand2(vseed)
				var na : float = n.a * mask * (1.0 - rnd_opacity * vseed.x)
				var a : float = (1.0 - c.a) * (1.0 * na)

				c = lerp(c, n, na);
				rc = lerp(rc, rc1, n.a);

	var pc : PoolColorArray = PoolColorArray()
	pc.append(Color(rc.x, rc.y, rc.z, 1))
	pc.append(c)
	
	return pc
