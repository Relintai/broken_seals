tool
extends MMNode

var NoisePerlin = preload("res://addons/mat_maker_gd/nodes/common/noise_perlin.gd")

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

			var col : Color = perlin(v)
#			var col : Color = beehive_2_col(v)
#			var col : Color = beehive_3_col(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o12297 = -26656;
var p_o12297_scale_x = 4.000000000;
var p_o12297_scale_y = 4.000000000;
var p_o12297_iterations = 3.000000000;
var p_o12297_persistence = 0.500000000;

func perlin(uv : Vector2) -> Color:
	var a = NoisePerlin.perlinc(uv, Vector2(p_o12297_scale_x, p_o12297_scale_y), int(p_o12297_iterations), p_o12297_persistence, seed_o12297)
	return a

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

