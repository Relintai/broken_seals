tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

enum CombinerAxisType {
	SINE,
	TRIANGLE,
	SQUARE,
	SAWTOOTH,
	CONSTANT,
	BOUNCE
}

enum  CombinerType {
	MULTIPLY,
	ADD,
	MAX,
	MIN,
	XOR,
	POW
}

static func pattern(uv : Vector2, x_scale : float, y_scale : float, ct : int, catx : int, caty : int) -> float:
	var x : float = 0
	var y : float = 0
	
	#in c++ these ifs should be function pointers or macros in the caller
	if catx == CombinerAxisType.SINE:
		x = Commons.wave_sine(x_scale * uv.x)
	elif catx == CombinerAxisType.TRIANGLE:
		x = Commons.wave_triangle(x_scale * uv.x)
	elif catx == CombinerAxisType.SQUARE:
		x = Commons.wave_square(x_scale * uv.x)
	elif catx == CombinerAxisType.SAWTOOTH:
		x = Commons.wave_sawtooth(x_scale * uv.x)
	elif catx == CombinerAxisType.CONSTANT:
		x = Commons.wave_constant(x_scale * uv.x)
	elif catx == CombinerAxisType.BOUNCE:
		x = Commons.wave_bounce(x_scale * uv.x)
		
	if caty == CombinerAxisType.SINE:
		y = Commons.wave_sine(y_scale * uv.y)
	elif caty == CombinerAxisType.TRIANGLE:
		y = Commons.wave_triangle(y_scale * uv.y)
	elif caty == CombinerAxisType.SQUARE:
		y = Commons.wave_square(y_scale * uv.y)
	elif caty == CombinerAxisType.SAWTOOTH:
		y = Commons.wave_sawtooth(y_scale * uv.y)
	elif caty == CombinerAxisType.CONSTANT:
		y = Commons.wave_constant(y_scale * uv.y)
	elif caty == CombinerAxisType.BOUNCE:
		y = Commons.wave_bounce(y_scale * uv.y)
	
	if ct == CombinerType.MULTIPLY:
		return Commons.mix_mul(x, y)
	elif ct == CombinerType.ADD:
		return Commons.mix_add(x, y);
	elif ct == CombinerType.MAX:
		return Commons.mix_max(x, y);
	elif ct == CombinerType.MIN:
		return Commons.mix_min(x, y);
	elif ct == CombinerType.XOR:
		return Commons.mix_xor(x, y);
	elif ct == CombinerType.POW:
		return Commons.mix_pow(x, y);
		
	return 0.0

static func truchet1c(uv : Vector2, pseed : Vector2) -> Color:
	var f : float = truchet1(uv, pseed)
	return Color(f, f, f, 1);

