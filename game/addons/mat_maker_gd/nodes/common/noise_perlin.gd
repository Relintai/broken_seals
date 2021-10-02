extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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

static func perlinc(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Color:
	var f : float = perlin(uv, size, iterations, persistence, pseed)
	
	return Color(f, f, f, 1)

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

