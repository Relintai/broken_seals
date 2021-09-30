tool
extends TextureRect

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

	
var p_o3704_albedo_color_r : float = 1.000000000;
var p_o3704_albedo_color_g  : float = 1.000000000;
var p_o3704_albedo_color_b : float = 1.000000000;
var p_o3704_albedo_color_a : float = 1.000000000;
var p_o3704_metallic : float = 1.000000000;
var p_o3704_roughness : float = 1.000000000;
var p_o3704_emission_energy : float = 1.000000000;
var p_o3704_normal : float = 1.000000000;
var p_o3704_ao : float = 1.000000000;
var p_o3704_depth_scale : float = 0.500000000;
var p_o3704_sss : float = 0.000000000;

var p_o69054_sides : float = 6.000000000;
var p_o69054_radius : float = 0.845361000;
var p_o69054_edge : float = 0.051546000;

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

#			var c : float = shape_circle(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_polygon(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_star(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_curved_star(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
			var c : float = shape_rays(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)

			image.set_pixel(x, y, Color(c, c, c, 1))

	image.unlock()
	
	tex.create_from_image(image)
	texture = tex


func shape_circle(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8)
	
	var distance : float = uv.length()
	
	return clamp((1.0 - distance / size) / edge, 0.0, 1.0)

func shape_polygon(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8)
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = atan(uv.y / uv.x) + 3.14159265359
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(0.5 + angle / slice) * slice - angle) * uv.length()) / (edge * size), 0.0, 1.0)

func shape_star(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8);
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = atan(uv.y / uv.x)
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(1.5 + angle / slice - 2.0 * step(0.5 * slice, modf(angle, slice))) * slice - angle) * uv.length()) / (edge * size), 0.0, 1.0);

func shape_curved_star(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8);
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = 2.0*(atan(uv.y / uv.x) + 3.14159265359)
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(0.5 + 0.5 * angle / slice) * 2.0 * slice - angle) * uv.length())/(edge * size), 0.0, 1.0);


func shape_rays(uv : Vector2, sides : float, size : float, edge : float) -> float:

	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = 0.5 * max(edge, 1.0e-8) * size
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var slice : float = 6.28318530718 / sides
	var angle : float = modf(atan(uv.y / uv.x) + 3.14159265359, slice) / slice
	
	return clamp(min((size - angle) / edge, angle / edge), 0.0, 1.0);

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

