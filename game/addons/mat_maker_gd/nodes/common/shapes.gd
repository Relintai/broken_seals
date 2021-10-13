tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#----------------------
#sphere.mmg

#Outputs:

#Output - (float) - A heightmap of the specified sphere
#sphere($uv, vec2($cx, $cy), $r)

#Inputs:
#center, vector2, default: 0.5, min: 0, max: 1, step: 0.01
#radius, float, min: 0, max: 1, default: 0.5, step:0.01

#----------------------
#shape.mmg

#Outputs:

#Output - (float) - Shows a white shape on a black background
#shape_$(shape)($(uv), $(sides), $(radius)*$radius_map($uv), $(edge)*$edge_map($uv))

#Inputs:
#shape, enum, default: 0, values: circle, ploygon, star, curved_star, rays
#sides, int, min: 2, max: 32, default: 3, step:1
#radius, float, min: 0, max: 1, default: 1, step:0.01 (universal input)
#edge, float, min: 0, max: 1, default: 0.2, step:0.01 (universal input)

#----------------------
#box.mmg
#A heightmap of the specified box

#		"outputs": [
#			{
#				"f": "1.0-box($uv, vec3($cx, $cy, $cz), vec3($sx, $sy, $sz), 0.01745329251*vec3($rx, $ry, $rz))",
#				"longdesc": "A heightmap of the specified box",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Center X",
#				"longdesc": "X coordinate of the center of the box",
#				"max": 1,
#				"min": 0,
#				"name": "cx",
#				"shortdesc": "Center.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Center Y",
#				"longdesc": "Y coordinate of the center of the box",
#				"max": 1,
#				"min": 0,
#				"name": "cy",
#				"shortdesc": "Center.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Center Z",
#				"longdesc": "Z coordinate of the center of the box",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "cz",
#				"shortdesc": "Center.z",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Size X",
#				"longdesc": "Size along X axis",
#				"max": 1,
#				"min": 0,
#				"name": "sx",
#				"shortdesc": "Size.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Size Y",
#				"longdesc": "Size along Y axis",
#				"max": 1,
#				"min": 0,
#				"name": "sy",
#				"shortdesc": "Size.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Size Z",
#				"longdesc": "Size along Z axis",
#				"max": 1,
#				"min": 0,
#				"name": "sz",
#				"shortdesc": "Size.z",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rot X",
#				"longdesc": "Rotation angle around X axis",
#				"max": 180,
#				"min": -180,
#				"name": "rx",
#				"shortdesc": "Rot.x",
#				"step": 0.1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rot Y",
#				"longdesc": "Rotation angle around Y axis",
#				"max": 180,
#				"min": -180,
#				"name": "ry",
#				"shortdesc": "Rot.y",
#				"step": 0.1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rot Z",
#				"longdesc": "Rotation angle around Y axis",
#				"max": 180,
#				"min": -180,
#				"name": "rz",
#				"shortdesc": "Rot.z",
#				"step": 0.1,
#				"type": "float"
#			}
#		]

#float sphere(vec2 uv, vec2 c, float r) {
#	uv -= c;
#	uv /= r;
#	return 2.0*r*sqrt(max(0.0, 1.0-dot(uv, uv)));
#}

static func sphere(uv : Vector2, c : Vector2, r : float) -> float:
	return 0.0

#float shape_circle(vec2 uv, float sides, float size, float edge) {  
#	uv = 2.0*uv-1.0;
#	edge = max(edge, 1.0e-8); 
#	float distance = length(uv);  
#	return clamp((1.0-distance/size)/edge, 0.0, 1.0);
#}

static func shape_circle(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8)
	
	var distance : float = uv.length()
	
	return clamp((1.0 - distance / size) / edge, 0.0, 1.0)

#float shape_polygon(vec2 uv, float sides, float size, float edge) {  
#	uv = 2.0*uv-1.0;
#	edge = max(edge, 1.0e-8);  
#	float angle = atan(uv.x, uv.y)+3.14159265359;  
#	float slice = 6.28318530718/sides;  
#	return clamp((1.0-(cos(floor(0.5+angle/slice)*slice-angle)*length(uv))/size)/edge, 0.0, 1.0);
#}