static func truchet1(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = Commons.floorv2(uv);
	var f : Vector2 = Commons.fractv2(uv) - Vector2(0.5, 0.5);
	return 1.0 - abs(abs((2.0*Commons.step(Commons.rand(i+pseed), 0.5)-1.0)*f.x+f.y)-0.5);

static func truchet2c(uv : Vector2, pseed : Vector2) -> Color:
	var f : float = truchet2(uv, pseed)
	return Color(f, f, f, 1);

static func truchet2(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = Commons.floorv2(uv);
	var f : Vector2 = Commons.fractv2(uv);
	var random : float = Commons.step(Commons.rand(i+pseed), 0.5);
	f.x *= 2.0 * random-1.0;
	f.x += 1.0 - random;
	return 1.0 - min(abs(f.length() - 0.5), abs((Vector2(1, 1) - f).length() - 0.5));

static func weavec(uv : Vector2, count : Vector2, width : float) -> Color:
	var f : float = weave(uv, count, width);

	return Color(f, f, f, 1)

static func weave(uv : Vector2, count : Vector2, width : float) -> float:
	uv *= count;
	var c : float = (sin(3.1415926* (uv.x + floor(uv.y)))*0.5+0.5)*Commons.step(abs(Commons.fract(uv.y)-0.5), width*0.5);
	c = max(c, (sin(3.1415926*(1.0+uv.y+floor(uv.x)))*0.5+0.5)*Commons.step(abs(Commons.fract(uv.x)-0.5), width*0.5));
	return c;

static func sinewavec(uv : Vector2, amplitude : float, frequency : float, phase : float) -> Color:
	var f : float = 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
	return Color(f, f, f, 1)
	
static func sinewavef(uv : Vector2, amplitude : float, frequency : float, phase : float) -> float:
	return 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
static func scratch(uv : Vector2, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var subdivide : float = floor(1.0/size.x);
	var cut : float = size.x*subdivide;
	uv *= subdivide;
	var r1 : Vector2 = Commons.rand2(Commons.floorv2(uv) + pseed);
	var r2 : Vector2 = Commons.rand2(r1);
	uv = Commons.fractv2(uv);
	uv = 2.0 * uv - Vector2(1, 1);
	
	var a : float = 6.28*(angle+(r1.x-0.5)*randomness);
	var c : float = cos(a);
	var s : float = sin(a);
	
	uv = Vector2(c*uv.x+s*uv.y, s*uv.x-c*uv.y);
	uv.y += 2.0*r1.y-1.0;
	uv.y += 0.5*waviness*cos(2.0*uv.x+6.28*r2.y);
	uv.x /= cut;
	uv.y /= subdivide*size.y;
	
	return (1.0-uv.x*uv.x)*max(0.0, 1.0-1000.0*uv.y*uv.y);

static func scratches(uv : Vector2, layers : int, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var v : float = 0.0;
	
	for i in range(layers):# (int i = 0; i < layers; ++i) {
		v = max(v, scratch(Commons.fractv2(uv + pseed), size, waviness, angle/360.0, randomness, pseed));
		pseed = Commons.rand2(pseed);

	return v;

static func scratchesc(uv : Vector2, layers : int, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> Color:
	var f : float = scratches(uv, layers, size, waviness, angle, randomness, pseed)
	
	return Color(f, f, f, 1)

static func runesc(uv : Vector2, col_row : Vector2) -> Color:
	var f : float = rune(col_row * uv);

	return Color(f, f, f, 1)

static func runesf(uv : Vector2, col_row : Vector2) -> float:
	return rune(col_row * uv);

# makes a rune in the 0..1 uv space. Seed is which rune to draw.
# passes back gray in x and derivates for lighting in yz
static func rune(uv : Vector2) -> float:
	var finalLine : float = 0.0;
	var pseed : Vector2 = Commons.floorv2(uv) - Vector2(0.41, 0.41);
	
	uv = Commons.fractv2(uv);
	
	for i in range(4):# (int i = 0; i < 4; i++):  #	// number of strokes
		var posA : Vector2 = Commons.rand2(Commons.floorv2(pseed + Vector2(0.5, 0.5)));
		var posB : Vector2 = Commons.rand2(Commons.floorv2(pseed + Vector2(1.5, 1.5)));
		pseed.x += 2.0;
		pseed.y += 2.0;
		
		# expand the range and mod it to get a nicely distributed random number - hopefully. :)
		
		posA = Commons.fractv2(posA * 128.0);
		posB = Commons.fractv2(posB * 128.0);
		
		# each rune touches the edge of its box on all 4 sides
		if (i == 0):
			posA.y = 0.0;
			
		if (i == 1):
			posA.x = 0.999;
			
		if (i == 2):
			posA.x = 0.0;
			
		if (i == 3):
			posA.y = 0.999;
		
		# snap the random line endpoints to a grid 2x3
		
		var snaps : Vector2 = Vector2(2.0, 3.0);
		
		posA = (Commons.floorv2(posA * snaps) + Vector2(0.5, 0.5)) / snaps; # + 0.5 to center it in a grid cell
		posB = (Commons.floorv2(posB * snaps) + Vector2(0.5, 0.5)) / snaps;
		
		#if (distance(posA, posB) < 0.0001) continue;	// eliminate dots.
		# Dots (degenerate lines) are not cross-GPU safe without adding 0.001 - divide by 0 error.
		
		finalLine = max(finalLine, Commons.ThickLine(uv, posA, posB + Vector2(0.001, 0.001), 20.0));
	
	return finalLine;

static func IChingc(uv : Vector2, row_col : Vector2, pseed : int) -> Color:
	var f : float =  IChing(row_col * uv, float(pseed));

	return Color(f, f, f, 1)

static func IChing(uv : Vector2, pseed : float) -> float:
	var value : int = int(32.0 * Commons.rand(Commons.floorv2(uv) + Vector2(pseed, pseed)));
	var base : float = Commons.step(0.5, Commons.fract(Commons.fract(uv.y)*6.5))*Commons.step(0.04, Commons.fract(uv.y+0.02)) * Commons.step(0.2, Commons.fract(uv.x+0.1));
	var bit : int = int(Commons.fract(uv.y)*6.5);
	
	return base * Commons.step(0.1*Commons.step(float(bit & value), 0.5), Commons.fract(uv.x+0.55));

static func beehive_1c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	return Color(f, f, f, 1)
	
static func beehive_2c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	var v : Vector3 = Commons.rand3(Commons.fractv2(Vector2(center.b, center.a) / Vector2(size.x, size.y)) + Vector2(float(pseed),float(pseed)));
	
	return Color(v.x, v.y, v.z, 1)

static func beehive_3c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	#var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	var v1 : Vector2 = Vector2(0.5, 0.5) + Vector2(center.r, center.g)
	var ff : float = Commons.rand(Commons.fractv2(Vector2(center.b, center.a) / Vector2(size.x, size.y)) + Vector2(float(pseed), float(pseed)))
	
	var c : Color = Color(v1.x, v1.y, ff, ff);
	
	return c

static func beehive_dist(p : Vector2) -> float:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	p = Commons.absv2(p);
	
	return max(p.dot(s*.5), p.x);

static func beehive_center(p : Vector2) -> Color:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	var hC : Color = Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y);
	
	hC = Commons.floorc(Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y)) + Color(0.5, 0.5, 0.5, 0.5);
	
	var v1 : Vector2 = Vector2(p.x - hC.r * s.x, p.y - hC.g * s.y)
	var v2 : Vector2 = Vector2(p.x - (hC.b + 0.5) * s.x, p.y - (hC.a + 0.5) * s.y)
	
	var h : Color = Color(v1.x, v1.y, v2.x, v2.y);
	
	if Vector2(h.r, h.g).dot(Vector2(h.r, h.g)) < Vector2(h.b, h.a).dot(Vector2(h.b, h.a)):
		return Color(h.r, h.g, hC.r, hC.g) 
	else:
		return Color(h.b, h.a, hC.b + 9.73, hC.a + 9.73)
	
	#return dot(h.xy, h.xy) < dot(h.zw, h.zw) ? Color(h.xy, hC.xy) : Color(h.zw, hC.zw + 9.73);


static func brick_corner_uv(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, corner : float, pseed : float) -> Vector3:
	var center : Vector2 = 0.5 * (bmin + bmax)
	var size : Vector2 = bmax - bmin
	var max_size : float = max(size.x, size.y)
	var min_size : float = min(size.x, size.y)
	mortar *= min_size
	corner *= min_size
	
	var r : Vector3 = Vector3()
	
	r.x = clamp(((0.5 * size.x - mortar) - abs(uv.x - center.x)) / corner, 0, 1)
	r.y = clamp(((0.5 * size.y - mortar) - abs(uv.y - center.y)) / corner, 0, 1)
	r.z = Commons.rand(Commons.fractv2(center) + Vector2(pseed, pseed))

	return r
	
#	return vec3(clamp((0.5*size-vec2(mortar)-abs(uv-center))/corner, vec2(0.0), vec2(1.0)), rand(fract(center)+vec2(seed)));


static func brick(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, pround : float, bevel : float) -> Color:
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

static func brick_uv(uv : Vector2, bmin : Vector2, bmax : Vector2, pseed : float) -> Vector3:
	var center : Vector2 = 0.5 * (bmin + bmax)
	var size : Vector2 = bmax - bmin
	var max_size : float = max(size.x, size.y)
	
	var x : float = 0.5+ (uv.x - center.x) / max_size
	var y : float = 0.5+ (uv.y - center.y) /max_size
	
	return Vector3(x, y, Commons.rand(Commons.fractv2(center) + Vector2(pseed, pseed)))
	
static func bricks_rb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat
	
	var x_offset : float = offset * Commons.step(0.5, Commons.fractf(uv.y * count.y * 0.5))
	
	var bmin : Vector2
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)
	
	bmin.x += x_offset;
	bmin /= count
	var bmc : Vector2 = bmin + Vector2(1.0, 1.0) /  count

	return Color(bmin.x, bmin.y, bmc.x, bmc.y)
	
static func bricks_rb2(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat

	var x_offset : float = offset * Commons.step(0.5, Commons.fractf(uv.y * count.y * 0.5))
	count.x = count.x * (1.0+Commons.step(0.5, Commons.fractf(uv.y * count.y * 0.5)))
	var bmin : Vector2 = Vector2()
	
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)

	bmin.x += x_offset
	bmin /= count
	
	var b : Vector2 = bmin + Vector2(1, 1) / count
	
	return Color(bmin.x, bmin.y, b.x, b.y)
	
static func bricks_hb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var pc : float = count.x + count.y
	var c : float = pc * repeat
	
	var corner : Vector2 = Vector2(floor(uv.x * c), floor(uv.y * c))
	var cdiff : float = Commons.modf(corner.x - corner.y, pc)

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
		
static func bricks_bw(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var c : Vector2 = 2.0 * count * repeat
	var mc : float = max(c.x, c.y)
	var corner1 : Vector2 = Vector2(floor(uv.x * c.x), floor(uv.y * c.y))
	var corner2 : Vector2 = Vector2(count.x * floor(repeat* 2.0 * uv.x), count.y * floor(repeat * 2.0 * uv.y))
	
	var tmp : Vector2 = Vector2(floor(repeat * 2.0 * uv.x), floor(repeat * 2.0 * uv.y))
	var cdiff : float = Commons.modf(tmp.dot(Vector2(1, 1)), 2.0)
	
	var corner : Vector2
	var size : Vector2

	if cdiff == 0:
		corner = Vector2(corner1.x, corner2.y)
		size = Vector2(1.0, count.y)
	else:
		corner = Vector2(corner2.x, corner1.y)
		size = Vector2(count.x, 1.0)

	return Color(corner.x / c.x, corner.y / c.y, (corner.x + size.x) / c.x, (corner.y + size.y) / c.y)

static func bricks_sb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
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
