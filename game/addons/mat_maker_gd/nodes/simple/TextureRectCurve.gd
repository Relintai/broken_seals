tool
extends TextureRect

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

var p_o147388_ax = -0.349999994;
var p_o147388_ay = -0.200000000;
var p_o147388_bx = 0.000000000;
var p_o147388_by = 0.500000000;
var p_o147388_cx = 0.350000000;
var p_o147388_cy = -0.200000000;
var p_o147388_width = 0.050000000;
var p_o147388_repeat = 1.000000000;

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

#			var c : float = shape_circle(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_polygon(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_star(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_curved_star(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)

			var o147388_0_bezier : Vector2 = Commons.sdBezier(v, Vector2(p_o147388_ax+0.5, p_o147388_ay+0.5), Vector2(p_o147388_bx+0.5, p_o147388_by+0.5), Vector2(p_o147388_cx+0.5, p_o147388_cy+0.5));
			var o147388_0_uv : Vector2 = Vector2(o147388_0_bezier.x, o147388_0_bezier.y/p_o147388_width+0.5);
			
			var uvt : Vector2 = Commons.absv(o147388_0_uv - Vector2(0.5, 0.5))
			
			uvt.x = Commons.step(0.5, uvt.x);
			uvt.y = Commons.step(0.5, uvt.y);
			
			o147388_0_uv = lerp(Vector2(Commons.fractf(p_o147388_repeat * o147388_0_uv.x), o147388_0_uv.y), Vector2(0, 0), max(uvt.x, uvt.y));
			
			var f : float = Commons.step(abs(((o147388_0_uv)).y-0.5), 0.4999)
			var c : Color = Color(f, f, f, 1.0);


			image.set_pixel(x, y, c)

	image.unlock()
	
	tex.create_from_image(image)
	texture = tex


func reffg():
	return false

func reff(bb):
	if bb:
		gen()

