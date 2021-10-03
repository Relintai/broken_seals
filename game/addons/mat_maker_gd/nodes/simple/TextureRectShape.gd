tool
extends TextureRect

var Shapes = preload("res://addons/mat_maker_gd/nodes/common/shapes.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

	
var p_o3704_albedo_color_r : float = 1.000000000;
var p_o3704_albedo_color_g  : float = 1.000000000;
var p_o3704_albedo_color_b : float = 1.000000000;
var p_o3704_albedo_color_a : float = 1.000000000;
var p_o3704_metallic : float = 1.000000000;
var p_o3704_roughness : float = 1.000000000;
var p_o3704_emission_energy : float = 1.000000000;
var p_o3704_normal : float = 1.000000000;
var p_o3704_ao : float = 1.000000000;
var p_o3704_depth_scale : float = 0.500000000;
var p_o3704_sss : float = 0.000000000;

var p_o69054_sides : float = 6.000000000;
var p_o69054_radius : float = 0.845361000;
var p_o69054_edge : float = 0.051546000;

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

#			var c : float = Commons.shape_circle(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = Commons.shape_polygon(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = Commons.shape_star(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = Commons.shape_curved_star(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
			var c : float = Shapes.shape_rays(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)

			image.set_pixel(x, y, Color(c, c, c, 1))

	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

