tool
extends TextureRect

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

func _ready():
	if !Engine.editor_hint:
		gen()


var g_r = 0.010000000;

#box
var g_sx = 0.300000000;
var g_sy = 0.250000000;
var g_sz = 0.250000000;

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

			var col : Color = raymarch(v)
#			var col : Color = raymarch2(v)
#			var col : Color = raymarch3(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var p_o22692_r = 0.400000000;

func sdf3d_input(p : Vector3) -> Vector2:
#	return sdf3d_box(p, g_sx, g_sy, g_sz, g_r);
#	return sdf3d_sphere(p);
#	return sdf3d_cylinder_x(p);
#	return sdf3d_cylinder_y(p);
#	return sdf3d_cylinder_z(p);

#	return sdf3d_capsule_x(p);
#	return sdf3d_capsule_y(p);
#	return sdf3d_capsule_z(p);
	
#	return sdf3d_cone_px(p);
#	return sdf3d_cone_nx(p);
#	return sdf3d_cone_py(p);
#	return sdf3d_cone_ny(p);
#	return sdf3d_cone_pz(p);

#	return sdf3d_torus_x(p);
#	return sdf3d_torus_y(p);
#	return sdf3d_torus_z(p);
	
#	return sdf3dc_union(sdf3d_sphere(p),sdf3d_capsule_x(p)) ;
#	return sdf3d_smooth_union(sdf3d_sphere(p),sdf3d_capsule_x(p), 0.5)
	
#	return sdf3d_rounded(sdf3d_sphere(p));

#	return sdf3d_sphere(sdf3d_elongation(p))

	return sdf3d_sphere(sdf3d_repeat(p))

	
#vec2 o157216_0_1_sdf3dc = sdf3dc_union(vec2(o152465_0_1_sdf3d, 0.0), vec2(o153139_0_1_sdf3d, 0.0));

func raymarch(uv : Vector2) -> Color:
	var o21422_0_d : Vector2 = sdf3d_raymarch(uv);
	
	var o21422_0_1_f : float = 1.0 - o21422_0_d.x;
	
	return Color(o21422_0_1_f, o21422_0_1_f, o21422_0_1_f, 1)

func raymarch2(uv : Vector2) -> Color:
	var o21422_0_d : Vector2 = sdf3d_raymarch(uv);
	
	var v : Vector3 = Vector3(0.5, 0.5, 0.5) + 0.5 * sdf3d_normal(Vector3(uv.x - 0.5, uv.y - 0.5, 1.0 - o21422_0_d.x));
	
	return Color(v.x, v.y, v.z, 1)

func raymarch3(uv : Vector2) -> Color:
	var v : Vector2 = sdf3d_raymarch(uv);
	
	return Color(v.y, v.y, v.y, 1)

func sdf3d_sphere(p : Vector3) -> Vector2:
	var o22692_0_1_sdf3d : float = p.length() - p_o22692_r;

	return Vector2(o22692_0_1_sdf3d, 0.0);

func sdf3d_box(p : Vector3, sx : float, sy : float, sz : float, r : float) -> Vector2:
	var v : Vector3 = absv3((p)) - Vector3(sx, sy, sz);
	var f : float = (maxv3(v,Vector3())).length() + min(max(v.x,max(v.y, v.z)),0.0) - r;

	return Vector2(f, 0.0);

var p_o69351_l = 0.250000000;
var p_o69351_r = 0.250000000;

func sdf3d_cylinder_y(p : Vector3) -> Vector2:
	var o69351_0_d : Vector2 = absv2(Vector2(Vector2(p.x, p.z).length(),(p).y)) - Vector2(p_o69351_r,p_o69351_l);
	var o69351_0_1_sdf3d : float = min(max(o69351_0_d.x, o69351_0_d.y),0.0) + maxv2(o69351_0_d, Vector2()).length();

	return Vector2(o69351_0_1_sdf3d, 0.0);

func sdf3d_cylinder_x(p : Vector3) -> Vector2:
	var o69351_0_d : Vector2 = absv2(Vector2(Vector2(p.y, p.z).length(),(p).x)) - Vector2(p_o69351_r,p_o69351_l);
	var o69351_0_1_sdf3d : float = min(max(o69351_0_d.x, o69351_0_d.y),0.0) + maxv2(o69351_0_d, Vector2()).length();

	return Vector2(o69351_0_1_sdf3d, 0.0);

