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

#			var f : float = pattern(v, 4, 4, CombinerType.MULTIPLY, CombinerAxisType.SINE, CombinerAxisType.SINE)

#			var col : Color = fbmval(v)
#			var col : Color = perlin(v)
#			var col : Color = cellular(v)
#			var col : Color = cellular2(v)
#			var col : Color = cellular3(v)
#			var col : Color = cellular4(v)
#			var col : Color = cellular5(v)
			var col : Color = cellular6(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o33355 = 26177;
var p_o33355_scale_x = 2.000000000;
var p_o33355_scale_y = 2.000000000;
var p_o33355_iterations = 5.000000000;
var p_o33355_persistence = 0.500000000;

func fbmval(uv : Vector2) -> Color:
	var f : float = o33355_fbm(((uv)), Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355));

	return Color(f, f, f, 1)

func perlin(uv : Vector2) -> Color:
	var f : float = o33355_perlin(((uv)), Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355));

	return Color(f, f, f, 1)
	
func cellular(uv : Vector2) -> Color:
	var f : float = o33355_cellular(((uv)), Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355));

	return Color(f, f, f, 1)
	
func cellular2(uv : Vector2) -> Color:
	var f : float = o33355_cellular2(((uv)), Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355));

	return Color(f, f, f, 1)
	
func cellular3(uv : Vector2) -> Color:
	var f : float = o33355_cellular3(((uv)), Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355));

	return Color(f, f, f, 1)
	
func cellular4(uv : Vector2) -> Color:
	var f : float = o33355_cellular4(((uv)), Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355));

	return Color(f, f, f, 1)
	
func cellular5(uv : Vector2) -> Color:
	var f : float = o33355_cellular5(((uv)), Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355));

	return Color(f, f, f, 1)
	
func cellular6(uv : Vector2) -> Color:
	var f : float = o33355_cellular6(((uv)), Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355));

	return Color(f, f, f, 1)

func o33355_fbm(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += fbm_value(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_perlin(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += fbm_perlin(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += fbm_cellular(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular2(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += fbm_cellular2(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;

func o33355_cellular3(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += fbm_cellular3(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular4(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += fbm_cellular4(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular5(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += fbm_cellular5(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular6(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += fbm_cellular6(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;

func fbm_value(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	var p00 : float = rand(modv2(o, size));
	var p01 : float = rand(modv2(o + Vector2(0.0, 1.0), size));
	var p10 : float = rand(modv2(o + Vector2(1.0, 0.0), size));
	var p11 : float = rand(modv2(o + Vector2(1.0, 1.0), size));
	
	var t : Vector2 = f * f * (Vector2(3, 3) - 2.0 * f);
	return lerp(lerp(p00, p10, t.x), lerp(p01, p11, t.x), t.y);

func fbm_perlin(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	var a00 : float = rand(modv2(o, size)) * 6.28318530718;
	var a01 : float = rand(modv2(o + Vector2(0.0, 1.0), size)) * 6.28318530718;
	var a10 : float = rand(modv2(o + Vector2(1.0, 0.0), size)) * 6.28318530718;
	var a11 : float = rand(modv2(o + Vector2(1.0, 1.0), size)) * 6.28318530718;
	var v00 : Vector2 = Vector2(cos(a00), sin(a00));
	var v01 : Vector2 = Vector2(cos(a01), sin(a01));
	var v10 : Vector2 = Vector2(cos(a10), sin(a10));
	var v11 : Vector2 = Vector2(cos(a11), sin(a11));
	var p00 : float = v00.dot(f);
	var p01 : float = v01.dot(f - Vector2(0.0, 1.0));
	var p10 : float = v10.dot(f - Vector2(1.0, 0.0));
	var p11 : float = v11.dot(f - Vector2(1.0, 1.0));
	
	var t : Vector2 = f * f * (Vector2(3, 3) - 2.0 * f);
	
	return 0.5 + lerp(lerp(p00, p10, t.x), lerp(p01, p11, t.x), t.y);


func fbm_cellular(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			min_dist = min(min_dist, dist);

	return min_dist;

func fbm_cellular2(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			
			var dist : float = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;
	
	return min_dist2-min_dist1;

func fbm_cellular3(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size))*0.5 + Vector2(x, y);
			
			var dist : float = abs((f - node).x) + abs((f - node).y);
			
			min_dist = min(min_dist, dist);

	return min_dist;

func fbm_cellular4(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size))*0.5 + Vector2(x, y);
			
			var dist : float = abs((f - node).x) + abs((f - node).y);
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;

	return min_dist2 - min_dist1;

func fbm_cellular5(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = max(abs((f - node).x), abs((f - node).y));
			min_dist = min(min_dist, dist);

	return min_dist;



func fbm_cellular6(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = max(abs((f - node).x), abs((f - node).y));
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;

	return min_dist2 - min_dist1;


func transform(uv : Vector2, translate : Vector2, rotate : float, scale : Vector2, repeat : bool) -> Vector2:
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
		

func clampv3(v : Vector3, mi : Vector3, ma : Vector3) -> Vector3:
	v.x = clamp(v.x, mi.x, ma.x)
	v.y = clamp(v.y, mi.y, ma.y)
	v.y = clamp(v.z, mi.z, ma.z)
	
	return v

func floorc(a : Color) -> Color:
	var v : Color = Color()
	
	v.r = floor(a.r)
	v.g = floor(a.g)
	v.b = floor(a.b)
	v.a = floor(a.a)
	
	return v


func floorv2(a : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = floor(a.x)
	v.y = floor(a.y)
	
	return v
	
func smoothstepv2(a : float, b : float, c : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = smoothstep(a, b, c.x)
	v.y = smoothstep(a, b, c.y)
	
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

func cosv2(v : Vector2) -> Vector2:
	v.x = cos(v.x)
	v.y = cos(v.y)
	
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

func fractv2(v : Vector2) -> Vector2:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	
	return v
	
func fractv3(v : Vector3) -> Vector3:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	v.z = v.z - floor(v.z)
	
	return v
	
func fract(f : float) -> float:
	return f - floor(f)

func clampv2(v : Vector2, pmin : Vector2, pmax : Vector2) -> Vector2:
	v.x = clamp(v.x, pmin.x, pmax.x)
	v.y = clamp(v.y, pmin.y, pmax.y)
	
	return v

func rand(x : Vector2) -> float:
	return fract(cos(x.dot(Vector2(13.9898, 8.141))) * 43758.5453);

func rand2(x : Vector2) -> Vector2:
	return fractv2(cosv2(Vector2(x.dot(Vector2(13.9898, 8.141)),
						  x.dot(Vector2(3.4562, 17.398)))) * 43758.5453);

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

