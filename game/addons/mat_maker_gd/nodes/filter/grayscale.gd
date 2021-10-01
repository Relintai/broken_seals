tool
extends TextureRect

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

func _ready():
	if !Engine.editor_hint:
		gen()


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

			var f : float = shape_circle(v, 3, 1.0 * 1.0, 1.0)
			
			f = gs_luminosity(Vector3(f, f, f));
			
			var c : Color = Color(f, f, f, 1)
			
#			c = invert(c)
#			c = brightness_contrast(c)

			#needs work

			image.set_pixel(x, y, c)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

func invert(color : Color) -> Color:
	return Color(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);


func gs_min(c : Vector3) -> float:
	return min(c.x, min(c.y, c.z));

func gs_max(c : Vector3) -> float:
	return max(c.x, max(c.y, c.z));

func gs_lightness(c : Vector3) -> float:
	return 0.5*(max(c.x, max(c.y, c.z)) + min(c.x, min(c.y, c.z)));

func gs_average(c : Vector3) -> float:
	return 0.333333333333*(c.x + c.y + c.z);

func gs_luminosity(c : Vector3) -> float:
	return 0.21 * c.x + 0.72 * c.y + 0.07 * c.z;


func shape_circle(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8)
	
	var distance : float = uv.length()
	
	return clamp((1.0 - distance / size) / edge, 0.0, 1.0)


func transform(uv : Vector2, translate : Vector2, rotate : float, scale : Vector2, repeat : bool) -> Vector2:
	var rv : Vector2 = Vector2();
	uv -= translate;
	uv -= Vector2(0.5, 0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += Vector2(0.5, 0.5);
	
	if (repeat):
		return Commons.fractv2(rv);
	else:
		return Commons.clampv2(rv, Vector2(0, 0), Vector2(1, 1));
		



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
#	vec4 p = c.y < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
#	vec4 q = c.x < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
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

