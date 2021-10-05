tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

static func fbmval(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = fbmf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)

static func perlin(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = perlinf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func perlinabs(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = perlinf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellularf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular2(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular2f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular3(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular3f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular4(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular4f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular5(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular5f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular6(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular6f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)


#float $(name)_fbm(vec2 coord, vec2 size, int folds, int octaves, float persistence, float seed) {
#	float normalize_factor = 0.0;
#	float value = 0.0;
#	float scale = 1.0;
#
#	for (int i = 0; i < octaves; i++) {
#		float noise = fbm_$noise(coord*size, size, seed);
#
#		for (int f = 0; f < folds; ++f) {
#			noise = abs(2.0*noise-1.0);
#		}
#
#		value += noise * scale;
#		normalize_factor += scale;
#		size *= 2.0;
#		scale *= persistence;
#	}
#
#	return value / normalize_factor;
#}

static func fbmf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_value(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func perlinf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_perlin(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func perlinabsf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_perlinabs(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellularf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellular2f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular2(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;

static func cellular3f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular3(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellular4f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular4(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellular5f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular5(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellular6f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular6(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;


#float fbm_value(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float p00 = rand(mod(o, size));
#	float p01 = rand(mod(o + vec2(0.0, 1.0), size));
#	float p10 = rand(mod(o + vec2(1.0, 0.0), size));
#	float p11 = rand(mod(o + vec2(1.0, 1.0), size));
#	vec2 t = f * f * (3.0 - 2.0 * f);
#
#	return mix(mix(p00, p10, t.x), mix(p01, p11, t.x), t.y);
#}

static func fbm_value(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	var p00 : float = Commons.rand(Commons.modv2(o, size));
	var p01 : float = Commons.rand(Commons.modv2(o + Vector2(0.0, 1.0), size));
	var p10 : float = Commons.rand(Commons.modv2(o + Vector2(1.0, 0.0), size));
	var p11 : float = Commons.rand(Commons.modv2(o + Vector2(1.0, 1.0), size));
	
	var t : Vector2 = f * f * (Vector2(3, 3) - 2.0 * f);
	return lerp(lerp(p00, p10, t.x), lerp(p01, p11, t.x), t.y);


#float fbm_perlin(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#
#	float a00 = rand(mod(o, size)) * 6.28318530718;
#	float a01 = rand(mod(o + vec2(0.0, 1.0), size)) * 6.28318530718;
#	float a10 = rand(mod(o + vec2(1.0, 0.0), size)) * 6.28318530718;
#	float a11 = rand(mod(o + vec2(1.0, 1.0), size)) * 6.28318530718;
#
#	vec2 v00 = vec2(cos(a00), sin(a00));
#	vec2 v01 = vec2(cos(a01), sin(a01));
#	vec2 v10 = vec2(cos(a10), sin(a10));
#	vec2 v11 = vec2(cos(a11), sin(a11));
#
#	float p00 = dot(v00, f);
#	float p01 = dot(v01, f - vec2(0.0, 1.0));
#	float p10 = dot(v10, f - vec2(1.0, 0.0));
#	float p11 = dot(v11, f - vec2(1.0, 1.0));
#
#	vec2 t = f * f * (3.0 - 2.0 * f);
#
#	return 0.5 + mix(mix(p00, p10, t.x), mix(p01, p11, t.x), t.y);
#}

static func fbm_perlin(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	var a00 : float = Commons.rand(Commons.modv2(o, size)) * 6.28318530718;
	var a01 : float = Commons.rand(Commons.modv2(o + Vector2(0.0, 1.0), size)) * 6.28318530718;
	var a10 : float = Commons.rand(Commons.modv2(o + Vector2(1.0, 0.0), size)) * 6.28318530718;
	var a11 : float = Commons.rand(Commons.modv2(o + Vector2(1.0, 1.0), size)) * 6.28318530718;
	var v00 : Vector2 = Vector2(cos(a00), sin(a00));
	var v01 : Vector2 = Vector2(cos(a01), sin(a01));
	var v10 : Vector2 = Vector2(cos(a10), sin(a10));
	var v11 : Vector2 = Vector2(cos(a11), sin(a11));
	var p00 : float = v00.dot(f);
	var p01 : float = v01.dot(f - Vector2(0.0, 1.0));
	var p10 : float = v10.dot(f - Vector2(1.0, 0.0));
	var p11 : float = v11.dot(f - Vector2(1.0, 1.0));
	
	var t : Vector2 = f * f * (Vector2(3, 3) - 2.0 * f);
	
	return 0.5 + lerp(lerp(p00, p10, t.x), lerp(p01, p11, t.x), t.y);

#float fbm_perlinabs(vec2 coord, vec2 size, float seed) {
#	return abs(2.0*fbm_perlin(coord, size, seed)-1.0);
#}

static func fbm_perlinabs(coord : Vector2, size : Vector2, pseed : float) -> float:
	return abs(2.0*fbm_perlin(coord, size, pseed)-1.0)

#float fbm_cellular(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist = 2.0;
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
#			min_dist = min(min_dist, dist);
#		}
#	}
#	return min_dist;
#}

static func fbm_cellular(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			min_dist = min(min_dist, dist);

	return min_dist;

#float fbm_cellular2(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist1 = 2.0;
#	float min_dist2 = 2.0;
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
#
#			if (min_dist1 > dist) {
#				min_dist2 = min_dist1;
#				min_dist1 = dist;
#			} else if (min_dist2 > dist) {
#				min_dist2 = dist;
#			}
#		}
#	}
#
#	return min_dist2-min_dist1;
#}

static func fbm_cellular2(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			
			var dist : float = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;
	
	return min_dist2-min_dist1;

#float fbm_cellular3(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size))*0.5 + vec2(x, y);
#			float dist = abs((f - node).x) + abs((f - node).y);
#			min_dist = min(min_dist, dist);
#		}
#	}
#
#	return min_dist;
#}

static func fbm_cellular3(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size))*0.5 + Vector2(x, y);
			
			var dist : float = abs((f - node).x) + abs((f - node).y);
			
			min_dist = min(min_dist, dist);

	return min_dist;

#float fbm_cellular4(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist1 = 2.0;
#	float min_dist2 = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size))*0.5 + vec2(x, y);
#			float dist = abs((f - node).x) + abs((f - node).y);
#
#				if (min_dist1 > dist) {
#					min_dist2 = min_dist1;
#					min_dist1 = dist;
#				} else if (min_dist2 > dist) {
#					min_dist2 = dist;
#				}
#		}
#	}
#
#	return min_dist2-min_dist1;
#}

static func fbm_cellular4(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size))*0.5 + Vector2(x, y);
			
			var dist : float = abs((f - node).x) + abs((f - node).y);
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;

	return min_dist2 - min_dist1;

#float fbm_cellular5(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);float min_dist = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = max(abs((f - node).x), abs((f - node).y));
#			min_dist = min(min_dist, dist);
#		}
#	}
#
#	return min_dist;
#}

static func fbm_cellular5(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = max(abs((f - node).x), abs((f - node).y));
			min_dist = min(min_dist, dist);

	return min_dist;

#float fbm_cellular6(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist1 = 2.0;
#	float min_dist2 = 2.0;
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = max(abs((f - node).x), abs((f - node).y));
#
#			if (min_dist1 > dist) {
#				min_dist2 = min_dist1;
#				min_dist1 = dist;
#			} else if (min_dist2 > dist) {
#				min_dist2 = dist;
#			}
#		}
#	}
#
#	return min_dist2-min_dist1;
#}

static func fbm_cellular6(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = Commons.floorv2(coord) + Commons.rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = Commons.fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = Commons.rand2(Commons.modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = max(abs((f - node).x), abs((f - node).y));
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;

	return min_dist2 - min_dist1;
