tool
extends TextureRect

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

func _ready():
	pass
	
	
#float o39644_0_2_f : float = o39644_0.x
var seed_o39644 : int = 15005
var p_o39644_repeat : float = 1.000000000
var p_o39644_rows : float = 6.000000000
var p_o39644_columns : float = 3.000000000
var p_o39644_row_offset : float = 0.500000000
var p_o39644_mortar: float = 0.100000000
var p_o39644_bevel : float = 0.100000000
var p_o39644_round : float= 0.000000000
var p_o39644_corner : float = 0.420000000


var p_o3335_albedo_color_r : float = 1.000000000
var p_o3335_albedo_color_g : float = 1.000000000
var p_o3335_albedo_color_b : float = 1.000000000
var p_o3335_albedo_color_a : float = 1.000000000
var p_o3335_metallic : float = 1.000000000
var p_o3335_roughness : float = 1.000000000
var p_o3335_emission_energy : float = 1.000000000
var p_o3335_normal : float = 1.000000000
var p_o3335_ao : float = 1.000000000
var p_o3335_depth_scale : float = 0.500000000
var p_o3335_sss : float = 0.000000000



func gen() -> void:
	if !image:
		image = Image.new()
		image.create(300, 300, false, Image.FORMAT_RGBA8)
		
	if !tex:
		tex = ImageTexture.new()
		
#	var bmin : Vector2 = Vector2(0.1, 0.1)
#	var bmax : Vector2 = Vector2(1, 1)

	image.lock()
	
	var w : float = image.get_width()
	var h : float = image.get_width()
	
	var pseed : float = randf() + randi()
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var v : Vector2 = Vector2(x / w, y / h)

#			var vb : Vector3 = brick_uv(v, bmin, bmax, pseed)
##			var col : Color = Color(vb.x, vb.y, vb.z, 1)
#
#			var col : Color = brick(v, bmin, bmax, 0.2, 0.2, 0.2)
#			var cc : Color = Color(vb.x, vb.y, vb.z, 1)
#			image.set_pixel(x, y, cc)
			
			#Running Bond
