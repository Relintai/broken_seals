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


#float dots(vec2 uv, float size, float density, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
#	uv /= size;
#	vec2 point_pos = floor(uv)+vec2(0.5);
#	float color = step(rand(seed2+point_pos), density);    
#	return color;
#}

static func dots(uv : Vector2, size : float, density : float, pseed : float) -> float:
	return 0.0

