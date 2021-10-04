tool
extends MMNode

var NoiseVoronoi = preload("res://addons/mat_maker_gd/nodes/common/noise_voronoi.gd")

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

#			var col : Color = voron_1(v)
#			var col : Color = voron_2(v)
			var col : Color = voron_3(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o8689 = 11667;
var p_o8689_scale_x = 4.000000000;
var p_o8689_scale_y = 4.000000000;
var p_o8689_stretch_x = 1.000000000;
var p_o8689_stretch_y = 1.000000000;
var p_o8689_intensity = 1.000000000;
var p_o8689_randomness = 0.750000000;

func voron_1(uv : Vector2) -> Color:
	return NoiseVoronoi.voronoi_1(uv, Vector2(p_o8689_scale_x, p_o8689_scale_y), Vector2(p_o8689_stretch_y, p_o8689_stretch_x), p_o8689_intensity, p_o8689_randomness, seed_o8689)

func voron_2(uv : Vector2) -> Color:
	return NoiseVoronoi.voronoi_2(uv, Vector2(p_o8689_scale_x, p_o8689_scale_y), Vector2(p_o8689_stretch_y, p_o8689_stretch_x), p_o8689_intensity, p_o8689_randomness, seed_o8689)

func voron_3(uv : Vector2) -> Color:
	return NoiseVoronoi.voronoi_3(uv, Vector2(p_o8689_scale_x, p_o8689_scale_y), Vector2(p_o8689_stretch_y, p_o8689_stretch_x), p_o8689_intensity, p_o8689_randomness, seed_o8689)

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

