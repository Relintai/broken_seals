tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#adjust_hsv.mmg
#brightness_contrast.mmg
#greyscale.mmg

#main node methods: adjust_hsv, brightness_contrast

#vec3 rgb_to_hsv(vec3 c) {
#	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
#	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
#	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
#
#	float d = q.x - min(q.w, q.y);
#	float e = 1.0e-10;
#	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
#}

#----------------------
#colorize.mmg
#Remaps a greyscale image to a custom gradient

#		"inputs": [
#			{
#				"default": "$uv.x",
#				"label": "",
#				"longdesc": "The input greyscale image",
#				"name": "input",
#				"shortdesc": "Input",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The remapped RGBA image",
#				"rgba": "$gradient($input($uv))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"interpolation": 1,
#					"points": [
#						{
#							"a": 1,
#							"b": 0,
#							"g": 0,
#							"pos": 0,
#							"r": 0
#						},
#						{
#							"a": 1,
#							"b": 1,
#							"g": 1,
#							"pos": 1,
#							"r": 1
#						}
#					],
#					"type": "Gradient"
#				},
#				"label": "",
#				"longdesc": "The gradient to which the input is remapped",
#				"name": "gradient",
#				"shortdesc": "Gradient",
#				"type": "gradient"
#			}
#		],

#----------------------
#default_color.mmg

#		"inputs": [
#			{
#				"default": "$default",
#				"label": "",
#				"name": "in",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"rgba": "$in($uv)",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"a": 1,
#					"b": 1,
#					"g": 1,
#					"r": 1
#				},
#				"label": "",
#				"name": "default",
#				"type": "color"
#			}
#		]

#----------------------
#decompose.mmg
#Decomposes an RGBA input into 4 greyscale images

#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"label": "",
#				"longdesc": "The RGBA input image",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$i($uv).r",
#				"longdesc": "Shows the Red channel of the input",
#				"shortdesc": "Red",
#				"type": "f"
#			},
#			{
#				"f": "$i($uv).g",
#				"longdesc": "Shows the Green channel of the input",
#				"shortdesc": "Green",
#				"type": "f"
#			},
#			{
#				"f": "$i($uv).b",
#				"longdesc": "Shows the Blue channel of the input",
#				"shortdesc": "Blue",
#				"type": "f"
#			},
#			{
#				"f": "$i($uv).a",
#				"longdesc": "Shows the Alpha channel of the input",
#				"shortdesc": "Alpha",
#				"type": "f"
#			}
#		],

static func rgb_to_hsv(c : Vector3) -> Vector3:
	var K : Color = Color(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	
	var p : Color 
	
	if c.y < c.z:
		p = Color(c.z, c.y, K.a, K.b)
	else:
		p = Color(c.y, c.z, K.r, K.g);
	
	var q : Color
	
	if c.x < p.r:
		q = Color(p.r, p.g, p.a, c.x)
	else:
		q = Color(c.x, p.g, p.b, p.r);

	var d : float = q.r - min(q.a, q.g);
	var e : float = 1.0e-10;
	
	return Vector3(abs(q.b + (q.a - q.g) / (6.0 * d + e)), d / (q.r + e), q.r);

#vec3 hsv_to_rgb(vec3 c) {
#	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
#	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
#	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
#}

static func hsv_to_rgb(c : Vector3) -> Vector3:
	var K : Color = Color(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	
	var p : Vector3 = Commons.absv3(Commons.fractv3(Vector3(c.x, c.x, c.x) + Vector3(K.r, K.g, K.b)) * 6.0 - Vector3(K.a, K.a, K.a));
	
	return c.z * lerp(Vector3(K.r, K.r, K.r), Commons.clampv3(p - Vector3(K.r, K.r, K.r), Vector3(), Vector3(1, 1, 1)), c.y);

#adjust_hsv.mmg

#vec4 $(name_uv)_rbga = $in($(uv));
#vec3 $(name_uv)_hsv = rgb_to_hsv($(name_uv)_rbga.rgb);
#$(name_uv)_hsv.x += $(hue);
#$(name_uv)_hsv.y = clamp($(name_uv)_hsv.y*$(saturation), 0.0, 1.0);
#$(name_uv)_hsv.z = clamp($(name_uv)_hsv.z*$(value), 0.0, 1.0);

#hue, min: -0.5, max: 0.5, step: 0, default: 0
#saturation, min: 0, max: 2, step: 0, default: 1
#value, min: 0, max: 2, step: 0, default: 1

#output: vec4(hsv_to_rgb($(name_uv)_hsv), $(name_uv)_rbga.a)

static func adjust_hsv(color : Color, hue : float, saturation : float, value : float) -> Color:
	var hsv : Vector3 = rgb_to_hsv(Vector3(color.r, color.g, color.b));
	
	var x : float = Commons.fract(hsv.x + hue)
	var y : float = clamp(hsv.y * saturation, 0.0, 1.0)
	var z : float = clamp(hsv.z * value, 0.0, 1.0)
	
	var h : Vector3 = hsv_to_rgb(Vector3(x, y, z))

	return Color(h.x, h.y, h.z, color.a);

#brightness, min: -1, max: 1, step: 0.01, default: 0
#contrast, min: -1, max: 1, step: 0.01, default: 1

#input: default: vec4(0.5 ,0.5, 0.5, 1.0) -> img

#output: vec4(clamp($in($uv).rgb*$contrast+vec3($brightness)+0.5-$contrast*0.5, vec3(0.0), vec3(1.0)), $in($uv).a)

static func brightness_contrast(color : Color, brightness : float, contrast : float) -> Color:
	var bv : Vector3 = Vector3(brightness, brightness, brightness)
	var cvv : Vector3 = Vector3(color.r * contrast, color.g * contrast, color.b * contrast)
	
	var cv : Vector3 = cvv + bv + Vector3(0.5, 0.5, 0.5) - (Vector3(contrast, contrast, contrast) * 0.5)
	
	var v : Vector3 = Commons.clampv3(cv, Vector3(), Vector3(1, 1, 1))
	
	return Color(v.x, v.y, v.z, 1);

#greyscale

#input: default: vec3(0.0). (Image)
#output: gs_$mode($in($uv))
#mode: enum: Lightness, Average, Luminosity, Min, Max. default: 4

#float gs_min(vec3 c) {
#	return min(c.r, min(c.g, c.b));
#}

static func grayscale_min(c : Vector3) -> float:
	return min(c.x, min(c.y, c.z));

#float gs_max(vec3 c) {
#	return max(c.r, max(c.g, c.b));
#}

static func grayscale_max(c : Vector3) -> float:
	return max(c.x, max(c.y, c.z));

#float gs_lightness(vec3 c) {
#	return 0.5*(max(c.r, max(c.g, c.b)) + min(c.r, min(c.g, c.b)));
#}

static func grayscale_lightness(c : Vector3) -> float:
	return 0.5*(max(c.x, max(c.y, c.z)) + min(c.x, min(c.y, c.z)));

#float gs_average(vec3 c) {
#	return 0.333333333333*(c.r + c.g + c.b);
#}

static func grayscale_average(c : Vector3) -> float:
	return 0.333333333333*(c.x + c.y + c.z);

#float gs_luminosity(vec3 c) {
#	return 0.21 * c.r + 0.72 * c.g + 0.07 * c.b;
#}

static func grayscale_luminosity(c : Vector3) -> float:
	return 0.21 * c.x + 0.72 * c.y + 0.07 * c.z;

static func invert(color : Color) -> Color:
	return Color(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);
