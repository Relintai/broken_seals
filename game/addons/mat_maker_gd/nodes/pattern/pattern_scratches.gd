tool
extends MMNode

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

#			var f : float = pattern(v, 4, 4, CombinerType.MULTIPLY, CombinerAxisType.SINE, CombinerAxisType.SINE)

			var col : Color = scratchescol(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
#	texture = tex

var seed_o74963 = 31821;
var p_o74963_length = 0.250000000;
var p_o74963_width = 0.400000000;
var p_o74963_layers = 5.000000000;
var p_o74963_waviness = 0.510000000;
var p_o74963_angle = -1.000000000;
var p_o74963_randomness = 0.440000000;

func scratchescol(uv : Vector2) -> Color:
	return Patterns.scratchesc(uv, int(p_o74963_layers), Vector2(p_o74963_length, p_o74963_width), p_o74963_waviness, p_o74963_angle, p_o74963_randomness, Vector2(float(seed_o74963), 0.0));

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

