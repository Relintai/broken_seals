tool
extends TextureRect

var Gradients = preload("res://addons/mat_maker_gd/nodes/common/gradients.gd")
var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

#class TGEntry:
#	var pos : float
#	var r : float
#	var g : float
#	var b : float
#	var a : float

var p_o95415_repeat = 1.000000000;

var p_o95415_gradient_0_pos = 0.000000000;
var p_o95415_gradient_0_r = 0.000000000;
var p_o95415_gradient_0_g = 0.000000000;
var p_o95415_gradient_0_b = 0.000000000;
var p_o95415_gradient_0_a = 1.000000000;
var p_o95415_gradient_1_pos = 0.490909091;
var p_o95415_gradient_1_r = 1.000000000;
var p_o95415_gradient_1_g = 0.000000000;
var p_o95415_gradient_1_b = 0.000000000;
var p_o95415_gradient_1_a = 1.000000000;
var p_o95415_gradient_2_pos = 1.000000000;
var p_o95415_gradient_2_r = 1.000000000;
var p_o95415_gradient_2_g = 1.000000000;
var p_o95415_gradient_2_b = 1.000000000;
var p_o95415_gradient_2_a = 1.000000000;


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
	data[i + 0] = p_o95415_gradient_0_pos
	data[i + 1] = p_o95415_gradient_0_r
	data[i + 2] = p_o95415_gradient_0_g
	data[i + 3] = p_o95415_gradient_0_b
	data[i + 4] = p_o95415_gradient_0_a
	i += 5
	data[i + 0] = p_o95415_gradient_1_pos
	data[i + 1] = p_o95415_gradient_1_r
	data[i + 2] = p_o95415_gradient_1_g
	data[i + 3] = p_o95415_gradient_1_b
	data[i + 4] = p_o95415_gradient_1_a
	i += 5
	data[i + 0] = p_o95415_gradient_2_pos
	data[i + 1] = p_o95415_gradient_2_r
	data[i + 2] = p_o95415_gradient_2_g
	data[i + 3] = p_o95415_gradient_2_b
	data[i + 4] = p_o95415_gradient_2_a

	image.lock()
	
	var w : float = image.get_width()
	var h : float = image.get_width()
	
	var pseed : float = randf() + randi()
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var uv : Vector2 = Vector2(x / w, y / h)
			
			#branchless fix for division by zero
			uv.y += 0.000001
			
#			var col : Color = gradient_type_1(Commons.fractf(p_o95415_repeat * 0.15915494309 * atan((uv.x - 0.5) / (uv.y - 0.5))));
#			var col : Color = gradient_type_2(Commons.fractf(p_o95415_repeat * 0.15915494309 * atan((uv.x - 0.5) / (uv.y - 0.5))));
#			var col : Color = gradient_type_3(Commons.fractf(p_o95415_repeat * 0.15915494309 * atan((uv.x - 0.5) / (uv.y - 0.5))));
#			var col : Color = gradient_type_4(Commons.fractf(p_o95415_repeat * 0.15915494309 * atan((uv.x - 0.5) / uv.y - 0.5)));
			var col : Color = Gradients.circular_gradient_type_1(uv, p_o95415_repeat, data);

			image.set_pixel(x, y, col)

	image.unlock()
	
	tex.create_from_image(image)
	texture = tex


func gradient_type_1(x : float) -> Color:
	if (x < 0.5*(p_o95415_gradient_0_pos+p_o95415_gradient_1_pos)):
		return Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a);
	elif (x < 0.5*(p_o95415_gradient_1_pos+p_o95415_gradient_2_pos)):
		return Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a);

	return Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a);

func gradient_type_2(x : float) -> Color:
	if (x < p_o95415_gradient_0_pos):
		return Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a);
	elif (x < p_o95415_gradient_1_pos):
		return lerp(Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a), Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), ((x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos)));
	elif (x < p_o95415_gradient_2_pos):
		return lerp(Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a), ((x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos)));

	return Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a);


func gradient_type_3(x : float) -> Color:
	if (x < p_o95415_gradient_0_pos):
		return Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a);
	elif (x < p_o95415_gradient_1_pos):
		return lerp(Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a), Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), 0.5-0.5*cos(3.14159265359*(x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos)));
	if (x < p_o95415_gradient_2_pos):
		return lerp(Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a), 0.5-0.5*cos(3.14159265359*(x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos)));

	return Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a);

func gradient_type_4(x : float) -> Color:
	if (x < p_o95415_gradient_0_pos):
		return Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a);
	elif (x < p_o95415_gradient_1_pos):
		return lerp(lerp(Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a), (x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos)), lerp(Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a), Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), (x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos)), 1.0-0.5*(x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos));
	elif (x < p_o95415_gradient_2_pos):
		return lerp(lerp(Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a), Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), (x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos)), lerp(Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a), (x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos)), 0.5+0.5*(x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos));
  
	return Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a);
 

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

