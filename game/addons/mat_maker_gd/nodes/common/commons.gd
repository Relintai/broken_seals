extends Reference

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


static func clampv3(v : Vector3, mi : Vector3, ma : Vector3) -> Vector3:
	v.x = clamp(v.x, mi.x, ma.x)
	v.y = clamp(v.y, mi.y, ma.y)
	v.y = clamp(v.z, mi.z, ma.z)
	
	return v

static func floorc(a : Color) -> Color:
	var v : Color = Color()
	
	v.r = floor(a.r)
	v.g = floor(a.g)
	v.b = floor(a.b)
	v.a = floor(a.a)
	
	return v


static func floorv2(a : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = floor(a.x)
	v.y = floor(a.y)
	
	return v
	
static func smoothstepv2(a : float, b : float, c : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = smoothstep(a, b, c.x)
	v.y = smoothstep(a, b, c.y)
	
	return v

static func maxv2(a : Vector2, b : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = max(a.x, b.x)
	v.y = max(a.y, b.y)
	
	return v

static func maxv3(a : Vector3, b : Vector3) -> Vector3:
	var v : Vector3 = Vector3()
	
	v.x = max(a.x, b.x)
	v.y = max(a.y, b.y)
	v.z = max(a.z, b.z)
	
	return v

static func absv2(v : Vector2) -> Vector2:
	v.x = abs(v.x)
	v.y = abs(v.y)
	
	return v
	
static func absv3(v : Vector3) -> Vector3:
	v.x = abs(v.x)
	v.y = abs(v.y)
	v.y = abs(v.y)
	
	return v

static func cosv2(v : Vector2) -> Vector2:
	v.x = cos(v.x)
	v.y = cos(v.y)
	
	return v

static func cosv3(v : Vector3) -> Vector3:
	v.x = cos(v.x)
	v.y = cos(v.y)
	v.y = cos(v.y)
	
	return v

static func modv3(a : Vector3, b : Vector3) -> Vector3:
	var v : Vector3 = Vector3()
	
	v.x = modf(a.x, b.x)
	v.y = modf(a.y, b.y)
	v.z = modf(a.z, b.z)
	
	return v
	
	
static func modv2(a : Vector2, b : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = modf(a.x, b.x)
	v.y = modf(a.y, b.y)

	return v

static func modf(x : float, y : float) -> float:
	return x - y * floor(x / y)

static func fractv2(v : Vector2) -> Vector2:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	
	return v
	
static func fractv3(v : Vector3) -> Vector3:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	v.z = v.z - floor(v.z)
	
	return v
	
static func fract(f : float) -> float:
	return f - floor(f)

static func clampv2(v : Vector2, pmin : Vector2, pmax : Vector2) -> Vector2:
	v.x = clamp(v.x, pmin.x, pmax.x)
	v.y = clamp(v.y, pmin.y, pmax.y)
	
	return v

static func rand(x : Vector2) -> float:
	return fract(cos(x.dot(Vector2(13.9898, 8.141))) * 43758.5453);

static func rand2(x : Vector2) -> Vector2:
	return fractv2(cosv2(Vector2(x.dot(Vector2(13.9898, 8.141)),
						  x.dot(Vector2(3.4562, 17.398)))) * 43758.5453);

static func rand3(x : Vector2) -> Vector3:
	return fractv3(cosv3(Vector3(x.dot(Vector2(13.9898, 8.141)),
						  x.dot(Vector2(3.4562, 17.398)),
						  x.dot(Vector2(13.254, 5.867)))) * 43758.5453);

static func step(edge : float, x : float) -> float:
	if x < edge:
		return 0.0
	else:
		return 1.0


static func rgb_to_hsv(c : Vector3) -> Vector3:
	var K : Color = Color(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	
	var p : Color 
	
	if c.y < c.z:
		p = Color(c.z, c.y, K.a, K.b)
	else:
		p = Color(c.y, c.z, K.r, K.g);
	
	var q : Color
	
	if c.x < p.r:
		q = Color(p.r, p.g, p.a, c.x)
	else:
		q = Color(c.x, p.g, p.b, p.r);

	var d : float = q.r - min(q.a, q.g);
	var e : float = 1.0e-10;
	
	return Vector3(abs(q.b + (q.a - q.g) / (6.0 * d + e)), d / (q.r + e), q.r);

static func hsv_to_rgb(c : Vector3) -> Vector3:
	var K : Color = Color(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	
	var p : Vector3 = absv3(fractv3(Vector3(c.x, c.x, c.x) + Vector3(K.r, K.g, K.b)) * 6.0 - Vector3(K.a, K.a, K.a));
	
	return c.z * lerp(Vector3(K.r, K.r, K.r), clampv3(p - Vector3(K.r, K.r, K.r), Vector3(), Vector3(1, 1, 1)), c.y);

static func transform(uv : Vector2, translate : Vector2, rotate : float, scale : Vector2, repeat : bool) -> Vector2:
	var rv : Vector2 = Vector2();
	uv -= translate;
	uv -= Vector2(0.5, 0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += Vector2(0.5, 0.5);
	
	if (repeat):
		return fractv2(rv);
	else:
		return clampv2(rv, Vector2(0, 0), Vector2(1, 1));


static func color_dots(uv : Vector2, size : float, pseed : int) -> Vector3:
	var seed2 : Vector2 = rand2(Vector2(float(pseed), 1.0 - float(pseed)));
	uv /= size;
	var point_pos : Vector2 = floorv2(uv) + Vector2(0.5, 0.5);
	return rand3(seed2 + point_pos);


static func voronoi(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var seed2 : Vector2 = rand2(Vector2(float(pseed), 1.0-float(pseed)));
	uv *= size;
	var best_distance0 : float = 1.0;
	var best_distance1 : float = 1.0;
	var point0 : Vector2;
	var point1 : Vector2;
	var p0 : Vector2 = floorv2(uv);
	
	for dx in range(-1, 2):# (int dx = -1; dx < 2; ++dx) {
		for dy in range(-1, 2):# (int dy = -1; dy < 2; ++dy) {
			var d : Vector2 = Vector2(float(dx), float(dy));
			var p : Vector2 = p0+d;
			
			p += randomness * rand2(seed2 + modv2(p, size));
			var distance : float = (stretch * (uv - p) / size).length();
			
			if (best_distance0 > distance):
				best_distance1 = best_distance0;
				best_distance0 = distance;
				point1 = point0;
				point0 = p;
			elif (best_distance1 > distance):
				best_distance1 = distance;
				point1 = p;

	var edge_distance : float = (uv - 0.5*(point0+point1)).dot((point0-point1).normalized());
	
	return Color(point0.x, point0.y, best_distance0 * (size).length() * intensity, edge_distance);


static func perlin(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> float:
	var seed2 : Vector2 = rand2(Vector2(float(pseed), 1.0-float(pseed)));
	var rv : float = 0.0;
	var coef : float = 1.0;
	var acc : float = 0.0;
	
	for i in range(iterations):
		var step : Vector2 = Vector2(1, 1) / size;
		var xy : Vector2 = floorv2(uv * size);
		var f0 : float = rand(seed2 + modv2(xy, size));
		var f1 : float = rand(seed2 + modv2(xy + Vector2(1.0, 0.0), size));
		var f2 : float = rand(seed2 + modv2(xy + Vector2(0.0, 1.0), size));
		var f3 : float = rand(seed2 + modv2(xy + Vector2(1.0, 1.0), size));

		var mixval : Vector2 = smoothstepv2(0.0, 1.0, fractv2(uv * size));
		
		rv += coef * lerp(lerp(f0, f1, mixval.x), lerp(f2, f3, mixval.x), mixval.y);
		acc += coef;
		size *= 2.0;
		coef *= persistence;

	
	return rv / acc;

static func perlin_color(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Vector3:
	var seed2 : Vector2 = rand2(Vector2(float(pseed), 1.0 - float(pseed)));
	var rv : Vector3 = Vector3();
	var coef : float = 1.0;
	var acc : float = 0.0;
	
	for i in range(iterations):
		var step : Vector2 = Vector2(1, 1) / size;
		var xy : Vector2 = floorv2(uv * size);
		
		var f0 : Vector3 = rand3(seed2 + modv2(xy, size));
		var f1 : Vector3 = rand3(seed2 + modv2(xy + Vector2(1.0, 0.0), size));
		var f2 : Vector3 = rand3(seed2 + modv2(xy + Vector2(0.0, 1.0), size));
		var f3 : Vector3 = rand3(seed2 + modv2(xy + Vector2(1.0, 1.0), size));

		var mixval : Vector2 = smoothstepv2(0.0, 1.0, fractv2(uv * size));
		
		rv += coef * lerp(lerp(f0, f1, mixval.x), lerp(f2, f3, mixval.x), mixval.y);
		
		acc += coef;
		size *= 2.0;
		coef *= persistence;

	return rv / acc;


static func beehive_dist(p : Vector2) -> float:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	p = absv2(p);
	
	return max(p.dot(s*.5), p.x);

static func beehive_center(p : Vector2) -> Color:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	var hC : Color = Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y);
	
	hC = floorc(Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y)) + Color(0.5, 0.5, 0.5, 0.5);
	
	var v1 : Vector2 = Vector2(p.x - hC.r * s.x, p.y - hC.g * s.y)
	var v2 : Vector2 = Vector2(p.x - (hC.b + 0.5) * s.x, p.y - (hC.a + 0.5) * s.y)
	
	var h : Color = Color(v1.x, v1.y, v2.x, v2.y);
	
	if Vector2(h.r, h.g).dot(Vector2(h.r, h.g)) < Vector2(h.b, h.a).dot(Vector2(h.b, h.a)):
		return Color(h.r, h.g, hC.r, hC.g) 
	else:
		return Color(h.b, h.a, hC.b + 9.73, hC.a + 9.73)
	
	#return dot(h.xy, h.xy) < dot(h.zw, h.zw) ? Color(h.xy, hC.xy) : Color(h.zw, hC.zw + 9.73);



static func pattern(uv : Vector2, x_scale : float, y_scale : float, ct : int, catx : int, caty : int) -> float:
	var x : float = 0
	var y : float = 0
	
	#in c++ these ifs should be function pointers or macros in the caller
	if catx == CombinerAxisType.SINE:
		x = wave_sine(x_scale * uv.x)
	elif catx == CombinerAxisType.TRIANGLE:
		x = wave_triangle(x_scale * uv.x)
	elif catx == CombinerAxisType.SQUARE:
		x = wave_square(x_scale * uv.x)
	elif catx == CombinerAxisType.SAWTOOTH:
		x = wave_sawtooth(x_scale * uv.x)
	elif catx == CombinerAxisType.CONSTANT:
		x = wave_constant(x_scale * uv.x)
	elif catx == CombinerAxisType.BOUNCE:
		x = wave_bounce(x_scale * uv.x)
		
	if caty == CombinerAxisType.SINE:
		y = wave_sine(y_scale * uv.y)
	elif caty == CombinerAxisType.TRIANGLE:
		y = wave_triangle(y_scale * uv.y)
	elif caty == CombinerAxisType.SQUARE:
		y = wave_square(y_scale * uv.y)
	elif caty == CombinerAxisType.SAWTOOTH:
		y = wave_sawtooth(y_scale * uv.y)
	elif caty == CombinerAxisType.CONSTANT:
		y = wave_constant(y_scale * uv.y)
	elif caty == CombinerAxisType.BOUNCE:
		y = wave_bounce(y_scale * uv.y)
	
	if ct == CombinerType.MULTIPLY:
		return mix_mul(x, y)
	elif ct == CombinerType.ADD:
		return mix_add(x, y);
	elif ct == CombinerType.MAX:
		return mix_max(x, y);
	elif ct == CombinerType.MIN:
		return mix_min(x, y);
	elif ct == CombinerType.XOR:
		return mix_xor(x, y);
	elif ct == CombinerType.POW:
		return mix_pow(x, y);
		
	return 0.0

static func wave_constant(x : float) -> float:
	return 1.0;

static func wave_sine(x : float) -> float:
	return 0.5-0.5*cos(3.14159265359*2.0*x);

static func wave_triangle(x : float) -> float:
	x = fractf(x);
	return min(2.0*x, 2.0-2.0*x);

static func wave_sawtooth(x : float) -> float:
	return fractf(x);

static func wave_square(x : float) -> float:
	if (fractf(x) < 0.5):
		return 0.0
	else:
		return 1.0

static func wave_bounce(x : float) -> float:
	x = 2.0*(fractf(x)-0.5);
	return sqrt(1.0-x*x);

static func mix_mul(x : float, y : float) -> float:
	return x*y;

static func mix_add(x : float, y : float) -> float:
	return min(x+y, 1.0);

static func mix_max(x : float, y : float) -> float:
	return max(x, y);

static func mix_min(x : float, y : float) -> float:
	return min(x, y);

static func mix_xor(x : float, y : float) -> float:
	return min(x+y, 2.0-x-y);

static func mix_pow(x : float, y : float) -> float:
	return pow(x, y);

static func fractf(x : float) -> float:
	return x - floor(x)

static func invert(color : Color) -> Color:
	return Color(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);

static func ThickLine(uv : Vector2, posA : Vector2, posB : Vector2, radiusInv : float) -> float:
	var dir : Vector2 = posA - posB;
	var dirLen : float = dir.length()
	var dirN : Vector2 = dir.normalized()
	var dotTemp : float = clamp((uv - posB).dot(dirN), 0.0, dirLen);
	var proj : Vector2 = dotTemp * dirN + posB;
	var d1 : float = (uv - proj).length()
	var finalGray : float = clamp(1.0 - d1 * radiusInv, 0.0, 1.0);
	
	return finalGray;

# makes a rune in the 0..1 uv space. Seed is which rune to draw.
# passes back gray in x and derivates for lighting in yz
static func Rune(uv : Vector2) -> float:
	var finalLine : float = 0.0;
	var pseed : Vector2 = floorv2(uv) - Vector2(0.41, 0.41);
	
	uv = fractv2(uv);
	
	for i in range(4):# (int i = 0; i < 4; i++):  #	// number of strokes
		var posA : Vector2 = rand2(floorv2(pseed + Vector2(0.5, 0.5)));
		var posB : Vector2 = rand2(floorv2(pseed + Vector2(1.5, 1.5)));
		pseed.x += 2.0;
		pseed.y += 2.0;
		
		# expand the range and mod it to get a nicely distributed random number - hopefully. :)
		
		posA = fractv2(posA * 128.0);
		posB = fractv2(posB * 128.0);
		
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
		
		posA = (floorv2(posA * snaps) + Vector2(0.5, 0.5)) / snaps; # + 0.5 to center it in a grid cell
		posB = (floorv2(posB * snaps) + Vector2(0.5, 0.5)) / snaps;
		
		#if (distance(posA, posB) < 0.0001) continue;	// eliminate dots.
		# Dots (degenerate lines) are not cross-GPU safe without adding 0.001 - divide by 0 error.
		
		finalLine = max(finalLine, ThickLine(uv, posA, posB + Vector2(0.001, 0.001), 20.0));
	
	return finalLine;


static func scratch(uv : Vector2, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var subdivide : float = floor(1.0/size.x);
	var cut : float = size.x*subdivide;
	uv *= subdivide;
	var r1 : Vector2 = rand2(floorv2(uv) + pseed);
	var r2 : Vector2 = rand2(r1);
	uv = fractv2(uv);
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
		v = max(v, scratch(fractv2(uv + pseed), size, waviness, angle/360.0, randomness, pseed));
		pseed = rand2(pseed);

	return v;


static func truchet1(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = floorv2(uv);
	var f : Vector2 = fractv2(uv) - Vector2(0.5, 0.5);
	return 1.0 - abs(abs((2.0*step(rand(i+pseed), 0.5)-1.0)*f.x+f.y)-0.5);

static func truchet2(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = floorv2(uv);
	var f : Vector2 = fractv2(uv);
	var random : float = step(rand(i+pseed), 0.5);
	f.x *= 2.0 * random-1.0;
	f.x += 1.0 - random;
	return 1.0 - min(abs(f.length() - 0.5), abs((Vector2(1, 1) - f).length() - 0.5));

static func weave(uv : Vector2, count : Vector2, width : float) -> float:
	uv *= count;
	var c : float = (sin(3.1415926* (uv.x + floor(uv.y)))*0.5+0.5)*step(abs(fract(uv.y)-0.5), width*0.5);
	c = max(c, (sin(3.1415926*(1.0+uv.y+floor(uv.x)))*0.5+0.5)*step(abs(fract(uv.x)-0.5), width*0.5));
	return c;


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
	r.z = rand(fractv2(center) + Vector2(pseed, pseed))

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
	
	return Vector3(x, y, rand(fractv2(center) + Vector2(pseed, pseed)))
	
static func bricks_rb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat
	
	var x_offset : float = offset * step(0.5, fractf(uv.y * count.y * 0.5))
	
	var bmin : Vector2
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)
	
	bmin.x += x_offset;
	bmin /= count
	var bmc : Vector2 = bmin + Vector2(1.0, 1.0) /  count

	return Color(bmin.x, bmin.y, bmc.x, bmc.y)
	
static func bricks_rb2(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
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
	
static func bricks_hb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
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
		
static func bricks_bw(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
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


static func sdr_ndot(a : Vector2, b : Vector2) -> float:
	return a.x * b.x - a.y * b.y;

static func sdRhombus(p : Vector2, b : Vector2) -> float:
	var q : Vector2 = absv2(p);
	var h : float = clamp((-2.0 * sdr_ndot(q,b) + sdr_ndot(b,b)) / b.dot(b), -1.0, 1.0);
	var d : float = ( q - 0.5*b * Vector2(1.0-h, 1.0+h)).length()
	return d * sign(q.x*b.y + q.y*b.x - b.x*b.y)

static func sdArc(p : Vector2, a1 : float, a2 : float, ra : float, rb : float) -> float:
	var amid : float = 0.5*(a1+a2)+1.6+3.14 * step(a1, a2);
	var alength : float = 0.5*(a1-a2)-1.6+3.14 * step(a1, a2);
	var sca : Vector2 = Vector2(cos(amid), sin(amid));
	var scb : Vector2 = Vector2(cos(alength), sin(alength));
	
	#p *= Matrix(Vector2(sca.x , sca.y), Vector2(-sca.y, sca.x));
	
	var pt : Vector2 = p
	
	p.x = pt.x * sca.x + pt.y * sca.y 
	p.y = pt.x * -sca.y + pt.y * sca.x
	
	p.x = abs(p.x);
	
	var k : float
	
	if (scb.y * p.x > scb.x * p.y):
		k = p.dot(scb)
	else:
		k = p.length();
	
	return sqrt( p.dot(p) + ra * ra - 2.0 * ra * k ) - rb;
	

static func sdf_boolean_union(a : float, b : float) -> float:
	return min(a, b)
	
static func sdf_boolean_substraction(a : float, b : float) -> float:
	return max(-a, b)

static func sdf_boolean_intersection(a : float, b : float) -> float:
	return max(a, b)
	
static func sdf_smooth_boolean_union(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0)
	return lerp(d2, d1, h) - k * h * (1.0 - h)

static func sdf_smooth_boolean_substraction(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 - 0.5 * (d2 + d1) / k, 0.0, 1.0)
	return lerp(d2, -d1, h) + k * h * (1.0 - h)

static func sdf_smooth_boolean_intersection(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 - 0.5 * (d2 - d1) / k, 0.0, 1.0)
	return lerp(d2, d1, h) + k * h * (1.0 - h)

static func sdf_rounded_shape(a : float, r : float) -> float:
	return a - r

static func sdf_annular_shape(a : float, r : float) -> float:
	return abs(a) - r

static func sdf_morph(a : float, b : float, amount : float) -> float:
	return lerp(a, b, amount)

static func sdLine(p : Vector2, a  : Vector2, b : Vector2) -> float:
	var pa : Vector2 = p - a
	var ba : Vector2 = b - a
	
	var h : float = clamp(pa.dot(ba) / ba.dot(ba), 0.0, 1.0);
	
	return (pa - (ba * h)).length()


#Needs thought
#func sdf_translate(a : float, x : float, y : float) -> float:
#	return lerp(a, b, amount)

static func sdf2d_rotate(uv : Vector2, a : float) -> Vector2:
	var rv : Vector2;
	var c : float = cos(a);
	var s : float = sin(a);
	uv -= Vector2(0.5, 0.5);
	rv.x = uv.x*c+uv.y*s;
	rv.y = -uv.x*s+uv.y*c;
	return rv+Vector2(0.5, 0.5);

# signed distance to a quadratic bezier
static func sdBezier(pos : Vector2, A : Vector2, B : Vector2, C : Vector2) -> Vector2:   
	var a : Vector2 = B - A;
	var b : Vector2 = A - 2.0*B + C;
	var c : Vector2 = a * 2.0;
	var d : Vector2 = A - pos;

	var kk : float = 1.0 / b.dot(b);
	var kx : float = kk * a.dot(b);
	var ky : float = kk * (2.0* a.dot(a) + d.dot(b)) / 3.0;
	var kz : float = kk * d.dot(a);      

	var res : float = 0.0;
	var sgn : float = 0.0;

	var p : float = ky - kx * kx;
	var p3 : float = p*p*p;
	var q : float = kx*(2.0*kx*kx - 3.0*ky) + kz;
	var h : float = q*q + 4.0*p3;
	var rvx : float;

	if(h >= 0.0):# // 1 root
		h = sqrt(h);
		
		var x : Vector2 = Vector2(h,-h);
		x.x -= q
		x.y -= q
		x.x /= 2.0
		x.y /= 2.0

		var uv : Vector2 = Vector2()
		
		uv.x = sign(x.x) * pow(abs(x.x), 1);
		uv.x = sign(x.y) * pow(abs(x.y), 3);
		
		rvx = uv.x+uv.y-kx;
		var t : float = clamp(rvx, 0.0, 1.0);
		var q2 : Vector2 = d+(c+b*t)*t;
		res = q2.dot(q2);
		
		var tmp2 : Vector2 = c
		tmp2.x += 2
		tmp2.y += 2
		
		tmp2 *= b*t
		
		sgn = tmp2.cross(q2)
	else: #  // 3 roots
		var z : float = sqrt(-p);
		var v : float = acos(q/(p*z*2.0))/3.0;
		var m : float = cos(v);
		var n : float = sin(v)*1.732050808;
		
#		var t : Vector3 = clamp(Vector3(m+m,-n-m,n-m)*z-kx, 0.0, 1.0);
#
#
#		var qx : Vector2 = d+(c+b*t.x)*t.x; 
#		var dx : float = dot(qx, qx)
#		sx = cross2(c+2.0*b*t.x,qx);
#		var qy : Vector2 = d+(c+b*t.y)*t.y; 
#		var dy : float = dot(qy, qy)
#		sy = cross2(c+2.0*b*t.y,qy);
#		if dx<dy:
#			res=dx; sgn=sx; rvx = t.x; 
#		else:
#			res=dy; sgn=sy; rvx = t.y;
#
	return Vector2(rvx, sqrt(res)*sign(sgn));



static func shape_circle(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8)
	
	var distance : float = uv.length()
	
	return clamp((1.0 - distance / size) / edge, 0.0, 1.0)

static func shape_polygon(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8)
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = atan(uv.y / uv.x) + 3.14159265359
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(0.5 + angle / slice) * slice - angle) * uv.length()) / (edge * size), 0.0, 1.0)

static func shape_star(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8);
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = atan(uv.y / uv.x)
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(1.5 + angle / slice - 2.0 * step(0.5 * slice, modf(angle, slice))) * slice - angle) * uv.length()) / (edge * size), 0.0, 1.0);

static func shape_curved_star(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8);
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = 2.0*(atan(uv.y / uv.x) + 3.14159265359)
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(0.5 + 0.5 * angle / slice) * 2.0 * slice - angle) * uv.length())/(edge * size), 0.0, 1.0);


static func shape_rays(uv : Vector2, sides : float, size : float, edge : float) -> float:

	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = 0.5 * max(edge, 1.0e-8) * size
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var slice : float = 6.28318530718 / sides
	var angle : float = modf(atan(uv.y / uv.x) + 3.14159265359, slice) / slice
	
	return clamp(min((size - angle) / edge, angle / edge), 0.0, 1.0);

static func adjust_hsv(color : Color, hue : float, saturation : float, value : float) -> Color:
	var hsv : Vector3 = rgb_to_hsv(Vector3(color.r, color.g, color.b));
	
	var x : float = fract(hsv.x + hue)
	var y : float = clamp(hsv.y * saturation, 0.0, 1.0)
	var z : float = clamp(hsv.z * value, 0.0, 1.0)
	
	var h : Vector3 = hsv_to_rgb(Vector3(x, y, z))

	return Color(h.x, h.y, h.z, color.a);

static func brightness_contrast(color : Color, brightness : float, contrast : float) -> Color:
	var bv : Vector3 = Vector3(brightness, brightness, brightness)
	var cvv : Vector3 = Vector3(color.r * contrast, color.g * contrast, color.b * contrast)
	
	var cv : Vector3 = cvv + bv + Vector3(0.5, 0.5, 0.5) - (Vector3(contrast, contrast, contrast) * 0.5)
	
	var v : Vector3 = clampv3(cv, Vector3(), Vector3(1, 1, 1))
	
	return Color(v.x, v.y, v.z, 1);


static func grayscale_min(c : Vector3) -> float:
	return min(c.x, min(c.y, c.z));

static func grayscale_max(c : Vector3) -> float:
	return max(c.x, max(c.y, c.z));

static func grayscale_lightness(c : Vector3) -> float:
	return 0.5*(max(c.x, max(c.y, c.z)) + min(c.x, min(c.y, c.z)));

static func grayscale_average(c : Vector3) -> float:
	return 0.333333333333*(c.x + c.y + c.z);

static func grayscale_luminosity(c : Vector3) -> float:
	return 0.21 * c.x + 0.72 * c.y + 0.07 * c.z;

static func sinewave(uv : Vector2, amplitude : float, frequency : float, phase : float) -> Color:
	var f : float = 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
	return Color(f, f, f, 1)


static func noise_color(uv : Vector2, pseed : int) -> Color:
	var v : Vector3 = color_dots(((uv)), 1.0/512.000000000, pseed);

	return Color(v.x, v.y, v.z, 1)
