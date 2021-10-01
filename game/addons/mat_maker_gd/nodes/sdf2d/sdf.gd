tool
extends TextureRect

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

func _ready():
	pass
	

#sdshow
var p_o47009_bevel = 0.100000000;

#circle
var p_o11635_r = 0.400000000;
var p_o11635_cx = 0.000000000;
var p_o11635_cy = 0.000000000;

#box
var p_o48575_w = 0.300000000;
var p_o48575_h = 0.200000000;
var p_o48575_cx = 0.000000000;
var p_o48575_cy = 0.000000000;

#line
var p_o49570_ax = -0.300000000;
var p_o49570_ay = -0.300000000;
var p_o49570_bx = 0.300000000;
var p_o49570_by = 0.300000000;
var p_o49570_r = 0.200000000;

#rhombus
var p_o50848_w = 0.300000000;
var p_o50848_h = 0.200000000;
var p_o50848_cx = 0.000000000;
var p_o50848_cy = 0.000000000;

#arc
var p_o51990_a1 = 0.000000000;
var p_o51990_a2 = 0.000000000;
var p_o51990_r1 = 0.300000000;
var p_o51990_r2 = 0.100000000;

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

#			var fc : float = sdf_circle(v)
#			var fc : float = sdf_box(v)
#			var fc : float = sdf_line(v)
#			var fc : float = sdf_rhombus(v)
#			var fc : float = sdf_arc(v)
			
#			var fc : float = sdf_boolean_union(sdf_circle(v), sdf_box(v))
#			var fc : float = sdf_boolean_substraction(sdf_circle(v), sdf_box(v))
#			var fc : float = sdf_boolean_intersection(sdf_circle(v), sdf_box(v))
			
#			var fc : float = sdf_smooth_boolean_union(sdf_circle(v), sdf_box(v), 0.15)
#			var fc : float = sdf_smooth_boolean_substraction(sdf_circle(v), sdf_box(v), 0.15)
#			var fc : float = sdf_smooth_boolean_intersection(sdf_circle(v), sdf_box(v), 0.15)

#			var fc : float = sdf_rounded_shape(sdf_box(v), 0.15)
#			var fc : float = sdf_annular_shape(sdf_box(v), 0.15)
			
			var fc : float = sdf_morph(sdf_circle(v), sdf_box(v), 0.5)
			
			var col : Color = sdf_show(fc)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

func sdf_show(val : float) -> Color:
	var o47009_0_1_f : float = clamp(-val / max(p_o47009_bevel, 0.00001), 0.0, 1.0);
	
	return Color(o47009_0_1_f, o47009_0_1_f, o47009_0_1_f, 1)


func sdf_circle(uv : Vector2) -> float:
	return (uv - Vector2(p_o11635_cx + 0.5, p_o11635_cy + 0.5)).length() - p_o11635_r;


func sdf_box(uv : Vector2) -> float:
	var o48575_0_d : Vector2 = absv2(uv - Vector2(p_o48575_cx+0.5, p_o48575_cy+0.5)) - Vector2(p_o48575_w, p_o48575_h)
	
	return maxv2(o48575_0_d, Vector2(0, 0)).length() + min(max(o48575_0_d.x, o48575_0_d.y), 0.0)

func sdf_line(uv : Vector2) -> float:
	return sdLine(uv, Vector2(p_o49570_ax+0.5, p_o49570_ay+0.5), Vector2(p_o49570_bx+0.5, p_o49570_by+0.5)) - p_o49570_r;

func sdLine(p : Vector2, a  : Vector2, b : Vector2) -> float:
	var pa : Vector2 = p - a
	var ba : Vector2 = b - a
	
	var h : float = clamp(pa.dot(ba) / ba.dot(ba), 0.0, 1.0);
	
	return (pa - (ba * h)).length()

func sdf_rhombus(uv : Vector2) -> float:
	return sdRhombus(uv - Vector2(p_o50848_cx + 0.5, p_o50848_cy+0.5), Vector2(p_o50848_w, p_o50848_h));

func sdr_ndot(a : Vector2, b : Vector2) -> float:
	return a.x * b.x - a.y * b.y;

func sdRhombus(p : Vector2, b : Vector2) -> float:
	var q : Vector2 = absv2(p);
	var h : float = clamp((-2.0 * sdr_ndot(q,b) + sdr_ndot(b,b)) / b.dot(b), -1.0, 1.0);
	var d : float = ( q - 0.5*b * Vector2(1.0-h, 1.0+h)).length()
	return d * sign(q.x*b.y + q.y*b.x - b.x*b.y)

func sdf_arc(uv : Vector2) -> float:
	return sdArc(uv - Vector2(0.5, 0.5), modf(p_o51990_a1, 360.0) * 0.01745329251, modf(p_o51990_a2, 360.0)*0.01745329251, p_o51990_r1, p_o51990_r2);

func sdArc(p : Vector2, a1 : float, a2 : float, ra : float, rb : float) -> float:
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
	

func sdf_boolean_union(a : float, b : float) -> float:
	return min(a, b)
	
func sdf_boolean_substraction(a : float, b : float) -> float:
	return max(-a, b)

func sdf_boolean_intersection(a : float, b : float) -> float:
	return max(a, b)
	
func sdf_smooth_boolean_union(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0)
	return lerp(d2, d1, h) - k * h * (1.0 - h)

func sdf_smooth_boolean_substraction(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 - 0.5 * (d2 + d1) / k, 0.0, 1.0)
	return lerp(d2, -d1, h) + k * h * (1.0 - h)

func sdf_smooth_boolean_intersection(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 - 0.5 * (d2 - d1) / k, 0.0, 1.0)
	return lerp(d2, d1, h) + k * h * (1.0 - h)

func sdf_rounded_shape(a : float, r : float) -> float:
	return a - r

func sdf_annular_shape(a : float, r : float) -> float:
	return abs(a) - r

func sdf_morph(a : float, b : float, amount : float) -> float:
	return lerp(a, b, amount)

#Needs thought
#func sdf_translate(a : float, x : float, y : float) -> float:
#	return lerp(a, b, amount)

func sdf2d_rotate(uv : Vector2, a : float) -> Vector2:
	var rv : Vector2;
	var c : float = cos(a);
	var s : float = sin(a);
	uv -= Vector2(0.5, 0.5);
	rv.x = uv.x*c+uv.y*s;
	rv.y = -uv.x*s+uv.y*c;
	return rv+Vector2(0.5, 0.5);

func maxv2(a : Vector2, b : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = max(a.x, b.x)
	v.y = max(a.y, b.y)
	
	return v

func absv2(v : Vector2) -> Vector2:
	v.x = abs(v.x)
	v.y = abs(v.y)
	
	return v

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


func reffg():
	return false

func reff(bb):
	if bb:
		gen()

