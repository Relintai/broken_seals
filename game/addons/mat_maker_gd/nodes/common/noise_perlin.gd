tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#----------------------
#perlin.mmg

#Outputs:

#Output - (float) - Shows a greyscale value noise
#perlin($(uv), vec2($(scale_x), $(scale_y)), int($(iterations)), $(persistence), $(seed))

#Inputs:
#scale, vector2, default: 4, min: 1, max: 32, step: 1
#iterations, float, min: 0, max: 10, default: 3, step:1
#persistence, float, min: 0, max: 1, default: 0.5, step:0.05

#----------------------
#perlin_color.mmg

#Outputs:

#Output - (rgb) - Shows a color value noise
#perlin_color($(uv), vec2($(scale_x), $(scale_y)), int($(iterations)), $(persistence), $(seed))

#Inputs:
#scale, vector2, default: 4, min: 1, max: 32, step: 1
#iterations, float, min: 0, max: 10, default: 3, step:1
#persistence, float, min: 0, max: 1, default: 0.5, step:0.05

static func perlinc(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Color:
	var f : float = perlin(uv, size, iterations, persistence, pseed)
	
	return Color(f, f, f, 1)


#float perlin(vec2 uv, vec2 size, int iterations, float persistence, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));    
#	float rv = 0.0;    
#	float coef = 1.0;    
#	float acc = 0.0;    
#
#	for (int i = 0; i < iterations; ++i) {    
#		vec2 step = vec2(1.0)/size;
#		vec2 xy = floor(uv*size);        
#
#		float f0 = rand(seed2+mod(xy, size));        
#		float f1 = rand(seed2+mod(xy+vec2(1.0, 0.0), size));        
#		float f2 = rand(seed2+mod(xy+vec2(0.0, 1.0), size));        
#		float f3 = rand(seed2+mod(xy+vec2(1.0, 1.0), size));        
#
#		vec2 mixval = smoothstep(0.0, 1.0, fract(uv*size));        
#		rv += coef * mix(mix(f0, f1, mixval.x), mix(f2, f3, mixval.x), mixval.y);        
#		acc += coef;
#		size *= 2.0;
#		coef *= persistence;    
#	}        
#
#	return rv / acc;
#}

static func perlin(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> float:
	var seed2 : Vector2 = Commons.rand2(Vector2(float(pseed), 1.0-float(pseed)));
	var rv : float = 0.0;
	var coef : float = 1.0;
	var acc : float = 0.0;
	
	for i in range(iterations):
		var step : Vector2 = Vector2(1, 1) / size;
		var xy : Vector2 = Commons.floorv2(uv * size);
		var f0 : float = Commons.rand(seed2 + Commons.modv2(xy, size));
		var f1 : float = Commons.rand(seed2 + Commons.modv2(xy + Vector2(1.0, 0.0), size));
		var f2 : float = Commons.rand(seed2 + Commons.modv2(xy + Vector2(0.0, 1.0), size));
		var f3 : float = Commons.rand(seed2 + Commons.modv2(xy + Vector2(1.0, 1.0), size));

		var mixval : Vector2 = Commons.smoothstepv2(0.0, 1.0, Commons.fractv2(uv * size));
		
		rv += coef * lerp(lerp(f0, f1, mixval.x), lerp(f2, f3, mixval.x), mixval.y);
		acc += coef;
		size *= 2.0;
		coef *= persistence;

	return rv / acc;

#vec3 perlin_color(vec2 uv, vec2 size, int iterations, float persistence, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));    
#	vec3 rv = vec3(0.0);    
#	float coef = 1.0;    
#	float acc = 0.0;    
#
#	for (int i = 0; i < iterations; ++i) {    
#		vec2 step = vec2(1.0)/size;
#		vec2 xy = floor(uv*size);        
#		vec3 f0 = rand3(seed2+mod(xy, size));        
#		vec3 f1 = rand3(seed2+mod(xy+vec2(1.0, 0.0), size));        
#		vec3 f2 = rand3(seed2+mod(xy+vec2(0.0, 1.0), size));        
#		vec3 f3 = rand3(seed2+mod(xy+vec2(1.0, 1.0), size));        
#		vec2 mixval = smoothstep(0.0, 1.0, fract(uv*size));        
#
#		rv += coef * mix(mix(f0, f1, mixval.x), mix(f2, f3, mixval.x), mixval.y);        
#		acc += coef;        
#		size *= 2.0;        
#		coef *= persistence;    
#	}        
#
#	return rv / acc;
#}

static func perlin_color(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Vector3:
	var seed2 : Vector2 = Commons.rand2(Vector2(float(pseed), 1.0-float(pseed)));
	var rv : Vector3 = Vector3();
	var coef : float = 1.0;
	var acc : float = 0.0;
	
	for i in range(iterations):
		var step : Vector2 = Vector2(1, 1) / size;
		var xy : Vector2 = Commons.floorv2(uv * size);
		var f0 : Vector3 = Commons.rand3(seed2 + Commons.modv2(xy, size));
		var f1 : Vector3 = Commons.rand3(seed2 + Commons.modv2(xy + Vector2(1.0, 0.0), size));
		var f2 : Vector3 = Commons.rand3(seed2 + Commons.modv2(xy + Vector2(0.0, 1.0), size));
		var f3 : Vector3 = Commons.rand3(seed2 + Commons.modv2(xy + Vector2(1.0, 1.0), size));

		var mixval : Vector2 = Commons.smoothstepv2(0.0, 1.0, Commons.fractv2(uv * size));
		
		rv += coef * lerp(lerp(f0, f1, mixval.x), lerp(f2, f3, mixval.x), mixval.y)
		acc += coef;
		size *= 2.0;
		coef *= persistence;

	return rv / acc;

static func perlin_colorc(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Color:
	var f : Vector3 = perlin_color(uv, size, iterations, persistence, pseed)
	
	return Color(f.x, f.y, f.z, 1)

static func perlin_warp_1(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int, translate : Vector2, rotate : float, size2 : Vector2) -> Color:
	var f : float = perlin(uv, size2, iterations, persistence, pseed)
	var vt : Vector2 = Commons.transform(uv, Vector2(translate.x*(2.0*f-1.0), translate.y*(2.0*f-1.0)), rotate*0.01745329251*(2.0*1.0-1.0), Vector2(size.x*(2.0*1.0-1.0), size.y*(2.0*1.0-1.0)), true)
	var ff : float = perlin(vt, size2, iterations, persistence, pseed)

	return Color(ff, ff, ff, 1)

static func perlin_warp_2(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int, translate : Vector2, rotate : float, size2 : Vector2) -> Color:
	var f = perlin(uv, size2, iterations, persistence, pseed)
	var vt : Vector2 = Commons.transform(uv, Vector2(translate.x*(2.0*f-1.0), translate.y*(2.0*f-1.0)), rotate*0.01745329251*(2.0*1.0-1.0), Vector2(size.x*(2.0*1.0-1.0), size.y*(2.0*1.0-1.0)), true)
	var ff : float = perlin(vt, size2, iterations, persistence, pseed)
	
	var rgba : Vector3 = Vector3(ff, ff, ff)
	
	var tf : Vector2 = Commons.transform(uv, Vector2(translate.x * (2.0 * (rgba.dot(Vector3(1, 1, 1) / 3.0) - 1.0)), translate.y*(2.0*(rgba.dot(Vector3(1, 1, 1) /3.0)-1.0))), rotate*0.01745329251*(2.0*1.0-1.0), Vector2(size.x*(2.0*1.0-1.0), size.y*(2.0*1.0-1.0)), true)

	var fff : float = perlin(tf, size2, iterations, persistence, pseed);

	return Color(fff, fff, fff, 1)