static func shape_polygon(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8)
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = atan(uv.y / uv.x) + 3.14159265359
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(0.5 + angle / slice) * slice - angle) * uv.length()) / (edge * size), 0.0, 1.0)

#float shape_star(vec2 uv, float sides, float size, float edge) {  
#	uv = 2.0*uv-1.0;
#	edge = max(edge, 1.0e-8);  
#	float angle = atan(uv.x, uv.y);  
#	float slice = 6.28318530718/sides;  
#	return clamp((1.0-(cos(floor(angle*sides/6.28318530718-0.5+2.0*step(fract(angle*sides/6.28318530718), 0.5))*slice-angle)*length(uv))/size)/edge, 0.0, 1.0);
#}

static func shape_star(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8);
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = atan(uv.y / uv.x)
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(1.5 + angle / slice - 2.0 * Commons.step(0.5 * slice, Commons.modf(angle, slice))) * slice - angle) * uv.length()) / (edge * size), 0.0, 1.0);

#float shape_curved_star(vec2 uv, float sides, float size, float edge) {
#	uv = 2.0*uv-1.0;
#	edge = max(edge, 1.0e-8);
#	float angle = 2.0*(atan(uv.x, uv.y)+3.14159265359);
#	float slice = 6.28318530718/sides;
#	return clamp((1.0-cos(floor(0.5+0.5*angle/slice)*2.0*slice-angle)*length(uv)/size)/edge, 0.0, 1.0);
#}

static func shape_curved_star(uv : Vector2, sides : float, size : float, edge : float) -> float:
	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = max(edge, 1.0e-8);
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var angle : float = 2.0*(atan(uv.y / uv.x) + 3.14159265359)
	var slice : float = 6.28318530718 / sides
	
	return clamp((size - cos(floor(0.5 + 0.5 * angle / slice) * 2.0 * slice - angle) * uv.length())/(edge * size), 0.0, 1.0);

#float shape_rays(vec2 uv, float sides, float size, float edge) {  
#	uv = 2.0*uv-1.0;
#	edge = 0.5*max(edge, 1.0e-8)*size;
#	float slice = 6.28318530718/sides;  
#	float angle = mod(atan(uv.x, uv.y)+3.14159265359, slice)/slice;  
#	return clamp(min((size-angle)/edge, angle/edge), 0.0, 1.0);
#}

static func shape_rays(uv : Vector2, sides : float, size : float, edge : float) -> float:

	uv.x = 2.0 * uv.x - 1.0
	uv.y = 2.0 * uv.y - 1.0
	
	edge = 0.5 * max(edge, 1.0e-8) * size
	
	#simple no branch for division by zero
	uv.x += 0.0000001
	
	var slice : float = 6.28318530718 / sides
	var angle : float = Commons.modf(atan(uv.y / uv.x) + 3.14159265359, slice) / slice
	
	return clamp(min((size - angle) / edge, angle / edge), 0.0, 1.0);

#float box(vec2 uv, vec3 center, vec3 rad, vec3 rot) {\n\t
#	vec3 ro = vec3(uv, 1.0)-center;\n\t
#	vec3 rd = vec3(0.0000001, 0.0000001, -1.0);\n\t
#	mat3 r = mat3(vec3(1, 0, 0), vec3(0, cos(rot.x), -sin(rot.x)), vec3(0, sin(rot.x), cos(rot.x)));\n\t
#
#	r *= mat3(vec3(cos(rot.y), 0, -sin(rot.y)), vec3(0, 1, 0), vec3(sin(rot.y), 0, cos(rot.y)));\n\t
#	r *= mat3(vec3(cos(rot.z), -sin(rot.z), 0), vec3(sin(rot.z), cos(rot.z), 0), vec3(0, 0, 1));\n\t
#	ro = r * ro;\n\t
#	rd = r * rd;\n    
#	vec3 m = 1.0/rd;\n    
#	vec3 n = m*ro;\n    
#	vec3 k = abs(m)*rad;\n    
#	vec3 t1 = -n - k;\n    
#	vec3 t2 = -n + k;\n\n    
#
#	float tN = max(max(t1.x, t1.y), t1.z);\n    
#	float tF = min(min(t2.x, t2.y), t2.z);\n    
#
#	if(tN>tF || tF<0.0) return 1.0;\n    
#
#	return tN;\n
#}

