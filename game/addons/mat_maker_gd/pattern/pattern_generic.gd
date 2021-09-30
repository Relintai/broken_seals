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

			var f : float = pattern(v, 4, 4, CombinerType.MULTIPLY, CombinerAxisType.SINE, CombinerAxisType.SINE)

			var col : Color = Color(f, f, f, 1)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

#var p_o7009_x_scale = 4.000000000;
#var p_o7009_y_scale = 4.000000000;


func pattern(uv : Vector2, x_scale : float, y_scale : float, ct : int, catx : int, caty : int) -> float:
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

func wave_constant(x : float) -> float:
	return 1.0;

func wave_sine(x : float) -> float:
	return 0.5-0.5*cos(3.14159265359*2.0*x);

func wave_triangle(x : float) -> float:
	x = fractf(x);
	return min(2.0*x, 2.0-2.0*x);

func wave_sawtooth(x : float) -> float:
	return fractf(x);

func wave_square(x : float) -> float:
	if (fractf(x) < 0.5):
		return 0.0
	else:
		return 1.0

func wave_bounce(x : float) -> float:
	x = 2.0*(fractf(x)-0.5);
	return sqrt(1.0-x*x);

func mix_mul(x : float, y : float) -> float:
	return x*y;

func mix_add(x : float, y : float) -> float:
	return min(x+y, 1.0);

func mix_max(x : float, y : float) -> float:
	return max(x, y);

func mix_min(x : float, y : float) -> float:
	return min(x, y);

func mix_xor(x : float, y : float) -> float:
	return min(x+y, 2.0-x-y);

func mix_pow(x : float, y : float) -> float:
	return pow(x, y);


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