func sdf3d_cylinder_z(p : Vector3) -> Vector2:
	var o69351_0_d : Vector2 = absv2(Vector2(Vector2(p.x, p.y).length(),(p).z)) - Vector2(p_o69351_r,p_o69351_l);
	var o69351_0_1_sdf3d : float = min(max(o69351_0_d.x, o69351_0_d.y),0.0) + maxv2(o69351_0_d, Vector2()).length();

	return Vector2(o69351_0_1_sdf3d, 0.0);

var p_o100081_l = 0.300000000;
var p_o100081_r = 0.200000000;

func sdf3d_capsule_y(p : Vector3) -> Vector2:
	var o100081_0_p : Vector3 = p;
	o100081_0_p.y -= clamp(o100081_0_p.y, -p_o100081_l, p_o100081_l);
	var o100081_0_1_sdf3d : float = o100081_0_p.length() - p_o100081_r;

	return Vector2(o100081_0_1_sdf3d, 0.0);

func sdf3d_capsule_x(p : Vector3) -> Vector2:
	var o100081_0_p : Vector3 = p;
	o100081_0_p.x -= clamp(o100081_0_p.x, -p_o100081_l, p_o100081_l);
	var o100081_0_1_sdf3d : float = o100081_0_p.length() - p_o100081_r;

	return Vector2(o100081_0_1_sdf3d, 0.0);

func sdf3d_capsule_z(p : Vector3) -> Vector2:
	var o100081_0_p : Vector3 = p;
	o100081_0_p.z -= clamp(o100081_0_p.z, -p_o100081_l, p_o100081_l);
	var o100081_0_1_sdf3d : float = o100081_0_p.length() - p_o100081_r;

	return Vector2(o100081_0_1_sdf3d, 0.0);

var p_o118934_a = 30.000000000;

func sdf3d_cone_px(p : Vector3) -> Vector2:
	var  f : float = Vector2(cos(p_o118934_a*0.01745329251),sin(p_o118934_a*0.01745329251)).dot(Vector2(Vector2(p.y, p.z).length(), - (p).x));

	return Vector2(f, 0.0);

func sdf3d_cone_nx(p : Vector3) -> Vector2:
	var  f : float = Vector2(cos(p_o118934_a*0.01745329251),sin(p_o118934_a*0.01745329251)).dot(Vector2(Vector2(p.y, p.z).length(),(p).x));

	return Vector2(f, 0.0);

func sdf3d_cone_py(p : Vector3) -> Vector2:
	var  f : float = Vector2(cos(p_o118934_a*0.01745329251),sin(p_o118934_a*0.01745329251)).dot(Vector2(Vector2(p.x, p.z).length(),(p).y));

	return Vector2(f, 0.0);

func sdf3d_cone_ny(p : Vector3) -> Vector2:
	var  f : float = Vector2(cos(p_o118934_a*0.01745329251),sin(p_o118934_a*0.01745329251)).dot(Vector2(Vector2(p.x, p.z).length(),-(p).y));

	return Vector2(f, 0.0);

func sdf3d_cone_pz(p : Vector3) -> Vector2:
	var  f : float = Vector2(cos(p_o118934_a*0.01745329251),sin(p_o118934_a*0.01745329251)).dot(Vector2(Vector2(p.x, p.y).length(),-(p).z));

	return Vector2(f, 0.0);

func sdf3d_cone_nz(p : Vector3) -> Vector2:
	var f : float = Vector2(cos(p_o118934_a*0.01745329251),sin(p_o118934_a*0.01745329251)).dot(Vector2(Vector2(p.x, p.y).length(),(p).z));

	return Vector2(f, 0.0);

var p_o136697_R = 0.300000000;
var p_o136697_r = 0.150000000;

func sdf3d_torus_x(p : Vector3) -> Vector2:
	var o136697_0_q : Vector2 = Vector2(Vector2(p.y, p.z).length() - p_o136697_R,(p).x);
	var o136697_0_1_sdf3d : float = o136697_0_q.length() - p_o136697_r;

	return Vector2(o136697_0_1_sdf3d, 0.0);
	
func sdf3d_torus_y(p : Vector3) -> Vector2:
	var o136697_0_q : Vector2 = Vector2(Vector2(p.z, p.x).length() - p_o136697_R,(p).y);
	var o136697_0_1_sdf3d : float = o136697_0_q.length() - p_o136697_r;

	return Vector2(o136697_0_1_sdf3d, 0.0);

