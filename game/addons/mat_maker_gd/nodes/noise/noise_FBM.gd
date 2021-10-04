tool
extends MMNode

var NoiseFBM = preload("res://addons/mat_maker_gd/nodes/common/noise_fbm.gd")

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

#			var col : Color = fbmval(v)
#			var col : Color = perlin(v)
#			var col : Color = cellular(v)
#			var col : Color = cellular2(v)
#			var col : Color = cellular3(v)
#			var col : Color = cellular4(v)
#			var col : Color = cellular5(v)
			var col : Color = cellular6(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o33355 = 26177;
var p_o33355_scale_x = 2.000000000;
var p_o33355_scale_y = 2.000000000;
var p_o33355_iterations = 5.000000000;
var p_o33355_persistence = 0.500000000;

func fbmval(uv : Vector2) -> Color:
	return NoiseFBM.fbmval(uv, Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355))

func perlin(uv : Vector2) -> Color:
	return NoiseFBM.perlin(uv, Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355))
	
func cellular(uv : Vector2) -> Color:
	return NoiseFBM.cellular(uv, Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355))
	
func cellular2(uv : Vector2) -> Color:
	return NoiseFBM.cellular2(uv, Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355))
	
func cellular3(uv : Vector2) -> Color:
	return NoiseFBM.cellular3(uv, Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355))
	
func cellular4(uv : Vector2) -> Color:
	return NoiseFBM.cellular4(uv, Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355))
	
func cellular5(uv : Vector2) -> Color:
	return NoiseFBM.cellular5(uv, Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355))
	
func cellular6(uv : Vector2) -> Color:
	return NoiseFBM.cellular6(uv, Vector2(p_o33355_scale_x, p_o33355_scale_y), int(p_o33355_iterations), p_o33355_persistence, float(seed_o33355))

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

