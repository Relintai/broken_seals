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

var p_o49619_columns = 4.000000000;
var p_o49619_rows = 4.000000000;

func runecol(uv : Vector2) -> Color:
	var f : float =  Rune(Vector2(p_o49619_columns, p_o49619_rows)*((uv)));

	return Color(f, f, f, 1)


func ThickLine(uv : Vector2, posA : Vector2, posB : Vector2, radiusInv : float) -> float:
	var dir : Vector2 = posA - posB;
	var dirLen : float = dir.length()
	var dirN : Vector2 = dir.normalized()
	var dotTemp : float = clamp((uv - posB).dot(dirN), 0.0, dirLen);
	var proj : Vector2 = dotTemp * dirN + posB;
	var d1 : float = (uv - proj).length()
	var finalGray : float = clamp(1.0 - d1 * radiusInv, 0.0, 1.0);
	
	return finalGray;

# makes a rune in the 0..1 uv space. Seed is which rune to draw.
# passes back gray in x and derivates for lighting in yz
func Rune(uv : Vector2) -> float:
	var finalLine : float = 0.0;
	var pseed : Vector2 = Commons.floorv2(uv) - Vector2(0.41, 0.41);
	
	uv = Commons.fractv2(uv);
	
	for i in range(4):# (int i = 0; i < 4; i++):  #	// number of strokes
		var posA : Vector2 = Commons.rand2(Commons.floorv2(pseed + Vector2(0.5, 0.5)));
		var posB : Vector2 = Commons.rand2(Commons.floorv2(pseed + Vector2(1.5, 1.5)));
		pseed.x += 2.0;
		pseed.y += 2.0;
		
		# expand the range and mod it to get a nicely distributed random number - hopefully. :)
		
		posA = Commons.fractv2(posA * 128.0);
		posB = Commons.fractv2(posB * 128.0);
		
		# each rune touches the edge of its box on all 4 sides
		if (i == 0):
			posA.y = 0.0;
			
		if (i == 1):
			posA.x = 0.999;
			
		if (i == 2):
			posA.x = 0.0;
			
		if (i == 3):
			posA.y = 0.999;
		
		# snap the random line endpoints to a grid 2x3
		
		var snaps : Vector2 = Vector2(2.0, 3.0);
		
		posA = (Commons.floorv2(posA * snaps) + Vector2(0.5, 0.5)) / snaps; # + 0.5 to center it in a grid cell
		posB = (Commons.floorv2(posB * snaps) + Vector2(0.5, 0.5)) / snaps;
		
		#if (distance(posA, posB) < 0.0001) continue;	// eliminate dots.
		# Dots (degenerate lines) are not cross-GPU safe without adding 0.001 - divide by 0 error.
		
		finalLine = max(finalLine, ThickLine(uv, posA, posB + Vector2(0.001, 0.001), 20.0));
	
	return finalLine;

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

