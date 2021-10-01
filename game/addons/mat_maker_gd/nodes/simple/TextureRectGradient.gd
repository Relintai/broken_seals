tool
extends TextureRect

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

var p_o28405_repeat : float = 1.000000000;
var p_o28405_rotate : float = 0.000000000;

var p_o71406_repeat = 1.000000000;
var p_o71406_rotate = 0.000000000;
var p_o71406_gradient_0_pos = 0.000000000;
var p_o71406_gradient_0_r = 0.000000000;
var p_o71406_gradient_0_g = 0.000000000;
var p_o71406_gradient_0_b = 0.000000000;
var p_o71406_gradient_0_a = 1.000000000;
var p_o71406_gradient_1_pos = 0.509090909;
var p_o71406_gradient_1_r = 0.843750000;
var p_o71406_gradient_1_g = 0.003295898;
var p_o71406_gradient_1_b = 0.003295898;
var p_o71406_gradient_1_a = 1.000000000;
var p_o71406_gradient_2_pos = 1.000000000;
var p_o71406_gradient_2_r = 1.000000000;
var p_o71406_gradient_2_g = 1.000000000;
var p_o71406_gradient_2_b = 1.000000000;
var p_o71406_gradient_2_a = 1.000000000;


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
			
#			var rr : float = 0.5+(cos(p_o71406_rotate*0.01745329251)*(v.x-0.5)+sin(p_o71406_rotate*0.01745329251)*(v.y-0.5))/(cos(abs(modf(p_o71406_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
#			var col : Color = gradient_type_1(fractf(rr * p_o71406_repeat));

#			var rr : float = 0.5 + (cos(p_o28405_rotate*0.01745329251)*(v.x-0.5)+sin(p_o28405_rotate*0.01745329251)*(v.y-0.5))/(cos(abs(modf(p_o28405_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237)
#			var col : Color = gradient_type_2(fractf(rr * p_o71406_repeat))
			
#			var rr : float = 0.5+(cos(p_o71406_rotate*0.01745329251)*(v.x-0.5)+sin(p_o71406_rotate*0.01745329251)*(v.y-0.5))/(cos(abs(modf(p_o71406_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
#			var col : Color = gradient_type_3(fractf(rr * p_o71406_repeat))
			
			var rr : float = 0.5+(cos(p_o71406_rotate*0.01745329251)*(v.x-0.5)+sin(p_o71406_rotate*0.01745329251)*(v.y-0.5))/(cos(abs(Commons.modf(p_o71406_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
			var col : Color = gradient_type_4(Commons.fractf(rr * p_o71406_repeat));

			image.set_pixel(x, y, col)

	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

func gradient_type_1(x : float) -> Color:
	if (x < 0.5*(p_o71406_gradient_0_pos+p_o71406_gradient_1_pos)):
		return Color(p_o71406_gradient_0_r,p_o71406_gradient_0_g,p_o71406_gradient_0_b,p_o71406_gradient_0_a);
	elif (x < 0.5*(p_o71406_gradient_1_pos+p_o71406_gradient_2_pos)):
		return Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a);

	return Color(p_o71406_gradient_2_r,p_o71406_gradient_2_g,p_o71406_gradient_2_b,p_o71406_gradient_2_a);

func gradient_type_2(x : float) -> Color:
	if (x < p_o71406_gradient_0_pos):
		return Color(p_o71406_gradient_0_r,p_o71406_gradient_0_g,p_o71406_gradient_0_b,p_o71406_gradient_0_a);
	elif (x < p_o71406_gradient_1_pos):
		return lerp(Color(p_o71406_gradient_0_r,p_o71406_gradient_0_g,p_o71406_gradient_0_b,p_o71406_gradient_0_a), Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a), ((x-p_o71406_gradient_0_pos)/(p_o71406_gradient_1_pos-p_o71406_gradient_0_pos)));
	elif (x < p_o71406_gradient_2_pos):
		return lerp(Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a), Color(p_o71406_gradient_2_r,p_o71406_gradient_2_g,p_o71406_gradient_2_b,p_o71406_gradient_2_a), ((x-p_o71406_gradient_1_pos)/(p_o71406_gradient_2_pos-p_o71406_gradient_1_pos)));
  
	return Color(p_o71406_gradient_2_r,p_o71406_gradient_2_g,p_o71406_gradient_2_b,p_o71406_gradient_2_a);

func gradient_type_3(x : float) -> Color:
	if (x < p_o71406_gradient_0_pos):
		return Color(p_o71406_gradient_0_r,p_o71406_gradient_0_g,p_o71406_gradient_0_b,p_o71406_gradient_0_a);
	elif (x < p_o71406_gradient_1_pos):
		return lerp(Color(p_o71406_gradient_0_r,p_o71406_gradient_0_g,p_o71406_gradient_0_b,p_o71406_gradient_0_a), Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a), 0.5-0.5*cos(3.14159265359*(x-p_o71406_gradient_0_pos)/(p_o71406_gradient_1_pos-p_o71406_gradient_0_pos)));
	elif (x < p_o71406_gradient_2_pos):
		return lerp(Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a), Color(p_o71406_gradient_2_r,p_o71406_gradient_2_g,p_o71406_gradient_2_b,p_o71406_gradient_2_a), 0.5-0.5*cos(3.14159265359*(x-p_o71406_gradient_1_pos)/(p_o71406_gradient_2_pos-p_o71406_gradient_1_pos)));

	return Color(p_o71406_gradient_2_r,p_o71406_gradient_2_g,p_o71406_gradient_2_b,p_o71406_gradient_2_a);


