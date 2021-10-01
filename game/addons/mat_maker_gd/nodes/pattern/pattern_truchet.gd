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

			var col : Color = trunchet(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex



var seed_o9164 = 6039;
var p_o9164_size = 4.000000000;

func trunchet(uv : Vector2) -> Color:
#	var f : float = truchet1(uv * p_o9164_size, Vector2(float(seed_o9164), float(seed_o9164)));
	var f : float = truchet2(uv * p_o9164_size, Vector2(float(seed_o9164), float(seed_o9164)));
	var col : Color  = Color(f, f, f, 1);
	
	return col

func truchet1(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = Commons.floorv2(uv);
	var f : Vector2 = Commons.fractv2(uv) - Vector2(0.5, 0.5);
	return 1.0 - abs(abs((2.0*Commons.step(Commons.rand(i+pseed), 0.5)-1.0)*f.x+f.y)-0.5);

func truchet2(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = Commons.floorv2(uv);
	var f : Vector2 = Commons.fractv2(uv);
	var random : float = Commons.step(Commons.rand(i+pseed), 0.5);
	f.x *= 2.0 * random-1.0;
	f.x += 1.0 - random;
	return 1.0 - min(abs(f.length() - 0.5), abs((Vector2(1, 1) - f).length() - 0.5));

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

