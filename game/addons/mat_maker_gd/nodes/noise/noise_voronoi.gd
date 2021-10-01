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

#			var col : Color = voron_1(v)
#			var col : Color = voron_2(v)
			var col : Color = voron_3(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex


func voron_1(uv : Vector2) -> Color:
	var c : Color = voronoi(((uv)), Vector2(p_o8689_scale_x, p_o8689_scale_y), Vector2(p_o8689_stretch_y, p_o8689_stretch_x), p_o8689_intensity, p_o8689_randomness, seed_o8689);
	
	return Color(c.b, c.b, c.b, 1)

func voron_2(uv : Vector2) -> Color:
	var c : Color = voronoi(((uv)), Vector2(p_o8689_scale_x, p_o8689_scale_y), Vector2(p_o8689_stretch_y, p_o8689_stretch_x), p_o8689_intensity, p_o8689_randomness, seed_o8689);
	
	return Color(c.a, c.a, c.a, 1)

func voron_3(uv : Vector2) -> Color:
	var c : Color = voronoi(((uv)), Vector2(p_o8689_scale_x, p_o8689_scale_y), Vector2(p_o8689_stretch_y, p_o8689_stretch_x), p_o8689_intensity, p_o8689_randomness, seed_o8689);
	
	var vv : Vector2 = Vector2(c.r, c.g)
	
	var v : Vector3 = Commons.rand3(Commons.fractv2(vv));
	
	return Color(v.x, v.y, v.z, 1)


var seed_o8689 = 11667;
var p_o8689_scale_x = 4.000000000;
var p_o8689_scale_y = 4.000000000;
var p_o8689_stretch_x = 1.000000000;
var p_o8689_stretch_y = 1.000000000;
var p_o8689_intensity = 1.000000000;
var p_o8689_randomness = 0.750000000;


func voronoi(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var seed2 : Vector2 = Commons.rand2(Vector2(float(pseed), 1.0-float(pseed)));
	uv *= size;
	var best_distance0 : float = 1.0;
	var best_distance1 : float = 1.0;
	var point0 : Vector2;
	var point1 : Vector2;
	var p0 : Vector2 = Commons.floorv2(uv);
	
	for dx in range(-1, 2):# (int dx = -1; dx < 2; ++dx) {
		for dy in range(-1, 2):# (int dy = -1; dy < 2; ++dy) {
			var d : Vector2 = Vector2(float(dx), float(dy));
			var p : Vector2 = p0+d;
			
			p += randomness * Commons.rand2(seed2 + Commons.modv2(p, size));
			var distance : float = (stretch * (uv - p) / size).length();
			
			if (best_distance0 > distance):
				best_distance1 = best_distance0;
				best_distance0 = distance;
				point1 = point0;
				point0 = p;
			elif (best_distance1 > distance):
				best_distance1 = distance;
				point1 = p;

	var edge_distance : float = (uv - 0.5*(point0+point1)).dot((point0-point1).normalized());
	
	return Color(point0.x, point0.y, best_distance0 * (size).length() * intensity, edge_distance);

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