func gradient_type_4(x : float) -> Color:
	if (x < p_o71406_gradient_0_pos):
		return Color(p_o71406_gradient_0_r,p_o71406_gradient_0_g,p_o71406_gradient_0_b,p_o71406_gradient_0_a);
	elif (x < p_o71406_gradient_1_pos):
		return lerp(lerp(Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a), Color(p_o71406_gradient_2_r,p_o71406_gradient_2_g,p_o71406_gradient_2_b,p_o71406_gradient_2_a), (x-p_o71406_gradient_1_pos)/(p_o71406_gradient_2_pos-p_o71406_gradient_1_pos)), lerp(Color(p_o71406_gradient_0_r,p_o71406_gradient_0_g,p_o71406_gradient_0_b,p_o71406_gradient_0_a), Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a), (x-p_o71406_gradient_0_pos)/(p_o71406_gradient_1_pos-p_o71406_gradient_0_pos)), 1.0-0.5*(x-p_o71406_gradient_0_pos)/(p_o71406_gradient_1_pos-p_o71406_gradient_0_pos));
	elif (x < p_o71406_gradient_2_pos):
		return lerp(lerp(Color(p_o71406_gradient_0_r,p_o71406_gradient_0_g,p_o71406_gradient_0_b,p_o71406_gradient_0_a), Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a), (x-p_o71406_gradient_0_pos)/(p_o71406_gradient_1_pos-p_o71406_gradient_0_pos)), lerp(Color(p_o71406_gradient_1_r,p_o71406_gradient_1_g,p_o71406_gradient_1_b,p_o71406_gradient_1_a), Color(p_o71406_gradient_2_r,p_o71406_gradient_2_g,p_o71406_gradient_2_b,p_o71406_gradient_2_a), (x-p_o71406_gradient_1_pos)/(p_o71406_gradient_2_pos-p_o71406_gradient_1_pos)), 0.5+0.5*(x-p_o71406_gradient_1_pos)/(p_o71406_gradient_2_pos-p_o71406_gradient_1_pos));
  
	return Color(p_o71406_gradient_2_r,p_o71406_gradient_2_g,p_o71406_gradient_2_b,p_o71406_gradient_2_a);

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

