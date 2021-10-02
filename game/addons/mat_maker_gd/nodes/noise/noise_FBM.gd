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
		value += Commons.fbm_value(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_perlin(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += Commons.fbm_perlin(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += Commons.fbm_cellular(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular2(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += Commons.fbm_cellular2(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;

func o33355_cellular3(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += Commons.fbm_cellular3(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular4(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += Commons.fbm_cellular4(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular5(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += Commons.fbm_cellular5(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
func o33355_cellular6(coord : Vector2, size : Vector2, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		value += Commons.fbm_cellular6(coord*size, size, pseed) * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

