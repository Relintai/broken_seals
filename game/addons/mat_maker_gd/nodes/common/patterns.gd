tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#----------------------
#beehive.mmg
#Outputs: (beehive_1c, beehive_2c, beehive_3c  TODO make common code parameters)
#Common
#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);

#Output (float) - Shows the greyscale pattern
#1.0-2.0*beehive_dist($(name_uv)_center.xy)

#Random color (rgb) - Shows a random color for each hexagonal tile
#rand3(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed)))

#UV map (rgb) - Shows an UV map to be connected to the UV map port of the Custom UV node
#vec3(vec2(0.5)+$(name_uv)_center.xy, rand(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed))))

#Inputs:
#size, vector2, default: 2, min: 1, max: 64, step: 1

#----------------------
#pattern.mmg
#Outputs: $(name)_fct($(uv))

#Combiner, enum, default: 0, values (CombinerType): Multiply, Add, Max, Min, Xor, Pow
#Pattern_x_type, enum, default: 5, values (CombinerAxisType): Sine, Triangle, Square, Sawtooth, Constant, Bounce
#Pattern_y_type, enum, default: 5, values (CombinerAxisType): Sine, Triangle, Square, Sawtooth, Constant, Bounce
#Pattern_Repeat, vector2, min: 0, max: 32, default:4, step: 1

#----------------------
#bricks.mmg

#Outputs:

#Common
#vec4 $(name_uv)_rect = bricks_$pattern($uv, vec2($columns, $rows), $repeat, $row_offset);
#vec4 $(name_uv) = brick($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $round*$round_map($uv), max(0.001, $bevel*$bevel_map($uv)));

#Bricks pattern (float) - A greyscale image that shows the bricks pattern
#$(name_uv).x

#Random color (rgb) - A random color for each brick
#brick_random_color($(name_uv)_rect.xy, $(name_uv)_rect.zw, float($seed))

#Position.x (float) - The position of each brick along the X axis",
#$(name_uv).y

#Position.y (float) - The position of each brick along the Y axis
#$(name_uv).z

#Brick UV (rgb) - An UV map output for each brick, to be connected to the Map input of a CustomUV node
#brick_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, float($seed))

#Corner UV (rgb) - An UV map output for each brick corner, to be connected to the Map input of a CustomUV node
#brick_corner_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $corner, float($seed))

#Direction (float) - The direction of each brick (white: horizontal, black: vertical)
#0.5*(sign($(name_uv)_rect.z-$(name_uv)_rect.x-$(name_uv)_rect.w+$(name_uv)_rect.y)+1.0)

#Inputs:
#type / Pattern, enum, default: 0, values: Running Bond,Running Bond (2),HerringBone,Basket Weave,Spanish Bond
#repeat, int, min: 1, max: 8, default: 1, step:1
#rows, int, min: 1, max: 64, default: 6, step:1
#columns, int, min: 1, max: 64, default: 6, step:1
#offset, float, min: 0, max: 1, default: 0.5, step:0.01
#mortar, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#bevel, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#round, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#corner, float, min: 0, max: 0.5, default: 0.1, step:0.01

#----------------------
#bricks_uneven.mmg

#Outputs:

#Common
#vec4 $(name_uv)_rect = bricks_uneven($uv, int($iterations), $min_size, $randomness, float($seed));
#vec4 $(name_uv) = brick2($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $round*$round_map($uv), max(0.00001, $bevel*$bevel_map($uv)));

#Bricks pattern (float) - A greyscale image that shows the bricks pattern
#$(name_uv).x

#Random color (rgb) - A random color for each brick
#rand3(fract($(name_uv)_rect.xy)+rand2(vec2(float($seed))))

#Position.x (float) - The position of each brick along the X axis",
#$(name_uv).y

#Position.y (float) - The position of each brick along the Y axis
#$(name_uv).z

#Brick UV (rgb) - An UV map output for each brick, to be connected to the Map input of a CustomUV node
#brick_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, float($seed))

#Corner UV (rgb) - An UV map output for each brick corner, to be connected to the Map input of a CustomUV node
#brick_corner_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $corner, float($seed))

#Direction (float) - The direction of each brick (white: horizontal, black: vertical)
#0.5*(sign($(name_uv)_rect.z-$(name_uv)_rect.x-$(name_uv)_rect.w+$(name_uv)_rect.y)+1.0)

#Inputs:
#iterations, int, min: 1, max: 16, default:8, step:1
#min_size, float, min: 0, max: 0.5, default: 0.3, step:0.01
#randomness, float, min: 0, max: 1, default: 0.5, step:0.01
#mortar, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#bevel, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#round, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#corner, float, min: 0, max: 0.5, default: 0.1, step:0.01

#----------------------
#runes.mmg (includes sdline.mmg)
#Generates a grid filled with random runes

#Outputs:

#Output (float) - A greyscale image showing random runes.
#Rune(vec2($columns, $rows)*$uv, float($seed))

#Inputs:
#size, vector2, default: 4, min: 2, max: 32, step: 1

#----------------------
#scratches.mmg
#Draws white scratches on a black background

#Outputs:

#Output (float) - Shows white scratches on a black background
#scratches($uv, int($layers), vec2($length, $width), $waviness, $angle, $randomness, vec2(float($seed), 0.0))

#Inputs:

#scratch_size (l, w), vector2, min: 0.1, max: 1, default: (0.25, 0.5), step:0.01
#layers, float, min: 1, max: 10, default: 4, step:1
#waviness, float, min: 0, max: 1, default: 0.5, step:0.01
#angle, float, min: -180, max: 180, default: 0, step:1
#randomness, float, min: 0, max: 1, default: 0.5, step:0.01

#----------------------
#iching.mmg
#This node generates a grid of random I Ching hexagrams.

#Outputs:

