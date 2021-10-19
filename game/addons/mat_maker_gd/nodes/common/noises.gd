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

#Output:
#Output (float) - Shows a greyscale value noise
#anisotropic($(uv), vec2($(scale_x), $(scale_y)), $(seed), $(smoothness), $(interpolation))

#Input:
#scale, Vector2, min: 1, 1, max: 32, 1024, step: 1, 1, default 4, 256
#smoothness, float, min: 0, max: 1, step: 0,01, default: 1
#Interpolation, float, min: 0, max: 1, step: 0,01, default: 1

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

static func anisotropicc(uv : Vector2, size : Vector2, pseed : float, smoothness : float, interpolation : float) -> Color:
	var v : float = anisotropic(uv, size, pseed, smoothness, interpolation)

	return Color(v, v, v, 1)

#float anisotropic(vec2 uv, vec2 size, float seed, float smoothness, float interpolation) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
#	vec2 xy = floor(uv*size);
#	vec2 offset = vec2(rand(seed2 + xy.y), 0.0);
#	vec2 xy_offset = floor(uv * size + offset );    
#
#	float f0 = rand(seed2+mod(xy_offset, size));    
#	float f1 = rand(seed2+mod(xy_offset+vec2(1.0, 0.0), size));
#	float mixer = clamp( (fract(uv.x*size.x+offset.x) -.5) / smoothness + 0.5, 0.0, 1.0 );    
#	float smooth_mix = smoothstep(0.0, 1.0, mixer);
#	float linear = mix(f0, f1, mixer);
#	float smoothed = mix(f0, f1, smooth_mix);
#
#	return mix(linear, smoothed, interpolation);
#}

static func anisotropic(uv : Vector2, size : Vector2, pseed : float, smoothness : float, interpolation : float) -> float:
	var seed2 : Vector2 = Commons.rand2(Vector2(pseed, 1.0 - pseed))
	
	var xy : Vector2 = Commons.floorv2(uv * size)
	var s2xy : Vector2 = seed2
	s2xy.x += xy.y
	s2xy.y += xy.y
	
	var offset : Vector2 =  Vector2(Commons.rand(s2xy), 0.0)
	var xy_offset : Vector2 = Commons.floorv2(uv * size + offset)

	var f0 : float = Commons.rand(seed2 + Commons.modv2(xy_offset, size));    
	var f1 : float = Commons.rand(seed2 + Commons.modv2(xy_offset + Vector2(1.0, 0.0), size))
	var mixer : float = clamp((Commons.fract(uv.x * size.x + offset.x) - 0.5) / smoothness + 0.5, 0.0, 1.0)    
	var smooth_mix : float = smoothstep(0.0, 1.0, mixer)
	var linear : float = lerp(f0, f1, mixer)
	var smoothed : float = lerp(f0, f1, smooth_mix)

	return lerp(linear, smoothed, interpolation)

#vec3 color_dots(vec2 uv, float size, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
#	uv /= size;
#	vec2 point_pos = floor(uv)+vec2(0.5);
#	return rand3(seed2+point_pos);
#}

static func color_dots(uv : Vector2, size : float, pseed : float) -> Vector3:
	var seed2 : Vector2 = Commons.rand2(Vector2(pseed, 1.0 - pseed))
	
	uv /= size
	
	var point_pos : Vector2 = Commons.floorv2(uv) + Vector2(0.5, 0.5)
	
	return Commons.rand3(seed2 + point_pos)

static func noise_color(uv : Vector2, size : float, pseed : float) -> Color:
	var v : Vector3 = color_dots(uv, 1.0 / size, pseed)

	return Color(v.x, v.y, v.z, 1)

