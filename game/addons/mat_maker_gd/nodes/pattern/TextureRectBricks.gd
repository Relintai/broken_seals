tool
extends MMNode

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

func _ready():
	pass
	
	
#float o39644_0_2_f : float = o39644_0.x
var seed_o39644 : int = 15005
var p_o39644_repeat : float = 1.000000000
var p_o39644_rows : float = 6.000000000
var p_o39644_columns : float = 3.000000000
var p_o39644_row_offset : float = 0.500000000
var p_o39644_mortar: float = 0.100000000
var p_o39644_bevel : float = 0.100000000
var p_o39644_round : float= 0.000000000
var p_o39644_corner : float = 0.420000000


var p_o3335_albedo_color_r : float = 1.000000000
var p_o3335_albedo_color_g : float = 1.000000000
var p_o3335_albedo_color_b : float = 1.000000000
var p_o3335_albedo_color_a : float = 1.000000000
var p_o3335_metallic : float = 1.000000000
var p_o3335_roughness : float = 1.000000000
var p_o3335_emission_energy : float = 1.000000000
var p_o3335_normal : float = 1.000000000
var p_o3335_ao : float = 1.000000000
var p_o3335_depth_scale : float = 0.500000000
var p_o3335_sss : float = 0.000000000



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

#			var vb : Vector3 = brick_uv(v, bmin, bmax, pseed)
##			var col : Color = Color(vb.x, vb.y, vb.z, 1)
#
#			var col : Color = brick(v, bmin, bmax, 0.2, 0.2, 0.2)
#			var cc : Color = Color(vb.x, vb.y, vb.z, 1)
#			image.set_pixel(x, y, cc)
			
			#Running Bond
#			var brect : Color = bricks_rb(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			#RunningBond2
#			var brect : Color = bricks_rb2(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			#HerringBone
#			var brect : Color = bricks_hb(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			#BasketWeave
#			var brect : Color = bricks_bw(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			#SpanishBond
			var brect : Color = Patterns.bricks_sb(v, Vector2(p_o39644_columns, p_o39644_rows), p_o39644_repeat, p_o39644_row_offset);
			
			
			# 1, 2
			var fcolor : Color = Patterns.brick(v, Vector2(brect.r, brect.g),  Vector2(brect.b, brect.a), p_o39644_mortar*1.0, p_o39644_round*1.0, max(0.001, p_o39644_bevel*1.0));
			
#			image.set_pixel(x, y, brect)
#			image.set_pixel(x, y, fcolor)
#			image.set_pixel(x, y, Color(fcolor.r, fcolor.g, fcolor.b, 1))

			#1
			var rr : float = fcolor.r;
			image.set_pixel(x, y, Color(rr,rr, rr, 1))
#
#			# 3
#			var yy : float = fcolor.g;
#			image.set_pixel(x, y, Color(yy,yy, yy, 1))
#
#			# 4
#			var zz : float = fcolor.b;
#			image.set_pixel(x, y, Color(zz,zz, zz, 1))
			
			# 5
#			var c : Vector3 = brick_uv(v, Vector2(brect.r, brect.g),  Vector2(brect.b, brect.a), float(seed_o39644))
#			image.set_pixel(x, y, Color(c.x, c.y, c.z, 1))

			# 6
#			var c : Vector3 = brick_corner_uv(v, Vector2(brect.r, brect.g),  Vector2(brect.b, brect.a), p_o39644_mortar*1.0, p_o39644_corner, float(seed_o39644));
#			image.set_pixel(x, y, Color(c.x, c.y, c.z, 1))


			# 7
#			var f : float = 0.5*(sign(brect.b-brect.r-brect.a+brect.g)+1.0);
#			image.set_pixel(x, y, Color(f, f, f, 1))

			
			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex


func reffg():
	return false

func reff(bb):
	if bb:
		gen()