func sdf3d_torus_z(p : Vector3) -> Vector2:
	var o136697_0_q : Vector2 = Vector2(Vector2(p.x, p.y).length() - p_o136697_R,(p).z);
	var o136697_0_1_sdf3d : float = o136697_0_q.length() - p_o136697_r;

	return Vector2(o136697_0_1_sdf3d, 0.0);


func sdf3d_raymarch(uv : Vector2) -> Vector2:
	var ro : Vector3 = Vector3(uv.x - 0.5, uv.y - 0.5, 1.0);
	var rd : Vector3 = Vector3(0.0, 0.0, -1.0);
	var dO : float = 0.0;
	var c : float = 0.0;
	
	for i in range(100):
		var p : Vector3 = ro + rd * dO;
		var dS : Vector2 = sdf3d_input(p);
		
		dO += dS.x;

		if (dO >= 1.0):
			break;
		elif (dS.x < 0.0001):
			c = dS.y;
			break;
	
	return Vector2(dO, c);

func sdf3d_normal(p : Vector3) -> Vector3:
	if (p.z <= 0.0):
		return Vector3(0.0, 0.0, 1.0);

	var d : float = sdf3d_input(p).x;
	var e : float = .001;
	
	var n : Vector3 = Vector3(
		d - sdf3d_input(p - Vector3(e, 0.0, 0.0)).x,
		d - sdf3d_input(p - Vector3(0.0, e, 0.0)).x,
		d - sdf3d_input(p - Vector3(0.0, 0.0, e)).x);
	
	return Vector3(-1.0, -1.0, -1.0) * n.normalized();
	
