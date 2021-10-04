tool
extends MMNode

var Gradients = preload("res://addons/mat_maker_gd/nodes/common/gradients.gd")
var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

class TGEntry:
	var pos : float
	var r : float
	var g : float
	var b : float
	var a : float

var p_o28405_repeat : float = 1.000000000;
var p_o28405_rotate : float = 0.000000000;


var p_o24141_gradient_0_pos = 0.000000000;
var p_o24141_gradient_0_r = 0.000000000;
var p_o24141_gradient_0_g = 0.000000000;
var p_o24141_gradient_0_b = 0.000000000;
var p_o24141_gradient_0_a = 1.000000000;
var p_o24141_gradient_1_pos = 0.554545455;
var p_o24141_gradient_1_r = 0.769531250;
var p_o24141_gradient_1_g = 0.318634033;
var p_o24141_gradient_1_b = 0.318634033;
var p_o24141_gradient_1_a = 1.000000000;
var p_o24141_gradient_2_pos = 1.000000000;
var p_o24141_gradient_2_r = 1.000000000;
var p_o24141_gradient_2_g = 1.000000000;
var p_o24141_gradient_2_b = 1.000000000;
var p_o24141_gradient_2_a = 1.000000000;

func gen() -> void:
	if !image:
		image = Image.new()
		image.create(300, 300, false, Image.FORMAT_RGBA8)
		
	if !tex:
		tex = ImageTexture.new()
		
#	var bmin : Vector2 = Vector2(0.1, 0.1)
#	var bmax : Vector2 = Vector2(1, 1)

	var data : PoolRealArray = PoolRealArray()
	data.resize(15)
	var i : int = 0
	data[i + 0] = p_o24141_gradient_0_pos
	data[i + 1] = p_o24141_gradient_0_r
	data[i + 2] = p_o24141_gradient_0_g
	data[i + 3] = p_o24141_gradient_0_b
	data[i + 4] = p_o24141_gradient_0_a
	i += 5
	data[i + 0] = p_o24141_gradient_1_pos
	data[i + 1] = p_o24141_gradient_1_r
	data[i + 2] = p_o24141_gradient_1_g
	data[i + 3] = p_o24141_gradient_1_b
	data[i + 4] = p_o24141_gradient_1_a
	i += 5
	data[i + 0] = p_o24141_gradient_2_pos
	data[i + 1] = p_o24141_gradient_2_r
	data[i + 2] = p_o24141_gradient_2_g
	data[i + 3] = p_o24141_gradient_2_b
	data[i + 4] = p_o24141_gradient_2_a

	image.lock()
	
	var w : float = image.get_width()
	var h : float = image.get_width()
	
	var pseed : float = randf() + randi()
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var uv : Vector2 = Vector2(x / w, y / h)
			
#			vec4 o24141_0_1_rgba = o24141_gradient_gradient_fct(fract(p_o24141_repeat*1.41421356237*length(fract(((uv)))-vec2(0.5, 0.5))));
#			vec3 o3335_0_1_rgb = ((o24141_0_1_rgba).rgb);
#

#			var col : Color = radial_gradient_type_1(fractf(p_o28405_repeat*1.41421356237* (fract(uv)- Vector2(0.5, 0.5)).length()))
#			var col : Color = radial_gradient_type_2(fractf(p_o28405_repeat*1.41421356237* (fract(uv)- Vector2(0.5, 0.5)).length()))
#			var col : Color = radial_gradient_type_3(fractf(p_o28405_repeat*1.41421356237* (fract(uv)- Vector2(0.5, 0.5)).length()))
#			var col : Color = radial_gradient_type_4(Commons.fractf(p_o28405_repeat*1.41421356237* (Commons.fract(uv)- Vector2(0.5, 0.5)).length()))
			var col : Color = Gradients.radial_gradient_type_1(uv, p_o28405_repeat, data);

			image.set_pixel(x, y, col)

	image.unlock()
	
	tex.create_from_image(image)
#	texture = tex

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

