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

			var f : float = Commons.shape_circle(v, 3, 1.0 * 1.0, 1.0)
			var c : Color = Color(f, f, f, 1)
			
#			c = invert(c)
#			c = brightness_contrast(c)

			#needs work
			c = adjust_hsv(c)

			image.set_pixel(x, y, c)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var p_o91644_brightness = 0.000000000;
var p_o91644_contrast = 1.000000000;

func brightness_contrast(color : Color) -> Color:
	var bv : Vector3 = Vector3(p_o91644_brightness, p_o91644_brightness, p_o91644_brightness)
	var cvv : Vector3 = Vector3(color.r * p_o91644_contrast, color.g * p_o91644_contrast, color.b * p_o91644_contrast)
	
	var cv : Vector3 = cvv + bv + Vector3(0.5, 0.5, 0.5) - (Vector3(p_o91644_contrast, p_o91644_contrast, p_o91644_contrast) * 0.5)
	
	var v : Vector3 = Commons.clampv3(cv, Vector3(), Vector3(1, 1, 1))
	
	return Color(v.x, v.y, v.z, 1);

var p_o102649_hue = 0.000000000;
var  p_o102649_saturation = 1.000000000;
var  p_o102649_value = 1.000000000;

func adjust_hsv(color : Color) -> Color:
	var hsv : Vector3 = Commons.rgb_to_hsv(Vector3(color.r, color.g, color.b));
	
	var x : float = Commons.fract(hsv.x + p_o102649_hue)
	var y : float = clamp(hsv.y * p_o102649_saturation, 0.0, 1.0)
	var z : float = clamp(hsv.z * p_o102649_value, 0.0, 1.0)
	
	var h : Vector3 = Commons.hsv_to_rgb(Vector3(x, y, z))

	return Color(h.x, h.y, h.z, color.a);
	
func reffg():
	return false

func reff(bb):
	if bb:
		gen()

