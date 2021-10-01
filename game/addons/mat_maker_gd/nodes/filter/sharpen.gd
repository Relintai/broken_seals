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

			var f : Vector3 = sharpen(v)
			
			var c : Color = Color(f.x, f.y, f.z, 1)
			
#			c = invert(c)
#			c = brightness_contrast(c)

			#needs work

			image.set_pixel(x, y, c)

			
	image.unlock()

	tex.create_from_image(image)
	texture = tex

func o11853_input_in(uv : Vector2) -> Vector3:
	var f : float = shape_circle(uv, 3, 1.0 * 1.0, 1.0)

	return Vector3(f, f, f);

func sharpen(uv : Vector2) -> Vector3:
	var e : Vector2 = Vector2(1.0 / 32.000000000, 0.0);
	var rv : Vector3 = 5.0 * o11853_input_in(uv);

	rv -= o11853_input_in(uv + Vector2(e.x, e.y));
	rv -= o11853_input_in(uv - Vector2(e.x, e.y));
	rv -= o11853_input_in(uv + Vector2(e.y, e.x));
	rv -= o11853_input_in(uv - Vector2(e.y, e.x));
	
	return rv

func shape_circle(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8)
	
	var distance : float = uv.length()
	
	return clamp((1.0 - distance / size) / edge, 0.0, 1.0)


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

