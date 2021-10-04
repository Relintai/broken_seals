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

			var col : Color = beehive_1_col(v)
#			var col : Color = beehive_2_col(v)
#			var col : Color = beehive_3_col(v)

			image.set_pixel(x, y, col)

			
	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

var seed_o80035 = 15184;
var p_o80035_sx = 4.000000000;
var p_o80035_sy = 4.000000000;

func beehive_1_col(uv : Vector2) -> Color:
	return Patterns.beehive_1c(uv, Vector2(p_o80035_sx, p_o80035_sy), seed_o80035)
	
func beehive_2_col(uv : Vector2) -> Color:
	return Patterns.beehive_2c(uv, Vector2(p_o80035_sx, p_o80035_sy), seed_o80035)

func beehive_3_col(uv : Vector2) -> Color:
	return Patterns.beehive_3c(uv, Vector2(p_o80035_sx, p_o80035_sy), seed_o80035)

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

