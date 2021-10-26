tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#Based on MaterialMaker's curve.gd

#Curve PoolRealArray: p.x, p.y, ls, rs,  p.x, p.y .... 

#class Point:
#	var p : Vector2
#	var ls : float
#	var rs : float

#func get_shader(name) -> String:
#	var shader
#	shader = "float "+name+"_curve_fct(float x) {\n"
#	for i in range(points.size()-1):
#		if i < points.size()-2:
#			shader += "if (x <= p_"+name+"_"+str(i+1)+"_x) "
#
#		shader += "{\n"
#		shader += "float dx = x - p_"+name+"_"+str(i)+"_x;\n"
#		shader += "float d = p_"+name+"_"+str(i+1)+"_x - p_"+name+"_"+str(i)+"_x;\n"
#		shader += "float t = dx/d;\n"
#		shader += "float omt = (1.0 - t);\n"
#		shader += "float omt2 = omt * omt;\n"
#		shader += "float omt3 = omt2 * omt;\n"
#		shader += "float t2 = t * t;\n"
#		shader += "float t3 = t2 * t;\n"
#		shader += "d /= 3.0;\n"
#		shader += "float y1 = p_"+name+"_"+str(i)+"_y;\n"
#		shader += "float yac = p_"+name+"_"+str(i)+"_y + d*p_"+name+"_"+str(i)+"_rs;\n"
#		shader += "float ybc = p_"+name+"_"+str(i+1)+"_y - d*p_"+name+"_"+str(i+1)+"_ls;\n"
#		shader += "float y2 = p_"+name+"_"+str(i+1)+"_y;\n"
#		shader += "return y1*omt3 + yac*omt2*t*3.0 + ybc*omt*t2*3.0 + y2*t3;\n"
#		shader += "}\n"
#
#	shader += "}\n"
#	return shader

static func curve(x : float, points : PoolRealArray) -> float:
	if points.size() % 4 != 0 || points.size() < 8:
		return 0.0
	
	var ps : int = points.size() / 4
	
	for i in range(ps - 1):
		var pi : int = i * 4
		var pip1 : int = (i + 1) * 4
		
		if i < ps - 2:
		#	if (x <= p_"+name+"_"+str(i+1)+"_x)
			if x > points[pip1]:
				continue
		
		#float dx = x - p_"+name+"_"+str(i)+"_x;
		var dx : float = x - points[pi];
		
		#var d : float = p_"+name+"_"+str(i+1)+"_x - p_"+name+"_"+str(i)+"_x;
		var d : float = points[pip1] - points[pi];

		var t : float = dx / d
		var omt : float = (1.0 - t)
		var omt2 : float = omt * omt
		var omt3 : float = omt2 * omt
		var t2 : float = t * t
		var t3 : float = t2 * t
		d /= 3.0
		
#		var y1 : float = p_"+name+"_"+str(i)+"_y
		var y1 : float = points[pi + 1]
		
#		var yac : float = p_"+name+"_"+str(i)+"_y + d*p_"+name+"_"+str(i)+"_rs
		var yac : float = points[pi + 1] + d * points[pi + 3]
		
#		var ybc : float = p_"+name+"_"+str(i+1)+"_y - d*p_"+name+"_"+str(i+1)+"_ls
		var ybc : float = points[pip1 + 1] - d * points[pip1 + 2]
		
#		var y2 : float = p_"+name+"_"+str(i+1)+"_y
		var y2 : float = points[pip1 + 1]
		
		return y1 * omt3 + yac * omt2 * t * 3.0 + ybc * omt * t2 * 3.0 + y2 * t3;

	return 0.0