func sdf3dc_union(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(min(a.x, b.x), lerp(b.y, a.y, step(a.x, b.x)));

func sdf3dc_sub(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(max(-a.x, b.x), a.y);


func sdf3dc_inter(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(max(a.x, b.x), lerp(a.y, b.y, step(a.x, b.x)));


func sdf3d_smooth_union(d1 : Vector2, d2 : Vector2, k : float) -> Vector2:
	var h : float = clamp(0.5 + 0.5 * (d2.x - d1.x) / k, 0.0, 1.0);
	return Vector2(lerp(d2.x, d1.x, h)-k*h*(1.0 - h), lerp(d2.y, d1.y, step(d1.x, d2.x)));

func sdf3d_smooth_subtraction(d1 : Vector2, d2 : Vector2, k : float) -> Vector2:
	var h : float = clamp(0.5 - 0.5 * (d2.x + d1.x) / k, 0.0, 1.0);
	return Vector2(lerp(d2.x, -d1.x, h )+k*h*(1.0-h), d2.y);

func sdf3d_smooth_intersection(d1 : Vector2, d2 : Vector2, k : float) -> Vector2:
	var h : float = clamp(0.5 - 0.5 * (d2.x - d1.x) / k, 0.0, 1.0);
	return Vector2(lerp(d2.x, d1.x, h)+k*h*(1.0-h), lerp(d1.y, d2.y, step(d1.x, d2.x)));

var p_o885532_r = 0.250000000;

func sdf3d_rounded(v : Vector2) -> Vector2:
	return Vector2(v.x - p_o885532_r, v.y);

var p_o900574_x = 0.200000000;
var p_o900574_y = 0.000000000;
var p_o900574_z = 0.000000000;

func sdf3d_elongation(p : Vector3) -> Vector3:
	return ((p) - clampv3((p), - absv3(Vector3(p_o900574_x, p_o900574_y, p_o900574_z)), absv3(Vector3(p_o900574_x, p_o900574_y, p_o900574_z))))

var seed_o910161 = -49592;
var p_o910161_rx = 3.000000000;
var p_o910161_ry = 3.000000000;
var p_o910161_r = 0.300000000;
var p_o152465_r = 0.400000000;

func sdf3d_repeat(p : Vector3) -> Vector3:
	return (repeat((p), Vector3(1.0/p_o910161_rx, 1.0/p_o910161_ry, 0.00001), float(seed_o910161), p_o910161_r))

#Needs work
func repeat(p : Vector3, r : Vector3, pseed : float, randomness : float) -> Vector3:
	#fix division by zero
#	p.x += 0.000001
#	p.y += 0.000001
#	p.z += 0.000001
#	r.x += 0.000001
#	r.y += 0.000001
#	r.z += 0.000001
	
	var pxy : Vector2 = Vector2(p.x, p.y)
	var rxy : Vector2 = Vector2(r.x, r.y)
	
	var r3 : Vector2 = floorv2(modv2((pxy + 0.5 * rxy) / rxy, Vector2(1.0 / rxy.x, 1.0 / rxy.y)) + Vector2(pseed, pseed))
	
	var rr : Vector3 = rand3(r3)
	
	rr.x -= 0.5
	rr.y -= 0.5
	rr.z -= 0.5
	
	var a : Vector3 = (rr) * 6.28 * randomness;

	p = modv3(p + 0.5 * r, r) - 0.5*r;
	var rv : Vector3;
	var c : float;
	var s : float;
	
	c = cos(a.x);
	s = sin(a.x);
	rv.x = p.x;
	rv.y = p.y*c+p.z*s;
	rv.z = -p.y*s+p.z*c;
	c = cos(a.y);
	s = sin(a.y);
	p.x = rv.x*c+rv.z*s;
	p.y = rv.y;
	p.z = -rv.x*s+rv.z*c;
	c = cos(a.z);
	s = sin(a.z);
	rv.x = p.x*c+p.y*s;
	rv.y = -p.x*s+p.y*c;
	rv.z = p.z;
	
	return rv;
	

#
#vec2 o21422_input_sdf(vec3 p) {
#float o152465_0_1_sdf3d = length((circle_repeat_transform((p), p_o928780_c)))-p_o152465_r;
#vec2 o928780_0_1_sdf3dc = vec2(o152465_0_1_sdf3d, 0.0);
#
#return o928780_0_1_sdf3dc;
#
#var p_o928780_c = 5.000000000;
#
#func circle_repeat_transform(p : Vector3, r : Vector3, pseed : float, randomness : float) -> Vector3:
#	float r = 6.28/count;
#	float pa = atan(p.x, p.y);
#	float a = mod(pa+0.5*r, r)-0.5*r;
#	vec3 rv;
#	float c = cos(a-pa);
#	float s = sin(a-pa);
#	rv.x = p.x*c+p.y*s;
#	rv.y = -p.x*s+p.y*c;
#	rv.z = p.z;
#	return rv;


func clampv3(v : Vector3, mi : Vector3, ma : Vector3) -> Vector3:
	v.x = clamp(v.x, mi.x, ma.x)
	v.y = clamp(v.y, mi.y, ma.y)
	v.y = clamp(v.z, mi.z, ma.z)
	
	return v


func floorv2(a : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = floor(a.x)
	v.y = floor(a.y)
	
	return v

func maxv2(a : Vector2, b : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = max(a.x, b.x)
	v.y = max(a.y, b.y)
	
	return v

func maxv3(a : Vector3, b : Vector3) -> Vector3:
	var v : Vector3 = Vector3()
	
	v.x = max(a.x, b.x)
	v.y = max(a.y, b.y)
	v.z = max(a.z, b.z)
	
	return v

func absv2(v : Vector2) -> Vector2:
	v.x = abs(v.x)
	v.y = abs(v.y)
	
	return v
	
func absv3(v : Vector3) -> Vector3:
	v.x = abs(v.x)
	v.y = abs(v.y)
	v.y = abs(v.y)
	
	return v

func cosv3(v : Vector3) -> Vector3:
	v.x = cos(v.x)
	v.y = cos(v.y)
	v.y = cos(v.y)
	
	return v

func modv3(a : Vector3, b : Vector3) -> Vector3:
	var v : Vector3 = Vector3()
	
	v.x = modf(a.x, b.x)
	v.y = modf(a.y, b.y)
	v.z = modf(a.z, b.z)
	
	return v
	
	
func modv2(a : Vector2, b : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = modf(a.x, b.x)
	v.y = modf(a.y, b.y)

	return v

func modf(x : float, y : float) -> float:
	return x - y * floor(x / y)

func fract(v : Vector2) -> Vector2:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	
	return v
	
func fractv3(v : Vector3) -> Vector3:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	v.z = v.z - floor(v.z)
	
	return v
	
func fractf(f : float) -> float:
	return f - floor(f)

func rand(x : Vector2) -> float:
	return fractf(cos(x.dot(Vector2(13.9898, 8.141))) * 43758.5453);

func rand3(x : Vector2) -> Vector3:
	return fractv3(cosv3(Vector3(x.dot(Vector2(13.9898, 8.141)),
						  x.dot(Vector2(3.4562, 17.398)),
						  x.dot(Vector2(13.254, 5.867)))) * 43758.5453);

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


func reffg():
	return false

func reff(bb):
	if bb:
		gen()

