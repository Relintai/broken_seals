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

enum CombinerAxisType {
	SINE,
	TRIANGLE,
	SQUARE,
	SAWTOOTH,
	CONSTANT,
	BOUNCE
}

enum  CombinerType {
	MULTIPLY,
	ADD,
	MAX,
	MIN,
	XOR,
	POW
}


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

			var f : float = pattern(v, 4, 4, CombinerType.MULTIPLY, CombinerAxisType.SINE, CombinerAxisType.SINE)

			var col : Color = Color(f, f, f, 1)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

#var p_o7009_x_scale = 4.000000000;
#var p_o7009_y_scale = 4.000000000;


func pattern(uv : Vector2, x_scale : float, y_scale : float, ct : int, catx : int, caty : int) -> float:
	var x : float = 0
	var y : float = 0
	
	#in c++ these ifs should be function pointers or macros in the caller
	if catx == CombinerAxisType.SINE:
		x = wave_sine(x_scale * uv.x)
	elif catx == CombinerAxisType.TRIANGLE:
		x = wave_triangle(x_scale * uv.x)
	elif catx == CombinerAxisType.SQUARE:
		x = wave_square(x_scale * uv.x)
	elif catx == CombinerAxisType.SAWTOOTH:
		x = wave_sawtooth(x_scale * uv.x)
	elif catx == CombinerAxisType.CONSTANT:
		x = wave_constant(x_scale * uv.x)
	elif catx == CombinerAxisType.BOUNCE:
		x = wave_bounce(x_scale * uv.x)
		
	if caty == CombinerAxisType.SINE:
		y = wave_sine(y_scale * uv.y)
	elif caty == CombinerAxisType.TRIANGLE:
		y = wave_triangle(y_scale * uv.y)
	elif caty == CombinerAxisType.SQUARE:
		y = wave_square(y_scale * uv.y)
	elif caty == CombinerAxisType.SAWTOOTH:
		y = wave_sawtooth(y_scale * uv.y)
	elif caty == CombinerAxisType.CONSTANT:
		y = wave_constant(y_scale * uv.y)
	elif caty == CombinerAxisType.BOUNCE:
		y = wave_bounce(y_scale * uv.y)
	
	if ct == CombinerType.MULTIPLY:
		return mix_mul(x, y)
	elif ct == CombinerType.ADD:
		return mix_add(x, y);
	elif ct == CombinerType.MAX:
		return mix_max(x, y);
	elif ct == CombinerType.MIN:
		return mix_min(x, y);
	elif ct == CombinerType.XOR:
		return mix_xor(x, y);
	elif ct == CombinerType.POW:
		return mix_pow(x, y);
		
	return 0.0

func wave_constant(x : float) -> float:
	return 1.0;

func wave_sine(x : float) -> float:
	return 0.5-0.5*cos(3.14159265359*2.0*x);

func wave_triangle(x : float) -> float:
	x = Commons.fractf(x);
	return min(2.0*x, 2.0-2.0*x);

func wave_sawtooth(x : float) -> float:
	return Commons.fractf(x);

func wave_square(x : float) -> float:
	if (Commons.fractf(x) < 0.5):
		return 0.0
	else:
		return 1.0

func wave_bounce(x : float) -> float:
	x = 2.0*(Commons.fractf(x)-0.5);
	return sqrt(1.0-x*x);

func mix_mul(x : float, y : float) -> float:
	return x*y;

func mix_add(x : float, y : float) -> float:
	return min(x+y, 1.0);

func mix_max(x : float, y : float) -> float:
	return max(x, y);

func mix_min(x : float, y : float) -> float:
	return min(x, y);

func mix_xor(x : float, y : float) -> float:
	return min(x+y, 2.0-x-y);

func mix_pow(x : float, y : float) -> float:
	return pow(x, y);


func reffg():
	return false

func reff(bb):
	if bb:
		gen()