#			var brect : Color = bricks_rb(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			#RunningBond2
#			var brect : Color = bricks_rb2(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			#HerringBone
#			var brect : Color = bricks_hb(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			#BasketWeave
#			var brect : Color = bricks_bw(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			#SpanishBond
			var brect : Color = bricks_sb(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			
			# 1, 2
			var fcolor : Color = brick(v, Vector2(brect.r, brect.g),  Vector2(brect.b, brect.a), p_o39644_mortar*1.0, p_o39644_round*1.0, max(0.001, p_o39644_bevel*1.0));
			
#			image.set_pixel(x, y, brect)
#			image.set_pixel(x, y, fcolor)
#			image.set_pixel(x, y, Color(fcolor.r, fcolor.g, fcolor.b, 1))

			#1
			var rr : float = fcolor.r;
			image.set_pixel(x, y, Color(rr,rr, rr, 1))
#
#			# 3
#			var yy : float = fcolor.g;
#			image.set_pixel(x, y, Color(yy,yy, yy, 1))
#
#			# 4
#			var zz : float = fcolor.b;
#			image.set_pixel(x, y, Color(zz,zz, zz, 1))
			
			# 5
#			var c : Vector3 = brick_uv(v, Vector2(brect.r, brect.g),  Vector2(brect.b, brect.a), float(seed_o39644))
#			image.set_pixel(x, y, Color(c.x, c.y, c.z, 1))

			# 6
#			var c : Vector3 = brick_corner_uv(v, Vector2(brect.r, brect.g),  Vector2(brect.b, brect.a), p_o39644_mortar*1.0, p_o39644_corner, float(seed_o39644));
#			image.set_pixel(x, y, Color(c.x, c.y, c.z, 1))


			# 7
#			var f : float = 0.5*(sign(brect.b-brect.r-brect.a+brect.g)+1.0);
#			image.set_pixel(x, y, Color(f, f, f, 1))

			
			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

func brick_corner_uv(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, corner : float, pseed : float) -> Vector3:
	var center : Vector2 = 0.5 * (bmin + bmax)
	var size : Vector2 = bmax - bmin
	var max_size : float = max(size.x, size.y)
	var min_size : float = min(size.x, size.y)
	mortar *= min_size
	corner *= min_size
	
	var r : Vector3 = Vector3()
	
	r.x = clamp(((0.5 * size.x - mortar) - abs(uv.x - center.x)) / corner, 0, 1)
	r.y = clamp(((0.5 * size.y - mortar) - abs(uv.y - center.y)) / corner, 0, 1)
	r.z = rand(fract(center) + Vector2(pseed, pseed))

	return r
	
#	return vec3(clamp((0.5*size-vec2(mortar)-abs(uv-center))/corner, vec2(0.0), vec2(1.0)), rand(fract(center)+vec2(seed)));


func brick(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, pround : float, bevel : float) -> Color:
	var color : float
	var size : Vector2 = bmax - bmin

	var min_size : float = min(size.x, size.y)
	mortar *= min_size
	bevel *= min_size
	pround *= min_size

	var center : Vector2 = 0.5 * (bmin + bmax)
	var d : Vector2 = Vector2()
	
	d.x = abs(uv.x - center.x) - 0.5 * (size.x) + (pround + mortar)
	d.y = abs(uv.y - center.y) - 0.5 * (size.y) + (pround + mortar)
	
	color = Vector2(max(d.x, 0), max(d.y, 0)).length() + min(max(d.x, d.y), 0.0) - pround
	
	color = clamp(-color / bevel, 0.0, 1.0)

#	var tiled_brick_pos : Vector2 = Vector2(bmin.x - 1.0 * floor(bmin.x / 1.0), bmin.y - 1.0 * floor(bmin.y / 1.0))

	var tiled_brick_pos_x : float = bmin.x - 1.0 * floor(bmin.x / 1.0)
	var tiled_brick_pos_y : float = bmin.y - 1.0 * floor(bmin.y / 1.0)
	
	#vec2 tiled_brick_pos = mod(bmin, vec2(1.0, 1.0));
	
	return Color(color, center.x, center.y, tiled_brick_pos_x + 7.0 * tiled_brick_pos_y)

func brick_uv(uv : Vector2, bmin : Vector2, bmax : Vector2, pseed : float) -> Vector3:
	var center : Vector2 = 0.5 * (bmin + bmax)
	var size : Vector2 = bmax - bmin
	var max_size : float = max(size.x, size.y)
	
	var x : float = 0.5+ (uv.x - center.x) / max_size
	var y : float = 0.5+ (uv.y - center.y) /max_size
	
	return Vector3(x, y, rand(fract(center) + Vector2(pseed, pseed)))
	
func bricks_rb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat
	
	var x_offset : float = offset * step(0.5, fractf(uv.y * count.y * 0.5))
	
	var bmin : Vector2
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)
	
	bmin.x += x_offset;
	bmin /= count
	var bmc : Vector2 = bmin + Vector2(1.0, 1.0) /  count

	return Color(bmin.x, bmin.y, bmc.x, bmc.y)
	
func bricks_rb2(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat

	var x_offset : float = offset * step(0.5, fractf(uv.y * count.y * 0.5))
	count.x = count.x * (1.0+step(0.5, fractf(uv.y * count.y * 0.5)))
	var bmin : Vector2 = Vector2()
	
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)

	bmin.x += x_offset
	bmin /= count
	
	var b : Vector2 = bmin + Vector2(1, 1) / count
	
	return Color(bmin.x, bmin.y, b.x, b.y)
	
func bricks_hb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var pc : float = count.x + count.y
	var c : float = pc * repeat
	
	var corner : Vector2 = Vector2(floor(uv.x * c), floor(uv.y * c))
	var cdiff : float = modf(corner.x - corner.y, pc)

	if (cdiff < count.x):
		var col : Color = Color()
		
		col.r = (corner.x - cdiff) / c
		col.g = corner.y / c
		
		col.b = (corner.x - cdiff + count.x) / c
		col.a = (corner.y + 1.0) / c
		
		return col
	else:
		var col : Color = Color()
		
		col.r = corner.x / c
		col.g = (corner.y - (pc - cdiff - 1.0)) / c
		
		col.b = (corner.x + 1.0) / c
		col.a = (corner.y - (pc - cdiff - 1.0) + count.y) / c
		
		return col
		
