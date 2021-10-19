tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#voronoi.mmg

#voronoi_1, 2, 3, 4 -> different outputs

#Outputs:

#vec4 $(name_uv)_xyzw = voronoi($uv, vec2($scale_x, $scale_y), vec2($stretch_y, $stretch_x), $intensity, $randomness, $seed);

#Nodes - float - A greyscale pattern based on the distance to cell centers
#$(name_uv)_xyzw.z

#Borders - float - A greyscale pattern based on the distance to borders
#$(name_uv)_xyzw.w

#Random color - rgb - A color pattern that assigns a random color to each cell
#rand3(fract(floor($(name_uv)_xyzw.xy)/vec2($scale_x, $scale_y)))

#Fill - rgba - An output that should be plugged into a Fill companion node
#vec4(fract(($(name_uv)_xyzw.xy-1.0)/vec2($scale_x, $scale_y)), vec2(2.0)/vec2($scale_x, $scale_y))

#Inputs:

#scale, min: 1, max: 32, step: 1, default: 4
#stretch, min: 0.01, max: 1, step: 0.01, default: 1
#intensity, min: 0, max: 1, step: 0.01, default: 0.75
#randomness, min: 0, max: 1, step: 0.01, default: 1

#vec4 $(name_uv)_xyzw = voronoi($uv, vec2($scale_x, $scale_y), vec2($stretch_y, $stretch_x), $intensity, $randomness, $seed);

#note this is newer than what I have TODO

#// Based on https://www.shadertoy.com/view/ldl3W8
#// The MIT License
#// Copyright © 2013 Inigo Quilez
#vec3 iq_voronoi(vec2 x, vec2 size, vec2 stretch, float randomness, vec2 seed) {
#	vec2 n = floor(x);
#	vec2 f = fract(x);
#	vec2 mg, mr, mc;
#	float md = 8.0;
#
#	for (int j=-1; j<=1; j++)
#		for (int i=-1; i<=1; i++) {
#			vec2 g = vec2(float(i),float(j));
#			vec2 o = randomness*rand2(seed + mod(n + g + size, size));
#			vec2 c = g + o;
#			vec2 r = c - f;
#			vec2 rr = r*stretch;
#			float d = dot(rr,rr);
#			if (d<md) {
#				mc = c;
#				md = d;
#				mr = r;
#				mg = g;
#			}  
#		}
#
#	md = 8.0;
#
#	for (int j=-2; j<=2; j++)
#		for (int i=-2; i<=2; i++) {
#			vec2 g = mg + vec2(float(i),float(j));
#			vec2 o = randomness*rand2(seed + mod(n + g + size, size));
#			vec2 r = g + o - f;
#			vec2 rr = (mr-r)*stretch;
#
#			if (dot(rr,rr)>0.00001)
#				md = min(md, dot(0.5*(mr+r)*stretch, normalize((r-mr)*stretch)));
#		}
#
#	return vec3(md, mc+n);
#}
#
#vec4 voronoi(vec2 uv, vec2 size, vec2 stretch, float intensity, float randomness, float seed) {
#	uv *= size;
#	vec3 v = iq_voronoi(uv, size, stretch, randomness, rand2(vec2(seed, 1.0-seed)));
#	return vec4(v.yz, intensity*length((uv-v.yz)*stretch), v.x);
#}

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

#$(name_uv)_xyzw.z

static func voronoi_1(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var c : Color = voronoi(uv, size, stretch, intensity, randomness, pseed);
	
	return Color(c.b, c.b, c.b, 1)

#$(name_uv)_xyzw.w

static func voronoi_2(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var c : Color = voronoi(uv, size, stretch, intensity, randomness, pseed);
	
	return Color(c.a, c.a, c.a, 1)

#rand3(fract(floor($(name_uv)_xyzw.xy)/vec2($scale_x, $scale_y)))

static func voronoi_3(uv : Vector2, size : Vector2, stretch : Vector2, intensity : float, randomness : float, pseed : int) -> Color:
	var c : Color = voronoi(uv, size, stretch, intensity, randomness, pseed);
	
	var vv : Vector2 = Vector2(c.r, c.g)
	
	var v : Vector3 = Commons.rand3(Commons.fractv2(vv));
	
	return Color(v.x, v.y, v.z, 1)

#vec4(fract(($(name_uv)_xyzw.xy-1.0)/vec2($scale_x, $scale_y)), vec2(2.0)/vec2($scale_x, $scale_y))

#voronoi_4 todo
