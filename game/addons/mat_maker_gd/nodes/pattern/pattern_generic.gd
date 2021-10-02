tool
extends TextureRect

var Patterns = preload("res://addons/mat_maker_gd/nodes/common/patterns.gd")

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

			var f : float = Patterns.pattern(v, 4, 4, Patterns.CombinerType.MULTIPLY, Patterns.CombinerAxisType.SINE, Patterns.CombinerAxisType.SINE)

			var col : Color = Color(f, f, f, 1)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

#var p_o7009_x_scale = 4.000000000;
#var p_o7009_y_scale = 4.000000000;

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

