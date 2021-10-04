tool
extends MMNode

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

			var f : Vector3 = sharpen(v)
			
			var c : Color = Color(f.x, f.y, f.z, 1)
			
#			c = invert(c)
#			c = brightness_contrast(c)

			#needs work

			image.set_pixel(x, y, c)

			
	image.unlock()

	tex.create_from_image(image)
	texture = tex

func o11853_input_in(uv : Vector2) -> Vector3:
	var f : float = Commons.shape_circle(uv, 3, 1.0 * 1.0, 1.0)

	return Vector3(f, f, f);

func sharpen(uv : Vector2) -> Vector3:
	var e : Vector2 = Vector2(1.0 / 32.000000000, 0.0);
	var rv : Vector3 = 5.0 * o11853_input_in(uv);

	rv -= o11853_input_in(uv + Vector2(e.x, e.y));
	rv -= o11853_input_in(uv - Vector2(e.x, e.y));
	rv -= o11853_input_in(uv + Vector2(e.y, e.x));
	rv -= o11853_input_in(uv - Vector2(e.y, e.x));
	
	return rv

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

