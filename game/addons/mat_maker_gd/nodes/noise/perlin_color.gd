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

			var col : Color = sinewave(v)
#			var col : Color = beehive_2_col(v)
#			var col : Color = beehive_3_col(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o28198 = 53932;
var p_o28198_scale_x = 4.000000000;
var p_o28198_scale_y = 4.000000000;
var p_o28198_iterations = 3.000000000;
var p_o28198_persistence = 0.500000000;

func sinewave(uv : Vector2) -> Color:

	var f : Vector3 = perlin_color(((uv)), Vector2(p_o28198_scale_x, p_o28198_scale_y), int(p_o28198_iterations), p_o28198_persistence, seed_o28198);

	return Color(f.x, f.y, f.z, 1)

func perlin_color(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Vector3:
	var seed2 : Vector2 = Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed)));
	var rv : Vector3 = Vector3();
	var coef : float = 1.0;
	var acc : float = 0.0;
	
	for i in range(iterations):
		var step : Vector2 = Vector2(1, 1) / size;
		var xy : Vector2 = Commons.floorv2(uv * size);
		
		var f0 : Vector3 = Commons.rand3(seed2 + Commons.modv2(xy, size));
		var f1 : Vector3 = Commons.rand3(seed2 + Commons.modv2(xy + Vector2(1.0, 0.0), size));
		var f2 : Vector3 = Commons.rand3(seed2 + Commons.modv2(xy + Vector2(0.0, 1.0), size));
		var f3 : Vector3 = Commons.rand3(seed2 + Commons.modv2(xy + Vector2(1.0, 1.0), size));

		var mixval : Vector2 = Commons.smoothstepv2(0.0, 1.0, Commons.fractv2(uv * size));
		
		rv += coef * lerp(lerp(f0, f1, mixval.x), lerp(f2, f3, mixval.x), mixval.y);
		
		acc += coef;
		size *= 2.0;
		coef *= persistence;

	return rv / acc;

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

