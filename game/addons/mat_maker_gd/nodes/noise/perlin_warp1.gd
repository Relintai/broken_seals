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

var p_o41835_translate_x = 0.500000000;
var p_o41835_translate_y = 0.500000000;
var p_o41835_rotate = 0.000000000;
var p_o41835_scale_x = 1.000000000;
var p_o41835_scale_y = 1.000000000;
var seed_o41836 = 31052;
var p_o41836_scale_x = 4.000000000;
var p_o41836_scale_y = 4.000000000;
var p_o41836_iterations = 3.000000000;
var p_o41836_persistence = 0.500000000;

func sinewave(uv : Vector2) -> Color:
	var f : float = perlin((((uv))), Vector2(p_o41836_scale_x, p_o41836_scale_y), int(p_o41836_iterations), p_o41836_persistence, seed_o41836);
	var ff : float = perlin((transform(((uv)), Vector2(p_o41835_translate_x*(2.0*f-1.0), p_o41835_translate_y*(2.0*f-1.0)), p_o41835_rotate*0.01745329251*(2.0*1.0-1.0), Vector2(p_o41835_scale_x*(2.0*1.0-1.0), p_o41835_scale_y*(2.0*1.0-1.0)), true)), Vector2(p_o41836_scale_x, p_o41836_scale_y), int(p_o41836_iterations), p_o41836_persistence, seed_o41836);

	return Color(ff, ff, ff, 1)


func perlin(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> float:
	var seed2 : Vector2 = Commons.rand2(Vector2(float(pseed), 1.0-float(pseed)));
	var rv : float = 0.0;
	var coef : float = 1.0;
	var acc : float = 0.0;
	
	for i in range(iterations):
		var step : Vector2 = Vector2(1, 1) / size;
		var xy : Vector2 = Commons.floorv2(uv * size);
		var f0 : float = Commons.rand(seed2 + Commons.modv2(xy, size));
		var f1 : float = Commons.rand(seed2 + Commons.modv2(xy + Vector2(1.0, 0.0), size));
		var f2 : float = Commons.rand(seed2 + Commons.modv2(xy + Vector2(0.0, 1.0), size));
		var f3 : float = Commons.rand(seed2 + Commons.modv2(xy + Vector2(1.0, 1.0), size));

		var mixval : Vector2 = Commons.smoothstepv2(0.0, 1.0, Commons.fractv2(uv * size));
		
		rv += coef * lerp(lerp(f0, f1, mixval.x), lerp(f2, f3, mixval.x), mixval.y);
		acc += coef;
		size *= 2.0;
		coef *= persistence;

	
	return rv / acc;


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

