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

