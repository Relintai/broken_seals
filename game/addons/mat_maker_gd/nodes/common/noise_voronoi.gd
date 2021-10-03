tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

static func voronoi(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var seed2 : Vector2 = Commons.rand2(Vector2(float(pseed), 1.0-float(pseed)));
	uv *= size;
	var best_distance0 : float = 1.0;
	var best_distance1 : float = 1.0;
	var point0 : Vector2;
	var point1 : Vector2;
	var p0 : Vector2 = Commons.floorv2(uv);
	
	for dx in range(-1, 2):# (int dx = -1; dx < 2; ++dx) {
		for dy in range(-1, 2):# (int dy = -1; dy < 2; ++dy) {
			var d : Vector2 = Vector2(float(dx), float(dy));
			var p : Vector2 = p0+d;
			
			p += randomness * Commons.rand2(seed2 + Commons.modv2(p, size));
			var distance : float = (stretch * (uv - p) / size).length();
			
			if (best_distance0 > distance):
				best_distance1 = best_distance0;
				best_distance0 = distance;
				point1 = point0;
				point0 = p;
			elif (best_distance1 > distance):
				best_distance1 = distance;
				point1 = p;

	var edge_distance : float = (uv - 0.5*(point0+point1)).dot((point0-point1).normalized());
	
	return Color(point0.x, point0.y, best_distance0 * (size).length() * intensity, edge_distance);

static func voronoi_1(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var c : Color = voronoi(uv, size, stretch, intensity, randomness, pseed);
	
	return Color(c.b, c.b, c.b, 1)

static func voronoi_2(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var c : Color = voronoi(uv, size, stretch, intensity, randomness, pseed);
	
	return Color(c.a, c.a, c.a, 1)

static func voronoi_3(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var c : Color = voronoi(uv, size, stretch, intensity, randomness, pseed);
	
	var vv : Vector2 = Vector2(c.r, c.g)
	
	var v : Vector3 = Commons.rand3(Commons.fractv2(vv));
	
	return Color(v.x, v.y, v.z, 1)

