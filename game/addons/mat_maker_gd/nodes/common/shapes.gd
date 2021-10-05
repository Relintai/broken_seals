tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#float shape_circle(vec2 uv, float sides, float size, float edge) {  
#	uv = 2.0*uv-1.0;edge = max(edge, 1.0e-8); 
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
