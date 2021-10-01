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

			var col : Color = runecol(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o57193 = 16936;
var p_o57193_columns = 2.000000000;
var p_o57193_rows = 2.000000000;

func runecol(uv : Vector2) -> Color:
	var f : float =  IChing(Vector2(p_o57193_columns, p_o57193_rows)*((uv)), float(seed_o57193));

	return Color(f, f, f, 1)

func IChing(uv : Vector2, pseed : float) -> float:
	var value : int = int(32.0 * Commons.rand(Commons.floorv2(uv) + Vector2(pseed, pseed)));
	var base : float = Commons.step(0.5, Commons.fract(Commons.fract(uv.y)*6.5))*Commons.step(0.04, Commons.fract(uv.y+0.02)) * Commons.step(0.2, Commons.fract(uv.x+0.1));
	var bit : int = int(Commons.fract(uv.y)*6.5);
	
	return base * Commons.step(0.1*Commons.step(float(bit & value), 0.5), Commons.fract(uv.x+0.55));

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

