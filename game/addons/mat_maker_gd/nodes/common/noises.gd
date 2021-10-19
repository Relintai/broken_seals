tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#----------------------
#color_noise.mmg

#Outputs:

#Output - (rgb) - Shows the noise pattern
#color_dots($(uv), 1.0/$(size), $(seed))

#Inputs:
#size, float, default: 8, min: 2, max: 12, step: 1

#----------------------
#noise.mmg

#Outputs:

#float $(name)_f(vec2 uv) {
#	return dots(uv, 1.0/$(size), $(density), $(seed));
#}

#Output - (float) - Shows the noise pattern
#$(name)_f($(uv))

#Inputs:
#grid_size, float, default: 4, min: 2, max: 12, step: 1
#density, float, default: 0.5, min: 0, max: 1, step: 0.01

#----------------------
#noise_anisotropic.mmg
#Generates x-axis interpolated value noise

#		"outputs": [
#			{
#				"f": "anisotropic($(uv), vec2($(scale_x), $(scale_y)), $(seed), $(smoothness), $(interpolation))",
#				"longdesc": "Shows a greyscale value noise",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Scale X",
#				"longdesc": "The scale along the X axis",
#				"max": 32,
#				"min": 1,
#				"name": "scale_x",
#				"shortdesc": "Scale.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 256,
#				"label": "Scale Y",
#				"longdesc": "The scale along the Y axis",
#				"max": 1024,
#				"min": 1,
#				"name": "scale_y",
#				"shortdesc": "Scale.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Smoothness",
#				"longdesc": "Controls how much the noise is blurred along the x-axis",
#				"max": 1,
#				"min": 0,
#				"name": "smoothness",
#				"shortdesc": "Smoothness",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Interpolation",
#				"longdesc": "Controls the type of interpolation used for the smoothing. 0 is linear interpolation, 1 is smooth interpolation",
#				"max": 1,
#				"min": 0,
#				"name": "interpolation",
#				"shortdesc": "Interpolation",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#float dots(vec2 uv, float size, float density, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
#	uv /= size;
#	vec2 point_pos = floor(uv)+vec2(0.5);
#	float color = step(rand(seed2+point_pos), density);    
#	return color;
#}

static func dots(uv : Vector2, size : float, density : float, pseed : float) -> float:
	var seed2 : Vector2 = Commons.rand2(Vector2(pseed, 1.0 - pseed))
	uv /= size
	var point_pos : Vector2 = Commons.floorv2(uv) + Vector2(0.5, 0.5)
	var color : float = Commons.step(Commons.rand2(seed2 + point_pos).x, density);   
	return color

#float anisotropic(vec2 uv, vec2 size, float seed, float smoothness, float interpolation) {\n\
#	tvec2 seed2 = rand2(vec2(seed, 1.0-seed));\n\t\n\t
#	vec2 xy = floor(uv*size);\n\t
#	vec2 offset = vec2(rand(seed2 + xy.y), 0.0);\n\t
#	vec2 xy_offset = floor(uv * size + offset );\n    
#
#	float f0 = rand(seed2+mod(xy_offset, size));\n    
#	float f1 = rand(seed2+mod(xy_offset+vec2(1.0, 0.0), size));\n\t
#	float mixer = clamp( (fract(uv.x*size.x+offset.x) -.5) / smoothness + 0.5, 0.0, 1.0 );\n    
#	float smooth_mix = smoothstep(0.0, 1.0, mixer);\n\t
#	float linear = mix(f0, f1, mixer);\n\t
#	float smoothed = mix(f0, f1, smooth_mix);\n\t\n
#
#	return mix(linear, smoothed, interpolation);\n
#}
