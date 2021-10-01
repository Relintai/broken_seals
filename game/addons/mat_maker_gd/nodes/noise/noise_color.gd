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

			var col : Color = nc(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex


func nc(uv : Vector2) -> Color:
	var v : Vector3 = color_dots(((uv)), 1.0/512.000000000, seed_o26210);

	return Color(v.x, v.y, v.z, 1)


var seed_o26210 = 7313;

func color_dots(uv : Vector2, size : float, pseed : int) -> Vector3:
	var seed2 : Vector2 = Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed)));
	uv /= size;
	var point_pos : Vector2 = Commons.floorv2(uv) + Vector2(0.5, 0.5);
	return Commons.rand3(seed2 + point_pos);


func transform(uv : Vector2, translate : Vector2, rotate : float, scale : Vector2, repeat : bool) -> Vector2:
	var rv : Vector2 = Vector2();
	uv -= translate;
	uv -= Vector2(0.5, 0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += Vector2(0.5, 0.5);
	
	if (repeat):
		return Commons.fractv2(rv);
	else:
		return Commons.clampv2(rv, Vector2(0, 0), Vector2(1, 1));
	

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