#Output (float) - A greyscale image showing random I Ching hexagrams.
#IChing(vec2($columns, $rows)*$uv, float($seed))

#Inputs:
#size, vector2, default: 2, min: 2, max: 32, step: 1

#----------------------
#weave.mmg

#Outputs:

#Output (float) - Shows the generated greyscale weave pattern.
#weave($uv, vec2($columns, $rows), $width*$width_map($uv))

#Inputs:
#size, vector2, default: 4, min: 2, max: 32, step: 1
#width, float, min: 0, max: 1, default: 0.8, step:0.05 (universal input)

#----------------------
#weave2.mmg

#code
#vec3 $(name_uv) = weave2($uv, vec2($columns, $rows), $stitch, $width_x*$width_map($uv), $width_y*$width_map($uv));

#Outputs:

#Output (float) - Shows the generated greyscale weave pattern.
#$(name_uv).x

#Horizontal mask (float) - Horizontal mask
#$(name_uv).y

#Vertical mask (float) - Mask for vertical stripes
#$(name_uv).z

#Inputs:
#size, vector2, default: 4, min: 2, max: 32, step: 1
#width, vector2, default: 0.8, min: 0, max: 1, step: 0.05
#stitch, float, min: 0, max: 10, default: 1, step:1
#width_map, float, default: 1, (does not need input val (label)) (universal input)

#----------------------
#truchet.mmg

#Outputs:

#line: $shape = 1
#circle: $shape = 2

#Output (float) - Shows a greyscale image of the truchet pattern.
#truchet$shape($uv*$size, vec2(float($seed)))

#Inputs:
#shape, enum, default: 0, values: line, circle
#size, float, default: 4, min: 2, max: 64, step: 1

#----------------------
#truchet_generic.mmg

#Outputs:

#Output (color)
#$in(truchet_generic_uv($uv*$size, vec2(float($seed))))

#Inputs:
#in, color, default: color(1.0)
#size, float, default: 4, min: 2, max: 64, step: 1

#----------------------
#arc_pavement.mmg
#Draws a white shape on a black background

#		"code": "vec2 $(name_uv)_uv = fract($uv)*vec2($repeat, -1.0);\nvec2 $(name_uv)_seed;\nvec4 $(name_uv)_ap = arc_pavement($(name_uv)_uv, $rows, $bricks, $(name_uv)_seed);\n",
#		"outputs": [
#			{
#				"f": "pavement($(name_uv)_ap.zw, $bevel, 2.0*$mortar)",
#				"longdesc": "A greyscale image that shows the bricks pattern",
#				"shortdesc": "Bricks pattern",
#				"type": "f"
#			},
#			{
#				"longdesc": "A random color for each brick",
#				"rgb": "rand3($(name_uv)_seed)",
#				"shortdesc": "Random color",
#				"type": "rgb"
#			},
#			{
#				"longdesc": "An UV map output for each brick, to be connected to the Map input of a CustomUV node",
#				"rgb": "vec3($(name_uv)_ap.zw, 0.0)",
#				"shortdesc": "Brick UV",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 2,
#				"label": "Repeat:",
#				"longdesc": "The number of repetitions of the whole pattern",
#				"max": 4,
#				"min": 1,
#				"name": "repeat",
#				"shortdesc": "Repeat",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 8,
#				"label": "Rows:",
#				"longdesc": "The number of rows",
#				"max": 16,
#				"min": 4,
#				"name": "rows",
#				"shortdesc": "Rows",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 8,
#				"label": "Bricks:",
#				"longdesc": "The number of bricks per row",
#				"max": 16,
#				"min": 4,
#				"name": "bricks",
#				"shortdesc": "Bricks",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Mortar:",
#				"longdesc": "The width of the space between bricks",
#				"max": 0.5,
#				"min": 0,
#				"name": "mortar",
#				"shortdesc": "Mortar",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Bevel:",
#				"longdesc": "The width of the edge of each brick",
#				"max": 0.5,
#				"min": 0,
#				"name": "bevel",
#				"shortdesc": "Bevel",
#				"step": 0.01,
#				"type": "float"
#			}
#		]

#----------------------
#sine_wave.mmg
#Draws a greyscale sine wave pattern

#Outputs:
#Output, float, Shows a greyscale image of a sine wave
#1.0-abs(2.0*($uv.y-0.5)-$amplitude*sin(($frequency*$uv.x+$phase)*6.28318530718))

#Inputs:
#amplitude, float, min: 0, max: 1, step: 0.01, default: 0.5
#frequency, float, min: 0, max: 16, default: 1
#phase, float, min: 0, max: 1, step: 0.01, default: 0.5

enum CombinerAxisType {
	SINE,
	TRIANGLE,
	SQUARE,
	SAWTOOTH,
	CONSTANT,
	BOUNCE
}

enum CombinerType {
	MULTIPLY,
	ADD,
	MAX,
	MIN,
	XOR,
	POW
}

#"Sine,Triangle,Square,Sawtooth,Constant,Bounce"
#"Multiply,Add,Max,Min,Xor,Pow"

#float $(name)_fct(vec2 uv) {
#	return mix_$(mix)(wave_$(x_wave)($(x_scale)*uv.x), wave_$(y_wave)($(y_scale)*uv.y));
#}

