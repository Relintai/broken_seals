tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#fbm2.mmg (and fbm.mmg)

#Output:
#$(name)_fbm($(uv), vec2($(scale_x), $(scale_y)), int($(folds)), int($(iterations)), $(persistence), float($(seed)))

#Instance:
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

#Inputs:
#noise, enum, default: 2, values: Value, Perlin, Simplex, Cellular, Cellular2, Cellular3, Cellular4, Cellular5, Cellular6
#scale, vector2, default: 4, min: 1, max: 32, step: 1
#folds, float, default: 0, min: 0, max: 5, step: 1
#iterations (octaves), float, default: 3, min: 1, max: 10, step: 1
#persistence, float, default: 0.5, min: 0, max: 1, step: 0.01

static func fbmval(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = fbmf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)

static func perlin(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = perlinf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func perlinabs(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = perlinf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func simplex(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = fbm_simplexf(uv, size, folds, octaves, persistence, pseed)

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

static func fbm_simplexf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_simplex(coord*size, size, pseed)
		
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
#
#	float p00 = rand(mod(o, size));
#	float p01 = rand(mod(o + vec2(0.0, 1.0), size));
#	float p10 = rand(mod(o + vec2(1.0, 0.0), size));
#	float p11 = rand(mod(o + vec2(1.0, 1.0), size));
#
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
#	tvec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
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

#vec2 rgrad2(vec2 p, float rot, float seed) {
#	float u = rand(p + vec2(seed, 1.0-seed));
#	u = fract(u) * 6.28318530718; // 2*pi
#	return vec2(cos(u), sin(u));
#}

static func rgrad2(p : Vector2, rot : float, pseed : float) -> Vector2:
	var u : float = Commons.rand(p + Vector2(pseed, 1.0-pseed));
	u = Commons.fract(u) * 6.28318530718; # 2*pi
	return Vector2(cos(u), sin(u))

#float fbm_simplex(vec2 coord, vec2 size, float seed) {
#	coord *= 2.0; // needed for it to tile
#	coord += rand2(vec2(seed, 1.0-seed)) + size;
#	size *= 2.0; // needed for it to tile
#	coord.y += 0.001;    
#
#	vec2 uv = vec2(coord.x + coord.y*0.5, coord.y);    
#	vec2 i0 = floor(uv);    vec2 f0 = fract(uv);    
#	vec2 i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);    
#	vec2 p0 = vec2(i0.x - i0.y * 0.5, i0.y);    
#	vec2 p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);    
#	vec2 p2 = vec2(p0.x + 0.5, p0.y + 1.0);    
#
#	i1 = i0 + i1;    
#
#	vec2 i2 = i0 + vec2(1.0, 1.0);    
#	vec2 d0 = coord - p0;
#	vec2 d1 = coord - p1;
#	vec2 d2 = coord - p2;
#
#	vec3 xw = mod(vec3(p0.x, p1.x, p2.x), size.x);    
#	vec3 yw = mod(vec3(p0.y, p1.y, p2.y), size.y);    
#
#	vec3 iuw = xw + 0.5 * yw;    
#	vec3 ivw = yw;    
#
#	vec2 g0 = rgrad2(vec2(iuw.x, ivw.x), 0.0, seed);    
#	vec2 g1 = rgrad2(vec2(iuw.y, ivw.y), 0.0, seed);    
#	vec2 g2 = rgrad2(vec2(iuw.z, ivw.z), 0.0, seed);    
#
#	vec3 w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));    
#	vec3 t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));    
#
#	t = max(t, vec3(0.0));
#	vec3 t2 = t * t;    
#	vec3 t4 = t2 * t2;    
#	float n = dot(t4, w);
#
#	return 0.5 + 5.5 * n;
#}

static func fbm_simplex(coord : Vector2, size : Vector2, pseed : float) -> float:
	coord *= 2.0; # needed for it to tile
	coord += Commons.rand2(Vector2(pseed, 1.0-pseed)) + size;
	size *= 2.0; # needed for it to tile
	coord.y += 0.001;    

	var uv : Vector2 = Vector2(coord.x + coord.y*0.5, coord.y);    
	var i0 : Vector2 = Commons.floorv2(uv);
	var f0 : Vector2 = Commons.fractv2(uv);    
	var i1 : Vector2
	
	if (f0.x > f0.y):
		i1 = Vector2(1.0, 0.0)
	else: 
		i1 = Vector2(0.0, 1.0);    
		
	var p0 : Vector2 = Vector2(i0.x - i0.y * 0.5, i0.y);    
	var p1 : Vector2 = Vector2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);    
	var p2 : Vector2 = Vector2(p0.x + 0.5, p0.y + 1.0);    

	i1 = i0 + i1;    

	var i2 : Vector2 = i0 + Vector2(1.0, 1.0);    
	var d0 : Vector2 = coord - p0;
	var d1 : Vector2 = coord - p1;
	var d2 : Vector2 = coord - p2;

	var xw : Vector3 = Commons.modv3(Vector3(p0.x, p1.x, p2.x), Vector3(size.x, size.x, size.x));    
	var yw : Vector3 = Commons.modv3(Vector3(p0.y, p1.y, p2.y), Vector3(size.y, size.y, size.y));    

	var iuw : Vector3 = xw + 0.5 * yw;    
	var ivw : Vector3 = yw;    

	var g0 : Vector2 = rgrad2(Vector2(iuw.x, ivw.x), 0.0, pseed);    
	var g1 : Vector2 = rgrad2(Vector2(iuw.y, ivw.y), 0.0, pseed);    
	var g2 : Vector2 = rgrad2(Vector2(iuw.z, ivw.z), 0.0, pseed);    

	var w : Vector3 = Vector3(g0.dot(d0), g1.dot(d1), g2.dot(d2));    
	var t : Vector3 = Vector3(0.8, 0.8, 0.8) - Vector3(d0.dot(d0), d1.dot(d1), d2.dot(d2));    

	t = Commons.maxv3(t, Vector3());
	var t2 : Vector3 = t * t;    
	var t4 : Vector3 = t2 * t2;    
	var n : float = t4.dot(w);

	return 0.5 + 5.5 * n;
	
#float fbm_cellular(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
#			min_dist = min(min_dist, dist);
#		}
#	}
#
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
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
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
#	vec2 f = fract(coord);
#	float min_dist = 2.0;
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
#
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
