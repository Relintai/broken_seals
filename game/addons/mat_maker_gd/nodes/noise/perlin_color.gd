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

#			var f : float = pattern(v, 4, 4, CombinerType.MULTIPLY, CombinerAxisType.SINE, CombinerAxisType.SINE)

			var col : Color = sinewave(v)
#			var col : Color = beehive_2_col(v)
#			var col : Color = beehive_3_col(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o28198 = 53932;
var p_o28198_scale_x = 4.000000000;
var p_o28198_scale_y = 4.000000000;
var p_o28198_iterations = 3.000000000;
var p_o28198_persistence = 0.500000000;

func sinewave(uv : Vector2) -> Color:

	var f : Vector3 = Commons.perlin_color(((uv)), Vector2(p_o28198_scale_x, p_o28198_scale_y), int(p_o28198_iterations), p_o28198_persistence, seed_o28198);

	return Color(f.x, f.y, f.z, 1)

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

