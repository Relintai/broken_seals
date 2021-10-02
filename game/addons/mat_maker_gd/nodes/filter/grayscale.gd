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
			
			f = gs_luminosity(Vector3(f, f, f));
			
			var c : Color = Color(f, f, f, 1)
			
#			c = invert(c)
#			c = brightness_contrast(c)

			#needs work

			image.set_pixel(x, y, c)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

func gs_min(c : Vector3) -> float:
	return min(c.x, min(c.y, c.z));

func gs_max(c : Vector3) -> float:
	return max(c.x, max(c.y, c.z));

func gs_lightness(c : Vector3) -> float:
	return 0.5*(max(c.x, max(c.y, c.z)) + min(c.x, min(c.y, c.z)));

func gs_average(c : Vector3) -> float:
	return 0.333333333333*(c.x + c.y + c.z);

func gs_luminosity(c : Vector3) -> float:
	return 0.21 * c.x + 0.72 * c.y + 0.07 * c.z;

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

