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

			var col : Color = scratchescol(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o74963 = 31821;
var p_o74963_length = 0.250000000;
var p_o74963_width = 0.400000000;
var p_o74963_layers = 5.000000000;
var p_o74963_waviness = 0.510000000;
var p_o74963_angle = -1.000000000;
var p_o74963_randomness = 0.440000000;

func scratchescol(uv : Vector2) -> Color:
	var f : float =  scratches(((uv)), int(p_o74963_layers), Vector2(p_o74963_length, p_o74963_width), p_o74963_waviness, p_o74963_angle, p_o74963_randomness, Vector2(float(seed_o74963), 0.0));

	return Color(f, f, f, 1)

func scratch(uv : Vector2, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var subdivide : float = floor(1.0/size.x);
	var cut : float = size.x*subdivide;
	uv *= subdivide;
	var r1 : Vector2 = Commons.rand2(Commons.floorv2(uv) + pseed);
	var r2 : Vector2 = Commons.rand2(r1);
	uv = Commons.fractv2(uv);
	uv = 2.0 * uv - Vector2(1, 1);
	
	var a : float = 6.28*(angle+(r1.x-0.5)*randomness);
	var c : float = cos(a);
	var s : float = sin(a);
	
	uv = Vector2(c*uv.x+s*uv.y, s*uv.x-c*uv.y);
	uv.y += 2.0*r1.y-1.0;
	uv.y += 0.5*waviness*cos(2.0*uv.x+6.28*r2.y);
	uv.x /= cut;
	uv.y /= subdivide*size.y;
	
	return (1.0-uv.x*uv.x)*max(0.0, 1.0-1000.0*uv.y*uv.y);

func scratches(uv : Vector2, layers : int, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var v : float = 0.0;
	
	for i in range(layers):# (int i = 0; i < layers; ++i) {
		v = max(v, scratch(Commons.fractv2(uv + pseed), size, waviness, angle/360.0, randomness, pseed));
		pseed = Commons.rand2(pseed);

	return v;

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

