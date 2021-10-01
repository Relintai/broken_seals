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

			var col : Color = weavecol(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex


var p_o46354_columns = 4.000000000;
var p_o46354_rows = 4.000000000;
var p_o46354_width = 1.000000000;

func weavecol(uv : Vector2) -> Color:
	var f : float = weave(uv, Vector2(p_o46354_columns, p_o46354_rows), p_o46354_width*1.0);

	return Color(f, f, f, 1)


func weave(uv : Vector2, count : Vector2, width : float) -> float:
	uv *= count;
	var c : float = (sin(3.1415926* (uv.x + floor(uv.y)))*0.5+0.5)*Commons.step(abs(Commons.fract(uv.y)-0.5), width*0.5);
	c = max(c, (sin(3.1415926*(1.0+uv.y+floor(uv.x)))*0.5+0.5)*Commons.step(abs(Commons.fract(uv.x)-0.5), width*0.5));
	return c;


func reffg():
	return false

func reff(bb):
	if bb:
		gen()

