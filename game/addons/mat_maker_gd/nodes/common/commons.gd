tool
extends Reference

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

static func sinewave(uv : Vector2, amplitude : float, frequency : float, phase : float) -> Color:
	var f : float = 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
	return Color(f, f, f, 1)

static func ThickLine(uv : Vector2, posA : Vector2, posB : Vector2, radiusInv : float) -> float:
	var dir : Vector2 = posA - posB;
	var dirLen : float = dir.length()
	var dirN : Vector2 = dir.normalized()
	var dotTemp : float = clamp((uv - posB).dot(dirN), 0.0, dirLen);
	var proj : Vector2 = dotTemp * dirN + posB;
	var d1 : float = (uv - proj).length()
	var finalGray : float = clamp(1.0 - d1 * radiusInv, 0.0, 1.0);
	
	return finalGray;

static func color_dots(uv : Vector2, size : float, pseed : int) -> Vector3:
	var seed2 : Vector2 = rand2(Vector2(float(pseed), 1.0 - float(pseed)));
	uv /= size;
	var point_pos : Vector2 = floorv2(uv) + Vector2(0.5, 0.5);
	return rand3(seed2 + point_pos);

static func noise_color(uv : Vector2, pseed : int) -> Color:
	var v : Vector3 = color_dots(((uv)), 1.0/512.000000000, pseed);

	return Color(v.x, v.y, v.z, 1)
