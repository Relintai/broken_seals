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
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	var p00 : float = Commons.rand(Commons.modv2(o, size));
	var p01 : float = Commons.rand(Commons.modv2(o + Vector2(0.0, 1.0), size));
	var p10 : float = Commons.rand(Commons.modv2(o + Vector2(1.0, 0.0), size));
	var p11 : float = Commons.rand(Commons.modv2(o + Vector2(1.0, 1.0), size));
	
	var t : Vector2 = f * f * (Vector2(3, 3) - 2.0 * f);
	return lerp(lerp(p00, p10, t.x), lerp(p01, p11, t.x), t.y);

func fbm_perlin(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	var a00 : float = Commons.rand(Commons.modv2(o, size)) * 6.28318530718;
	var a01 : float = Commons.rand(Commons.modv2(o + Vector2(0.0, 1.0), size)) * 6.28318530718;
	var a10 : float = Commons.rand(Commons.modv2(o + Vector2(1.0, 0.0), size)) * 6.28318530718;
	var a11 : float = Commons.rand(Commons.modv2(o + Vector2(1.0, 1.0), size)) * 6.28318530718;
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
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			min_dist = min(min_dist, dist);

	return min_dist;

func fbm_cellular2(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			
			var dist : float = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;
	
	return min_dist2-min_dist1;

func fbm_cellular3(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size))*0.5 + Vector2(x, y);
			
			var dist : float = abs((f - node).x) + abs((f - node).y);
			
			min_dist = min(min_dist, dist);

	return min_dist;

func fbm_cellular4(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size))*0.5 + Vector2(x, y);
			
			var dist : float = abs((f - node).x) + abs((f - node).y);
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;

	return min_dist2 - min_dist1;

func fbm_cellular5(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = max(abs((f - node).x), abs((f - node).y));
			min_dist = min(min_dist, dist);

	return min_dist;



func fbm_cellular6(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size)) + Vector2(x, y);
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
		return Commons.fractv2(rv);
	else:
		return Commons.clampv2(rv, Vector2(0, 0), Vector2(1, 1));
		

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

