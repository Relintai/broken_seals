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

var p_o56044_translate_x = 0.500000000;
var p_o56044_translate_y = 0.500000000;
var p_o56044_rotate = 0.000000000;
var p_o56044_scale_x = 1.000000000;
var p_o56044_scale_y = 1.000000000;
var p_o56039_translate_x = 0.500000000;
var p_o56039_translate_y = 0.500000000;
var p_o56039_rotate = 0.000000000;
var p_o56039_scale_x = 1.000000000;
var p_o56039_scale_y = 1.000000000;
var seed_o56040 = 26697;
var p_o56040_scale_x = 4.000000000;
var p_o56040_scale_y = 4.000000000;
var p_o56040_iterations = 3.000000000;
var p_o56040_persistence = 0.500000000;

func sinewave(uv : Vector2) -> Color:
	var f = Commons.perlin(((((uv)))), Vector2(p_o56040_scale_x, p_o56040_scale_y), int(p_o56040_iterations), p_o56040_persistence, seed_o56040);
	var ff : float = Commons.perlin((Commons.transform((((uv))), Vector2(p_o56039_translate_x*(2.0*f-1.0), p_o56039_translate_y*(2.0*f-1.0)), p_o56039_rotate*0.01745329251*(2.0*1.0-1.0), Vector2(p_o56039_scale_x*(2.0*1.0-1.0), p_o56039_scale_y*(2.0*1.0-1.0)), true)), Vector2(p_o56040_scale_x, p_o56040_scale_y), int(p_o56040_iterations), p_o56040_persistence, seed_o56040);
	
	var o56039_0_1_rgba : Vector3 = Vector3(ff, ff, ff)
	
	var tf : Vector2 = Commons.transform(uv, Vector2(p_o56044_translate_x * (2.0 * (o56039_0_1_rgba.dot(Vector3(1, 1, 1) / 3.0) - 1.0)), p_o56044_translate_y*(2.0*( o56039_0_1_rgba.dot(Vector3(1, 1, 1) /3.0)-1.0))), p_o56044_rotate*0.01745329251*(2.0*1.0-1.0), Vector2(p_o56044_scale_x*(2.0*1.0-1.0), p_o56044_scale_y*(2.0*1.0-1.0)), true)

	var fff : float = Commons.perlin(tf, Vector2(p_o56040_scale_x, p_o56040_scale_y), int(p_o56040_iterations), p_o56040_persistence, seed_o56040);

	return Color(fff, fff, fff, 1)

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