func bricks_bw(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var c : Vector2 = 2.0 * count * repeat
	var mc : float = max(c.x, c.y)
	var corner1 : Vector2 = Vector2(floor(uv.x * c.x), floor(uv.y * c.y))
	var corner2 : Vector2 = Vector2(count.x * floor(repeat* 2.0 * uv.x), count.y * floor(repeat * 2.0 * uv.y))
	
	var tmp : Vector2 = Vector2(floor(repeat * 2.0 * uv.x), floor(repeat * 2.0 * uv.y))
	var cdiff : float = modf(tmp.dot(Vector2(1, 1)), 2.0)
	
	var corner : Vector2
	var size : Vector2

	if cdiff == 0:
		corner = Vector2(corner1.x, corner2.y)
		size = Vector2(1.0, count.y)
	else:
		corner = Vector2(corner2.x, corner1.y)
		size = Vector2(count.x, 1.0)

	return Color(corner.x / c.x, corner.y / c.y, (corner.x + size.x) / c.x, (corner.y + size.y) / c.y)

func bricks_sb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var c : Vector2 = (count + Vector2(1, 1)) * repeat
	var mc : float = max(c.x, c.y)
	var corner1 : Vector2 = Vector2(floor(uv.x * c.x), floor(uv.y * c.y))
	var corner2 : Vector2 = (count + Vector2(1, 1)) * Vector2(floor(repeat * uv.x), floor(repeat * uv.y))
	var rcorner : Vector2 = corner1 - corner2

	var corner : Vector2
	var size : Vector2

	if (rcorner.x == 0.0 && rcorner.y < count.y):
		corner = corner2
		size = Vector2(1.0, count.y)
	elif (rcorner.y == 0.0):
		corner = corner2 + Vector2(1.0, 0.0)
		size = Vector2(count.x, 1.0)
	elif (rcorner.x == count.x):
		corner = corner2 + Vector2(count.x, 1.0)
		size = Vector2(1.0, count.y)
	elif (rcorner.y == count.y):
		corner = corner2 + Vector2(0.0, count.y)
		size = Vector2(count.x, 1.0)
	else:
		corner = corner2 + Vector2(1, 1)
		size = Vector2(count.x-1.0, count.y-1.0)

	return Color(corner.x / c.x, corner.y / c.y, (corner.x + size.x) / c.x, (corner.y + size.y) / c.y)

func modf(x : float, y : float) -> float:
	return x - y * floor(x / y)

func fract(v : Vector2) -> Vector2:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	
	return v
	
func fractf(f : float) -> float:
	return f - floor(f)

func rand(x : Vector2) -> float:
	return fractf(cos(x.dot(Vector2(13.9898, 8.141))) * 43758.5453);
	
func step(edge : float, x : float) -> float:
	if x < edge:
		return 0.0
	else:
		return 1.0

#common -----

#float rand(vec2 x) {
#    return fract(cos(dot(x, vec2(13.9898, 8.141))) * 43758.5453);
#}
#
#vec2 rand2(vec2 x) {
#    return fract(cos(vec2(dot(x, vec2(13.9898, 8.141)),
#						  dot(x, vec2(3.4562, 17.398)))) * 43758.5453);
#}
#
#vec3 rand3(vec2 x) {
#    return fract(cos(vec3(dot(x, vec2(13.9898, 8.141)),
#                          dot(x, vec2(3.4562, 17.398)),
#                          dot(x, vec2(13.254, 5.867)))) * 43758.5453);
#}
#
#vec3 rgb2hsv(vec3 c) {
#	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
#	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
#	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
#
#	float d = q.x - min(q.w, q.y);
#	float e = 1.0e-10;
#	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
#}
#
#vec3 hsv2rgb(vec3 c) {
#	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
#	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
#	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
#}


#end common

#
#vec4 $(name_uv)_rect = bricks_$pattern($uv, vec2($columns, $rows), $repeat, $row_offset);
#vec4 $(name_uv) = brick($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $round*$round_map($uv), max(0.001, $bevel*$bevel_map($uv)));
#
#vec4 brick(vec2 uv, vec2 bmin, vec2 bmax, float mortar, float round, float bevel) {
#	float color;
#	vec2 size = bmax - bmin;
#	float min_size = min(size.x, size.y);
#	mortar *= min_size;
#	bevel *= min_size;
#	round *= min_size;
#	vec2 center = 0.5*(bmin+bmax);
#
#	vec2 d = abs(uv-center)-0.5*(size)+vec2(round+mortar);
#	color = length(max(d,vec2(0))) + min(max(d.x,d.y),0.0)-round;
#	color = clamp(-color/bevel, 0.0, 1.0);
#	vec2 tiled_brick_pos = mod(bmin, vec2(1.0, 1.0));
#
#	return vec4(color, center, tiled_brick_pos.x+7.0*tiled_brick_pos.y);
#}
#
#vec3 brick_uv(vec2 uv, vec2 bmin, vec2 bmax, float seed) {
#	vec2 center = 0.5*(bmin + bmax);
#	vec2 size = bmax - bmin;
#	float max_size = max(size.x, size.y);
#
#	return vec3(0.5+(uv-center)/max_size, rand(fract(center)+vec2(seed)));
#}
#
#vec3 brick_corner_uv(vec2 uv, vec2 bmin, vec2 bmax, float mortar, float corner, float seed) {
#	vec2 center = 0.5*(bmin + bmax);
#	vec2 size = bmax - bmin;
#	float max_size = max(size.x, size.y);
#	float min_size = min(size.x, size.y);
#	mortar *= min_size;\n\tcorner *= min_size;
#
#	return vec3(clamp((0.5*size-vec2(mortar)-abs(uv-center))/corner, vec2(0.0), vec2(1.0)), rand(fract(center)+vec2(seed)));
#}
#
#vec4 bricks_rb(vec2 uv, vec2 count, float repeat, float offset) {
#	count *= repeat;
#	float x_offset = offset*step(0.5, fract(uv.y*count.y*0.5));
#	vec2 bmin = floor(vec2(uv.x*count.x-x_offset, uv.y*count.y));
#	bmin.x += x_offset;\n\tbmin /= count;
#
#	return vec4(bmin, bmin+vec2(1.0)/count);
#}
#
#vec4 bricks_rb2(vec2 uv, vec2 count, float repeat, float offset) {
#	count *= repeat;
#
#	float x_offset = offset*step(0.5, fract(uv.y*count.y*0.5));
#	count.x = count.x*(1.0+step(0.5, fract(uv.y*count.y*0.5)));
#	vec2 bmin = floor(vec2(uv.x*count.x-x_offset, uv.y*count.y));
#
#	bmin.x += x_offset;
#	bmin /= count;
#	return vec4(bmin, bmin+vec2(1.0)/count);
#}
#
#vec4 bricks_hb(vec2 uv, vec2 count, float repeat, float offset) {
#	float pc = count.x+count.y;
#	float c = pc*repeat;
#	vec2 corner = floor(uv*c);
#	float cdiff = mod(corner.x-corner.y, pc);
#
#	if (cdiff < count.x) {
#		return vec4((corner-vec2(cdiff, 0.0))/c, (corner-vec2(cdiff, 0.0)+vec2(count.x, 1.0))/c);
#	} else {
#		return vec4((corner-vec2(0.0, pc-cdiff-1.0))/c, (corner-vec2(0.0, pc-cdiff-1.0)+vec2(1.0, count.y))/c);
#	}
#}
#
#vec4 bricks_bw(vec2 uv, vec2 count, float repeat, float offset) {
#	vec2 c = 2.0*count*repeat;
#	float mc = max(c.x, c.y);
#	vec2 corner1 = floor(uv*c);
#	vec2 corner2 = count*floor(repeat*2.0*uv);
#	float cdiff = mod(dot(floor(repeat*2.0*uv), vec2(1.0)), 2.0);
#	vec2 corner;
#	vec2 size;
#
#	if (cdiff == 0.0) {
#		corner = vec2(corner1.x, corner2.y);
#		size = vec2(1.0, count.y);
#	} else {
#		corner = vec2(corner2.x, corner1.y);
#		size = vec2(count.x, 1.0);
#	}
#
#	return vec4(corner/c, (corner+size)/c);
#}
#
#vec4 bricks_sb(vec2 uv, vec2 count, float repeat, float offset) {
#	vec2 c = (count+vec2(1.0))*repeat;
#	float mc = max(c.x, c.y);
#	vec2 corner1 = floor(uv*c);
#	vec2 corner2 = (count+vec2(1.0))*floor(repeat*uv);
#	vec2 rcorner = corner1 - corner2;
#
#	vec2 corner;
#	vec2 size;
#
#	if (rcorner.x == 0.0 && rcorner.y < count.y) {
#		corner = corner2;
#		size = vec2(1.0, count.y);
#	} else if (rcorner.y == 0.0) {
#		corner = corner2+vec2(1.0, 0.0);
#		size = vec2(count.x, 1.0);
#	} else if (rcorner.x == count.x) {
#		corner = corner2+vec2(count.x, 1.0);
#		size = vec2(1.0, count.y);
#	} else if (rcorner.y == count.y) {
#		corner = corner2+vec2(0.0, count.y);
#		size = vec2(count.x, 1.0);
#	} else {
#		corner = corner2+vec2(1.0);
#		size = vec2(count.x-1.0, count.y-1.0);
#	}
#
#	return vec4(corner/c, (corner+size)/c);
#}


func reffg():
	return false

func reff(bb):
	if bb:
		gen()

