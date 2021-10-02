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