static func pattern(uv : Vector2, x_scale : float, y_scale : float, ct : int, catx : int, caty : int) -> float:
	var x : float = 0
	var y : float = 0
	
	if catx == CombinerAxisType.SINE:
		x = Commons.wave_sine(x_scale * uv.x)
	elif catx == CombinerAxisType.TRIANGLE:
		x = Commons.wave_triangle(x_scale * uv.x)
	elif catx == CombinerAxisType.SQUARE:
		x = Commons.wave_square(x_scale * uv.x)
	elif catx == CombinerAxisType.SAWTOOTH:
		x = Commons.wave_sawtooth(x_scale * uv.x)
	elif catx == CombinerAxisType.CONSTANT:
		x = Commons.wave_constant(x_scale * uv.x)
	elif catx == CombinerAxisType.BOUNCE:
		x = Commons.wave_bounce(x_scale * uv.x)
		
	if caty == CombinerAxisType.SINE:
		y = Commons.wave_sine(y_scale * uv.y)
	elif caty == CombinerAxisType.TRIANGLE:
		y = Commons.wave_triangle(y_scale * uv.y)
	elif caty == CombinerAxisType.SQUARE:
		y = Commons.wave_square(y_scale * uv.y)
	elif caty == CombinerAxisType.SAWTOOTH:
		y = Commons.wave_sawtooth(y_scale * uv.y)
	elif caty == CombinerAxisType.CONSTANT:
		y = Commons.wave_constant(y_scale * uv.y)
	elif caty == CombinerAxisType.BOUNCE:
		y = Commons.wave_bounce(y_scale * uv.y)
	
	if ct == CombinerType.MULTIPLY:
		return Commons.mix_mul(x, y)
	elif ct == CombinerType.ADD:
		return Commons.mix_add(x, y);
	elif ct == CombinerType.MAX:
		return Commons.mix_max(x, y);
	elif ct == CombinerType.MIN:
		return Commons.mix_min(x, y);
	elif ct == CombinerType.XOR:
		return Commons.mix_xor(x, y);
	elif ct == CombinerType.POW:
		return Commons.mix_pow(x, y);
		
	return 0.0
	

#"Line,Circle"

static func truchet1c(uv : Vector2, size : float, pseed : float) -> Color:
	var f : float = truchet1(uv * size, Vector2(pseed, pseed))
	return Color(f, f, f, 1);

#float truchet1(vec2 uv, vec2 seed) {
#	vec2 i = floor(uv);
#	vec2 f = fract(uv)-vec2(0.5);
#
#	return 1.0-abs(abs((2.0*step(rand(i+seed), 0.5)-1.0)*f.x+f.y)-0.5);
#}

