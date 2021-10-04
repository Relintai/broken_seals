tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf2d.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

func _ready():
	pass
	

#sdshow
var p_o47009_bevel = 0.100000000;

#circle
var p_o11635_r = 0.400000000;
var p_o11635_cx = 0.000000000;
var p_o11635_cy = 0.000000000;

#box
var p_o48575_w = 0.300000000;
var p_o48575_h = 0.200000000;
var p_o48575_cx = 0.000000000;
var p_o48575_cy = 0.000000000;

#line
var p_o49570_ax = -0.300000000;
var p_o49570_ay = -0.300000000;
var p_o49570_bx = 0.300000000;
var p_o49570_by = 0.300000000;
var p_o49570_r = 0.200000000;

#rhombus
var p_o50848_w = 0.300000000;
var p_o50848_h = 0.200000000;
var p_o50848_cx = 0.000000000;
var p_o50848_cy = 0.000000000;

#arc
var p_o51990_a1 = 0.000000000;
var p_o51990_a2 = 0.000000000;
var p_o51990_r1 = 0.300000000;
var p_o51990_r2 = 0.100000000;

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

#			var fc : float = sdf_circle(v)
#			var fc : float = sdf_box(v)
#			var fc : float = sdf_line(v)
#			var fc : float = sdf_rhombus(v)
#			var fc : float = sdf_arc(v)
			
			var fc : float = SDF2D.sdf_boolean_union(sdf_circle(v), sdf_box(v))
#			var fc : float = SDF2D.sdf_boolean_substraction(sdf_circle(v), sdf_box(v))
#			var fc : float = SDF2D.sdf_boolean_intersection(sdf_circle(v), sdf_box(v))
			
#			var fc : float = SDF2D.sdf_smooth_boolean_union(sdf_circle(v), sdf_box(v), 0.15)
#			var fc : float = SDF2D.sdf_smooth_boolean_substraction(sdf_circle(v), sdf_box(v), 0.15)
#			var fc : float = SDF2D.sdf_smooth_boolean_intersection(sdf_circle(v), sdf_box(v), 0.15)

#			var fc : float = SDF2D.sdf_rounded_shape(sdf_box(v), 0.15)
#			var fc : float = SDF2D.sdf_annular_shape(sdf_box(v), 0.15)
			
#			var fc : float = SDF2D.sdf_morph(sdf_circle(v), sdf_box(v), 0.5)
			
			var col : Color = sdf_show(fc)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

func sdf_show(val : float) -> Color:
	return SDF2D.sdf_show(val, p_o47009_bevel)

func sdf_circle(uv : Vector2) -> float:
	return SDF2D.sdf_circle(uv, Vector2(p_o11635_cx, p_o11635_cy), p_o11635_r)

func sdf_box(uv : Vector2) -> float:
	return SDF2D.sdf_box(uv, Vector2(p_o48575_cx, p_o48575_cx), Vector2(p_o48575_w, p_o48575_h))

func sdf_line(uv : Vector2) -> float:
	return SDF2D.sdf_line(uv, Vector2(p_o49570_ax, p_o49570_ay), Vector2(p_o49570_bx, p_o49570_by), p_o49570_r)

func sdf_rhombus(uv : Vector2) -> float:
	return SDF2D.sdf_rhombus(uv, Vector2(p_o50848_cx, p_o50848_cy), Vector2(p_o50848_w, p_o50848_h))

func sdf_arc(uv : Vector2) -> float:
	return SDF2D.sdf_arc(uv, Vector2(p_o51990_a1, p_o51990_a2), Vector2(p_o51990_r1, p_o51990_r2))

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

