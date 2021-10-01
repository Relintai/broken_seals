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

			var col : Color = beehive_1_col(v)
#			var col : Color = beehive_2_col(v)
#			var col : Color = beehive_3_col(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o80035 = 15184;
var p_o80035_sx = 4.000000000;
var p_o80035_sy = 4.000000000;

func beehive_1_col(uv : Vector2) -> Color:
	var o80035_0_uv : Vector2 = ((uv)) * Vector2(p_o80035_sx, p_o80035_sy * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	return Color(f, f, f, 1)
	
func beehive_2_col(uv : Vector2) -> Color:
	var o80035_0_uv : Vector2 = ((uv)) * Vector2(p_o80035_sx, p_o80035_sy * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	var v : Vector3 = Commons.rand3(Commons.fractv2(Vector2(center.b, center.a) / Vector2(p_o80035_sx, p_o80035_sy)) + Vector2(float(seed_o80035),float(seed_o80035)));
	
	return Color(v.x, v.y, v.z, 1)

func beehive_3_col(uv : Vector2) -> Color:
	var o80035_0_uv : Vector2 = ((uv)) * Vector2(p_o80035_sx, p_o80035_sy * 1.73205080757);
	var center : Color = Commons.beehive_center(o80035_0_uv);
	
	#var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	var v1 : Vector2 = Vector2(0.5, 0.5) + Vector2(center.r, center.g)
	var ff : float = Commons.rand(Commons.fractv2(Vector2(center.b, center.a) / Vector2(p_o80035_sx, p_o80035_sy)) + Vector2(float(seed_o80035), float(seed_o80035)))
	
	var c : Color = Color(v1.x, v1.y, ff, ff);
	
	return c


func beehive_dist(p : Vector2) -> float:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	p = Commons.absv2(p);
	
	return max(p.dot(s*.5), p.x);

func beehive_center(p : Vector2) -> Color:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	var hC : Color = Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y);
	
	hC = Commons.floorc(Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y)) + Color(0.5, 0.5, 0.5, 0.5);
	
	var v1 : Vector2 = Vector2(p.x - hC.r * s.x, p.y - hC.g * s.y)
	var v2 : Vector2 = Vector2(p.x - (hC.b + 0.5) * s.x, p.y - (hC.a + 0.5) * s.y)
	
	var h : Color = Color(v1.x, v1.y, v2.x, v2.y);
	
	if Vector2(h.r, h.g).dot(Vector2(h.r, h.g)) < Vector2(h.b, h.a).dot(Vector2(h.b, h.a)):
		return Color(h.r, h.g, hC.r, hC.g) 
	else:
		return Color(h.b, h.a, hC.b + 9.73, hC.a + 9.73)
	
	#return dot(h.xy, h.xy) < dot(h.zw, h.zw) ? Color(h.xy, hC.xy) : Color(h.zw, hC.zw + 9.73);

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