static func truchet1(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = Commons.floorv2(uv);
	var f : Vector2 = Commons.fractv2(uv) - Vector2(0.5, 0.5);
	
	return 1.0 - abs(abs((2.0 * Commons.step(Commons.rand(i + pseed), 0.5) - 1.0) * f.x + f.y) - 0.5);

static func truchet2c(uv : Vector2, size : float, pseed : float) -> Color:
	var f : float = truchet2(uv * size, Vector2(pseed, pseed))
	return Color(f, f, f, 1);

#float truchet2(vec2 uv, vec2 seed) {
#	vec2 i = floor(uv);
#	vec2 f = fract(uv);
#	float random = step(rand(i+seed), 0.5);
#
#	f.x *= 2.0*random-1.0;
#	f.x += 1.0-random;
#
#	return 1.0-min(abs(length(f)-0.5), abs(length(1.0-f)-0.5));
#}

static func truchet2(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = Commons.floorv2(uv);
	var f : Vector2 = Commons.fractv2(uv);
	var random : float = Commons.step(Commons.rand(i + pseed), 0.5);
	
	f.x *= 2.0 * random - 1.0;
	f.x += 1.0 - random;
	
	return 1.0 - min(abs(f.length() - 0.5), abs((Vector2(1, 1) - f).length() - 0.5));

static func weavec(uv : Vector2, count : Vector2, width : float) -> Color:
	var f : float = weave(uv, count, width);

	return Color(f, f, f, 1)

#float weave(vec2 uv, vec2 count, float width) {    
#	uv *= count;
#	float c = (sin(3.1415926*(uv.x+floor(uv.y)))*0.5+0.5)*step(abs(fract(uv.y)-0.5), width*0.5);
#	c = max(c, (sin(3.1415926*(1.0+uv.y+floor(uv.x)))*0.5+0.5)*step(abs(fract(uv.x)-0.5), width*0.5));
#	return c;
#}

static func weave(uv : Vector2, count : Vector2, width : float) -> float:
	uv *= count;
	var c : float = (sin(3.1415926* (uv.x + floor(uv.y)))*0.5+0.5)*Commons.step(abs(Commons.fract(uv.y)-0.5), width*0.5);
	c = max(c, (sin(3.1415926*(1.0+uv.y+floor(uv.x)))*0.5+0.5)*Commons.step(abs(Commons.fract(uv.x)-0.5), width*0.5));
	return c;
	
#vec3 weave2(vec2 uv, vec2 count, float stitch, float width_x, float width_y) {    
#	uv *= stitch;
#	uv *= count;
#	float c1 = (sin(3.1415926 / stitch * (uv.x + floor(uv.y) - (stitch - 1.0))) * 0.25 + 0.75 ) *step(abs(fract(uv.y)-0.5), width_x*0.5);
#	float c2 = (sin(3.1415926 / stitch * (1.0+uv.y+floor(uv.x) ))* 0.25 + 0.75 )*step(abs(fract(uv.x)-0.5), width_y*0.5);
#	return vec3(max(c1, c2), 1.0-step(c1, c2), 1.0-step(c2, c1));
#}

static func weave2(uv : Vector2, count : Vector2, stitch : float, width_x : float, width_y : float) -> Vector3:
	uv.x *= stitch
	uv.y *= stitch
	uv *= count
	
	var c1 : float = (sin(3.1415926 / stitch * (uv.x + floor(uv.y) - (stitch - 1.0))) * 0.25 + 0.75 ) * Commons.step(abs(Commons.fract(uv.y) - 0.5), width_x * 0.5);
	var c2 : float = (sin(3.1415926 / stitch * (1.0 + uv.y + floor(uv.x) ))* 0.25 + 0.75 ) * Commons.step(abs(Commons.fract(uv.x)-0.5), width_y * 0.5);
	
	return Vector3(max(c1, c2), 1.0 - Commons.step(c1, c2), 1.0 - Commons.step(c2, c1));

static func sinewavec(uv : Vector2, amplitude : float, frequency : float, phase : float) -> Color:
	var f : float = 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
	return Color(f, f, f, 1)
	
static func sinewavef(uv : Vector2, amplitude : float, frequency : float, phase : float) -> float:
	return 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
#float scratch(vec2 uv, vec2 size, float waviness, float angle, float randomness, vec2 seed) {
#	float subdivide = floor(1.0/size.x);
#	float cut = size.x*subdivide;
#
#	uv *= subdivide;
#
#	vec2 r1 = rand2(floor(uv)+seed);
#	vec2 r2 = rand2(r1);
#
#	uv = fract(uv);
#	vec2 border = 10.0*min(fract(uv), 1.0-fract(uv));
#	uv = 2.0*uv-vec2(1.0);
#
#	float a = 6.28318530718*(angle+(r1.x-0.5)*randomness);
#	float c = cos(a);
#	float s = sin(a);
#
#	uv = vec2(c*uv.x+s*uv.y, s*uv.x-c*uv.y);
#	uv.y += 2.0*r1.y-1.0;
#	uv.y += 0.5*waviness*cos(2.0*uv.x+6.28318530718*r2.y);
#	uv.x /= cut;
#	uv.y /= subdivide*size.y;
#
#	return min(border.x, border.y)*(1.0-uv.x*uv.x)*max(0.0, 1.0-1000.0*uv.y*uv.y);
#}
	
static func scratch(uv : Vector2, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var subdivide : float = floor(1.0/size.x);
	var cut : float = size.x*subdivide;
	uv *= subdivide;
	var r1 : Vector2 = Commons.rand2(Commons.floorv2(uv) + pseed);
	var r2 : Vector2 = Commons.rand2(r1);
	uv = Commons.fractv2(uv);
	uv = 2.0 * uv - Vector2(1, 1);
	
	var a : float = 6.28*(angle+(r1.x-0.5)*randomness);
	var c : float = cos(a);
	var s : float = sin(a);
	
	uv = Vector2(c*uv.x+s*uv.y, s*uv.x-c*uv.y);
	uv.y += 2.0*r1.y-1.0;
	uv.y += 0.5*waviness*cos(2.0*uv.x+6.28*r2.y);
	uv.x /= cut;
	uv.y /= subdivide*size.y;
	
	return (1.0-uv.x*uv.x)*max(0.0, 1.0-1000.0*uv.y*uv.y);

#float scratches(vec2 uv, int layers, vec2 size, float waviness, float angle, float randomness, vec2 seed) {
#	float v = 0.0;
#
#	for (int i = 0; i < layers; ++i) {
#		seed = rand2(seed);
#		v = max(v, scratch(fract(uv+seed), size, waviness, angle/360.0, randomness, seed));
#	}
#
#	return v;
#}

static func scratches(uv : Vector2, layers : int, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var v : float = 0.0;
	
	for i in range(layers):# (int i = 0; i < layers; ++i) {
		pseed = Commons.rand2(pseed);
		v = max(v, scratch(Commons.fractv2(uv + pseed), size, waviness, angle/360.0, randomness, pseed));

	return v;

static func scratchesc(uv : Vector2, layers : int, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> Color:
	var f : float = scratches(uv, layers, size, waviness, angle, randomness, pseed)
	
	return Color(f, f, f, 1)

static func runesc(uv : Vector2, col_row : Vector2, pseed : float) -> Color:
	var f : float = rune(col_row * uv, pseed);

	return Color(f, f, f, 1)

static func runesf(uv : Vector2, col_row : Vector2, pseed : float) -> float:
	return rune(col_row * uv, pseed);

#sdline.mmg
#vec2 sdLine(vec2 p, vec2 a, vec2 b) {
#	vec2 pa = p-a, ba = b-a;
#	float h = clamp(dot(pa,ba)/dot(ba,ba), 0.0, 1.0);
#
#	return vec2(length(pa-ba*h), h);
#}

#float ThickLine(vec2 uv, vec2 posA, vec2 posB, float radiusInv){
#	return clamp(1.1-20.0*sdLine(uv, posA, posB).x, 0.0, 1.0);
#}

#// makes a rune in the 0..1 uv space. Seed is which rune to draw.
#// passes back gray in x and derivates for lighting in yz
#float Rune(vec2 uv, float s) {
#	float finalLine = 0.0;
#	vec2 seed = floor(uv)-rand2(vec2(s));
#	uv = fract(uv);
#
#	for (int i = 0; i < 4; i++)	// number of strokes
#	{
#		vec2 posA = rand2(floor(seed+0.5));
#		vec2 posB = rand2(floor(seed+1.5));
#		seed += 2.0;
#		// expand the range and mod it to get a nicely distributed random number - hopefully. :)
#		posA = fract(posA * 128.0);
#		posB = fract(posB * 128.0);
#		// each rune touches the edge of its box on all 4 sides
#
#		if (i == 0) posA.y = 0.0;
#		if (i == 1) posA.x = 0.999;
#		if (i == 2) posA.x = 0.0;
#		if (i == 3) posA.y = 0.999;
#
#		// snap the random line endpoints to a grid 2x3
#		vec2 snaps = vec2(2.0, 3.0);
#		posA = (floor(posA * snaps) + 0.5) / snaps; // + 0.5 to center it in a grid cell
#		posB = (floor(posB * snaps) + 0.5) / snaps;
#
#		//if (distance(posA, posB) < 0.0001) continue;
#		// eliminate dots.
#		// Dots (degenerate lines) are not cross-GPU safe without adding 0.001 - divide by 0 error.
#		finalLine = max(finalLine, ThickLine(uv, posA, posB + 0.001, 20.0));
#	}
#
#	return finalLine;
#}

# makes a rune in the 0..1 uv space. Seed is which rune to draw.
# passes back gray in x and derivates for lighting in yz
static func rune(uv : Vector2, pseed : float) -> float:
	var finalLine : float = 0.0;
	var sseed : Vector2 = Commons.floorv2(uv) - Vector2(pseed, pseed);
	
	uv = Commons.fractv2(uv);
	
	for i in range(4):# (int i = 0; i < 4; i++):  #	// number of strokes
		var posA : Vector2 = Commons.rand2(Commons.floorv2(sseed + Vector2(0.5, 0.5)));
		var posB : Vector2 = Commons.rand2(Commons.floorv2(sseed + Vector2(1.5, 1.5)));
		sseed.x += 2.0;
		sseed.y += 2.0;
		
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
		
		finalLine = max(finalLine, Commons.ThickLine(uv, posA, posB + Vector2(0.001, 0.001), 20.0));
	
	return finalLine;

static func IChingc(uv : Vector2, row_col : Vector2, pseed : int) -> Color:
	var f : float =  IChing(row_col * uv, float(pseed));

	return Color(f, f, f, 1)

#float IChing(vec2 uv, float seed) {
#	int value = int(32.0*rand(floor(uv)+vec2(seed)));
#	float base = step(0.5, fract(fract(uv.y)*6.5))*step(0.04, fract(uv.y+0.02))*step(0.2, fract(uv.x+0.1));
#	int bit = int(fract(uv.y)*6.5);
#
#	return base*step(0.1*step(float(bit & value), 0.5), fract(uv.x+0.55));
#}

static func IChing(uv : Vector2, pseed : float) -> float:
	var value : int = int(32.0 * Commons.rand(Commons.floorv2(uv) + Vector2(pseed, pseed)));
	var base : float = Commons.step(0.5, Commons.fract(Commons.fract(uv.y)*6.5))*Commons.step(0.04, Commons.fract(uv.y+0.02)) * Commons.step(0.2, Commons.fract(uv.x+0.1));
	var bit : int = int(Commons.fract(uv.y)*6.5);
	
	return base * Commons.step(0.1*Commons.step(float(bit & value), 0.5), Commons.fract(uv.x+0.55));

#Beehive output 1
#Shows the greyscale pattern
#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);
#1.0-2.0*beehive_dist($(name_uv)_center.xy) 

static func beehive_1c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	return Color(f, f, f, 1)

#Beehive output 2
#Shows a random color for each hexagonal tile
#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);
#rand3(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed)))

static func beehive_2c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	var v : Vector3 = Commons.rand3(Commons.fractv2(Vector2(center.b, center.a) / Vector2(size.x, size.y)) + Vector2(float(pseed),float(pseed)));
	
	return Color(v.x, v.y, v.z, 1)

#Beehive output 3
#Shows an UV map to be connected to the UV map port of the Custom UV node
#vec3(vec2(0.5)+$(name_uv)_center.xy, rand(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed)))) 
#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);

static func beehive_3c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	#var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	var v1 : Vector2 = Vector2(0.5, 0.5) + Vector2(center.r, center.g)
	var ff : float = Commons.rand(Commons.fractv2(Vector2(center.b, center.a) / Vector2(size.x, size.y)) + Vector2(float(pseed), float(pseed)))
	
	var c : Color = Color(v1.x, v1.y, ff, ff);
	
	return c

#float beehive_dist(vec2 p){
#	ec2 s = vec2(1.0, 1.73205080757);    
#	p = abs(p);    
#	return max(dot(p, s*.5), p.x);
#}

static func beehive_dist(p : Vector2) -> float:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	p = Commons.absv2(p);
	
	return max(p.dot(s*.5), p.x);

#vec4 beehive_center(vec2 p) {
#	vec2 s = vec2(1.0, 1.73205080757);    
#	vec4 hC = floor(vec4(p, p - vec2(.5, 1)) / vec4(s,s)) + .5;    
#	vec4 h = vec4(p - hC.xy*s, p - (hC.zw + .5)*s);  
#	return dot(h.xy, h.xy)<dot(h.zw, h.zw) ? vec4(h.xy, hC.xy) : vec4(h.zw, hC.zw + 9.73);
#}

static func beehive_center(p : Vector2) -> Color:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	var hC : Color = Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y);
	
	hC = Commons.floorc(Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y)) + Color(0.5, 0.5, 0.5, 0.5);
	
	var v1 : Vector2 = Vector2(p.x - hC.r * s.x, p.y - hC.g * s.y)
	var v2 : Vector2 = Vector2(p.x - (hC.b + 0.5) * s.x, p.y - (hC.a + 0.5) * s.y)
	
	var h : Color = Color(v1.x, v1.y, v2.x, v2.y);
	
	if Vector2(h.r, h.g).dot(Vector2(h.r, h.g)) < Vector2(h.b, h.a).dot(Vector2(h.b, h.a)):
		return Color(h.r, h.g, hC.r, hC.g) 
	else:
		return Color(h.b, h.a, hC.b + 9.73, hC.a + 9.73)
	
	#return dot(h.xy, h.xy) < dot(h.zw, h.zw) ? Color(h.xy, hC.xy) : Color(h.zw, hC.zw + 9.73);

#vec3 brick_corner_uv(vec2 uv, vec2 bmin, vec2 bmax, float mortar, float corner, float seed) {
#	vec2 center = 0.5*(bmin + bmax);
#	vec2 size = bmax - bmin;
#
#	float max_size = max(size.x, size.y);
#	float min_size = min(size.x, size.y);
#
#	mortar *= min_size;
#	corner *= min_size;
#
#	return vec3(clamp((0.5*size-vec2(mortar)-abs(uv-center))/corner, vec2(0.0), vec2(1.0)), rand(fract(center)+vec2(seed)+ceil(vec2(uv-center))));
#}

static func brick_corner_uv(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, corner : float, pseed : float) -> Vector3:
	var center : Vector2 = 0.5 * (bmin + bmax)
	var size : Vector2 = bmax - bmin
	var max_size : float = max(size.x, size.y)
	var min_size : float = min(size.x, size.y)
	mortar *= min_size
	corner *= min_size
	
	var r : Vector3 = Vector3()
	
	r.x = clamp(((0.5 * size.x - mortar) - abs(uv.x - center.x)) / corner, 0, 1)
	r.y = clamp(((0.5 * size.y - mortar) - abs(uv.y - center.y)) / corner, 0, 1)
	r.z = Commons.rand(Commons.fractv2(center) + Vector2(pseed, pseed))

	return r
	
#	return vec3(clamp((0.5*size-vec2(mortar)-abs(uv-center))/corner, vec2(0.0), vec2(1.0)), rand(fract(center)+vec2(seed)));

#vec4 brick(vec2 uv, vec2 bmin, vec2 bmax, float mortar, float round, float bevel) {
#	float color;
#	vec2 size = bmax - bmin;
#	float min_size = min(size.x, size.y);
#
#	mortar *= min_size;
#	bevel *= min_size;
#	round *= min_size;
#	vec2 center = 0.5*(bmin+bmax);    
#	vec2 d = abs(uv-center)-0.5*(size)+vec2(round+mortar);    
#
#	color = length(max(d,vec2(0))) + min(max(d.x,d.y),0.0)-round;
#	color = clamp(-color/bevel, 0.0, 1.0);
#	vec2 tiled_brick_pos = mod(bmin, vec2(1.0, 1.0));
#
#	return vec4(color, center, tiled_brick_pos.x+7.0*tiled_brick_pos.y);
#}

static func brick(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, pround : float, bevel : float) -> Color:
	var color : float
	var size : Vector2 = bmax - bmin

	var min_size : float = min(size.x, size.y)
	mortar *= min_size
	bevel *= min_size
	pround *= min_size

	var center : Vector2 = 0.5 * (bmin + bmax)
	var d : Vector2 = Vector2()
	
	d.x = abs(uv.x - center.x) - 0.5 * (size.x) + (pround + mortar)
	d.y = abs(uv.y - center.y) - 0.5 * (size.y) + (pround + mortar)
	
	color = Vector2(max(d.x, 0), max(d.y, 0)).length() + min(max(d.x, d.y), 0.0) - pround
	
	color = clamp(-color / bevel, 0.0, 1.0)

#	var tiled_brick_pos : Vector2 = Vector2(bmin.x - 1.0 * floor(bmin.x / 1.0), bmin.y - 1.0 * floor(bmin.y / 1.0))

	var tiled_brick_pos_x : float = bmin.x - 1.0 * floor(bmin.x / 1.0)
	var tiled_brick_pos_y : float = bmin.y - 1.0 * floor(bmin.y / 1.0)
	
	#vec2 tiled_brick_pos = mod(bmin, vec2(1.0, 1.0));
	
	return Color(color, center.x, center.y, tiled_brick_pos_x + 7.0 * tiled_brick_pos_y)

#vec3 brick_random_color(vec2 bmin, vec2 bmax, float seed) {
#	vec2 center = 0.5*(bmin + bmax);
#	return rand3(fract(center + vec2(seed)));
#}

static func brick_random_color(bmin : Vector2, bmax : Vector2, pseed : float) -> Vector3:
	var center : Vector2 = (bmin + bmax)
	center.x *= 0.5
	center.y *= 0.5
	
	return Commons.rand3(Commons.fractv2(center + Vector2(pseed, pseed)));

#vec3 brick_uv(vec2 uv, vec2 bmin, vec2 bmax, float seed) {
#	vec2 center = 0.5*(bmin + bmax);
#	vec2 size = bmax - bmin;
#
#	float max_size = max(size.x, size.y);
#
#	return vec3(0.5+(uv-center)/max_size, rand(fract(center)+vec2(seed)));
#}

static func brick_uv(uv : Vector2, bmin : Vector2, bmax : Vector2, pseed : float) -> Vector3:
	var center : Vector2 = 0.5 * (bmin + bmax)
	var size : Vector2 = bmax - bmin
	var max_size : float = max(size.x, size.y)
	
	var x : float = 0.5+ (uv.x - center.x) / max_size
	var y : float = 0.5+ (uv.y - center.y) /max_size
	
	return Vector3(x, y, Commons.rand(Commons.fractv2(center) + Vector2(pseed, pseed)))

#vec4 bricks_rb(vec2 uv, vec2 count, float repeat, float offset) {
#	count *= repeat;float x_offset = offset*step(0.5, fract(uv.y*count.y*0.5));
#
#	vec2 bmin = floor(vec2(uv.x*count.x-x_offset, uv.y*count.y));
#
#	bmin.x += x_offset;
#	bmin /= count;
#
#	return vec4(bmin, bmin+vec2(1.0)/count);
#}

static func bricks_rb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat
	
	var x_offset : float = offset * Commons.step(0.5, Commons.fractf(uv.y * count.y * 0.5))
	
	var bmin : Vector2
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)
	
	bmin.x += x_offset;
	bmin /= count
	var bmc : Vector2 = bmin + Vector2(1.0, 1.0) /  count

	return Color(bmin.x, bmin.y, bmc.x, bmc.y)

#vec4 bricks_rb2(vec2 uv, vec2 count, float repeat, float offset) {
#	count *= repeat;
#
#	float x_offset = offset*step(0.5, fract(uv.y*count.y*0.5));
#	count.x = count.x*(1.0+step(0.5, fract(uv.y*count.y*0.5)));
#
#	vec2 bmin = floor(vec2(uv.x*count.x-x_offset, uv.y*count.y));
#
#	bmin.x += x_offset;
#	bmin /= count;
#
#	return vec4(bmin, bmin+vec2(1.0)/count);
#}

static func bricks_rb2(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat

	var x_offset : float = offset * Commons.step(0.5, Commons.fractf(uv.y * count.y * 0.5))
	count.x = count.x * (1.0+Commons.step(0.5, Commons.fractf(uv.y * count.y * 0.5)))
	var bmin : Vector2 = Vector2()
	
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)

	bmin.x += x_offset
	bmin /= count
	
	var b : Vector2 = bmin + Vector2(1, 1) / count
	
	return Color(bmin.x, bmin.y, b.x, b.y)

#vec4 bricks_hb(vec2 uv, vec2 count, float repeat, float offset) {
#	float pc = count.x+count.y;
#	float c = pc*repeat;
#	vec2 corner = floor(uv*c);
#	float cdiff = mod(corner.x-corner.y, pc);
#
#	if (cdiff < count.x) {
#		return vec4((corner-vec2(cdiff, 0.0))/c, (corner-vec2(cdiff, 0.0)+vec2(count.x, 1.0))/c);
#	} else {
#		return vec4((corner-vec2(0.0, pc-cdiff-1.0))/c, (corner-vec2(0.0, pc-cdiff-1.0)+vec2(1.0, count.y))/c);
#	}
#}

static func bricks_hb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var pc : float = count.x + count.y
	var c : float = pc * repeat
	
	var corner : Vector2 = Vector2(floor(uv.x * c), floor(uv.y * c))
	var cdiff : float = Commons.modf(corner.x - corner.y, pc)

	if (cdiff < count.x):
		var col : Color = Color()
		
		col.r = (corner.x - cdiff) / c
		col.g = corner.y / c
		
		col.b = (corner.x - cdiff + count.x) / c
		col.a = (corner.y + 1.0) / c
		
		return col
	else:
		var col : Color = Color()
		
		col.r = corner.x / c
		col.g = (corner.y - (pc - cdiff - 1.0)) / c
		
		col.b = (corner.x + 1.0) / c
		col.a = (corner.y - (pc - cdiff - 1.0) + count.y) / c
		
		return col

#vec4 bricks_bw(vec2 uv, vec2 count, float repeat, float offset) {
#	vec2 c = 2.0*count*repeat;
#	float mc = max(c.x, c.y);
#	vec2 corner1 = floor(uv*c);
#	vec2 corner2 = count*floor(repeat*2.0*uv);
#	float cdiff = mod(dot(floor(repeat*2.0*uv), vec2(1.0)), 2.0);
#	vec2 corner;
#	vec2 size;
#
#	if (cdiff == 0.0) {
#		orner = vec2(corner1.x, corner2.y);
#		size = vec2(1.0, count.y);
#	} else {
#		corner = vec2(corner2.x, corner1.y);
#		size = vec2(count.x, 1.0);
#	}
#
#	return vec4(corner/c, (corner+size)/c);
#}

static func bricks_bw(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var c : Vector2 = 2.0 * count * repeat
	var mc : float = max(c.x, c.y)
	var corner1 : Vector2 = Vector2(floor(uv.x * c.x), floor(uv.y * c.y))
	var corner2 : Vector2 = Vector2(count.x * floor(repeat* 2.0 * uv.x), count.y * floor(repeat * 2.0 * uv.y))
	
	var tmp : Vector2 = Vector2(floor(repeat * 2.0 * uv.x), floor(repeat * 2.0 * uv.y))
	var cdiff : float = Commons.modf(tmp.dot(Vector2(1, 1)), 2.0)
	
	var corner : Vector2
	var size : Vector2

	if cdiff == 0:
		corner = Vector2(corner1.x, corner2.y)
		size = Vector2(1.0, count.y)
	else:
		corner = Vector2(corner2.x, corner1.y)
		size = Vector2(count.x, 1.0)

	return Color(corner.x / c.x, corner.y / c.y, (corner.x + size.x) / c.x, (corner.y + size.y) / c.y)

#vec4 bricks_sb(vec2 uv, vec2 count, float repeat, float offset) {
#	vec2 c = (count+vec2(1.0))*repeat;
#	float mc = max(c.x, c.y);
#	vec2 corner1 = floor(uv*c);
#	vec2 corner2 = (count+vec2(1.0))*floor(repeat*uv);
#	vec2 rcorner = corner1 - corner2;
#	vec2 corner;
#	vec2 size;
#
#	if (rcorner.x == 0.0 && rcorner.y < count.y) {
#		corner = corner2;
#		size = vec2(1.0, count.y);
#	} else if (rcorner.y == 0.0) {
#		corner = corner2+vec2(1.0, 0.0);
#		size = vec2(count.x, 1.0);
#	} else if (rcorner.x == count.x) {
#		corner = corner2+vec2(count.x, 1.0);
#		size = vec2(1.0, count.y);
#	} else if (rcorner.y == count.y) {
#		corner = corner2+vec2(0.0, count.y);
#		size = vec2(count.x, 1.0);
#	} else {
#		corner = corner2+vec2(1.0);
#		size = vec2(count.x-1.0, count.y-1.0);
#	}
#
#	return vec4(corner/c, (corner+size)/c);
#}

static func bricks_sb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var c : Vector2 = (count + Vector2(1, 1)) * repeat
	var mc : float = max(c.x, c.y)
	var corner1 : Vector2 = Vector2(floor(uv.x * c.x), floor(uv.y * c.y))
	var corner2 : Vector2 = (count + Vector2(1, 1)) * Vector2(floor(repeat * uv.x), floor(repeat * uv.y))
	var rcorner : Vector2 = corner1 - corner2

	var corner : Vector2
	var size : Vector2

	if (rcorner.x == 0.0 && rcorner.y < count.y):
		corner = corner2
		size = Vector2(1.0, count.y)
	elif (rcorner.y == 0.0):
		corner = corner2 + Vector2(1.0, 0.0)
		size = Vector2(count.x, 1.0)
	elif (rcorner.x == count.x):
		corner = corner2 + Vector2(count.x, 1.0)
		size = Vector2(1.0, count.y)
	elif (rcorner.y == count.y):
		corner = corner2 + Vector2(0.0, count.y)
		size = Vector2(count.x, 1.0)
	else:
		corner = corner2 + Vector2(1, 1)
		size = Vector2(count.x-1.0, count.y-1.0)

	return Color(corner.x / c.x, corner.y / c.y, (corner.x + size.x) / c.x, (corner.y + size.y) / c.y)

#vec4 brick2(vec2 uv, vec2 bmin, vec2 bmax, float mortar, float round, float bevel) {
#	float color;
#	vec2 size = bmax - bmin;
#	vec2 center = 0.5*(bmin+bmax);    
#	vec2 d = abs(uv-center)-0.5*(size)+vec2(round+mortar);    
#
#	color = length(max(d,vec2(0))) + min(max(d.x,d.y),0.0)-round;
#	color = clamp(-color/bevel, 0.0, 1.0);
#
#	vec2 tiled_brick_pos = mod(bmin, vec2(1.0, 1.0));
#
#	return vec4(color, center, tiled_brick_pos.x+7.0*tiled_brick_pos.y);
#}

static func brick2(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, pround : float, bevel : float) -> Color:
	return Color()

#vec4 bricks_uneven(vec2 uv, int iterations, float min_size, float randomness, float seed) {
#	vec2 a = vec2(0.0);
#	vec2 b = vec2(1.0);
#	for (int i = 0; i < iterations; ++i) {
#		vec2 size = b-a;
#		if (max(size.x, size.y) < min_size) {
#			break;
#		}
#
#		float x = rand(rand2(vec2(rand(a+b), seed)))*randomness+(1.0-randomness)*0.5;
#
#		if (size.x > size.y) {
#			x *= size.x;
#
#			if (uv.x > a.x+x) {
#				a.x += x;
#			} else {
#				b.x = a.x + x;
#			}
#		} else {
#			x *= size.y;
#
#			if (uv.y > a.y+x) {
#				a.y += x;
#			} else {
#				b.y = a.y + x;
#			}
#		}
#	}
#
#	return vec4(a, b);
#}

static func bricks_uneven(uv : Vector2, iterations : int, min_size : float, randomness : float, pseed : float) -> Color:
	return Color()


#vec2 truchet_generic_uv(vec2 uv, vec2 seed) {
#	vec2 i = floor(uv);
#	vec2 f = fract(uv);
#	vec2 invert = step(rand2(seed+i), vec2(0.5));
#
#	return f*(vec2(1.0)-invert)+(vec2(1.0)-f)*invert;
#}

static func truchet_generic_uv(uv : Vector2, pseed : float) -> Vector2:
	return Vector2()


#float pavement(vec2 uv, float bevel, float mortar) {\n\t
#	uv = abs(uv-vec2(0.5));\n\t
#
#	return clamp((0.5*(1.0-mortar)-max(uv.x, uv.y))/max(0.0001, bevel), 0.0, 1.0);
#}

#vec4 arc_pavement(vec2 uv, float acount, float lcount, out vec2 seed) {\n\t
#	float PI = 3.141592654;\n\t
#	float radius = (0.5/sqrt(2.0));\n    
#	float uvx = uv.x;\n    
#	uv.x = 0.5*fract(uv.x+0.5)+0.25;\n    
#	float center = (uv.x-0.5)/radius;\n    
#	center *= center;\n    
#	center = floor(acount*(uv.y-radius*sqrt(1.0-center))+0.5)/acount;\n    
#
#	vec2 v = uv-vec2(0.5, center);\n    
#	float cornerangle = 0.85/acount+0.25*PI;\n    
#	float acountangle = (PI-2.0*cornerangle)/(lcount+floor(mod(center*acount, 2.0)));\n    
#	float angle = mod(atan(v.y, v.x), 2.0*PI);\n\t
#
#	float base_angle;\n\t
#	float local_uvy = 0.5+acount*(length(v)-radius)*(1.54-0.71*cos(1.44*(angle-PI*0.5)));\n\t
#	vec2 local_uv;\n    
#
#	if (angle < cornerangle) {\n        
#		base_angle = 0.25*PI;\n\t\t
#		local_uv = vec2((angle-0.25*PI)/cornerangle*0.38*acount+0.5, 1.0-local_uvy);\n\t\t
#		seed = vec2(fract(center), 0.0);\n    
#	} else if (angle > PI-cornerangle) {\n        
#		base_angle = 0.75*PI;\n\t\t
#		local_uv = vec2(local_uvy, 0.5-(0.75*PI-angle)/cornerangle*0.38*acount);\n\t\t
#		seed = vec2(fract(center), 0.0);\n    
#	} else {\n        
#		base_angle = cornerangle+(floor((angle-cornerangle)/acountangle)+0.5)*acountangle;\n\t\t
#		local_uv = vec2((angle-base_angle)/acountangle+0.5, 1.0-local_uvy);\n\t\t
#		seed = vec2(fract(center), base_angle);\n    
#	}\n    
#
#	vec2 brick_center = vec2(0.5, center)+radius*vec2(cos(base_angle), sin(base_angle));\n    
#
#	return vec4(brick_center.x+uvx-uv.x, brick_center.y, local_uv);\n
#}
