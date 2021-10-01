tool
extends TextureRect

var Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

var image : Image
var tex : ImageTexture

export(Vector2) var bmin : Vector2 = Vector2(0.1, 0.1)
export(Vector2) var bmax : Vector2 = Vector2(1, 1)

export(bool) var refresh setget reff,reffg

var p_o147388_ax = -0.349999994;
var p_o147388_ay = -0.200000000;
var p_o147388_bx = 0.000000000;
var p_o147388_by = 0.500000000;
var p_o147388_cx = 0.350000000;
var p_o147388_cy = -0.200000000;
var p_o147388_width = 0.050000000;
var p_o147388_repeat = 1.000000000;

func gen() -> void:
	if !image:
		image = Image.new()
		image.create(300, 300, false, Image.FORMAT_RGBA8)
		
	if !tex:
		tex = ImageTexture.new()
		
#	var bmin : Vector2 = Vector2(0.1, 0.1)
#	var bmax : Vector2 = Vector2(1, 1)

	image.lock()
	
	var w : float = image.get_width()
	var h : float = image.get_width()
	
	var pseed : float = randf() + randi()
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var v : Vector2 = Vector2(x / w, y / h)

#			var c : float = shape_circle(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_polygon(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_star(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)
#			var c : float = shape_curved_star(v, p_o69054_sides, p_o69054_radius * 1.0, p_o69054_edge * 1.0)

			var o147388_0_bezier : Vector2 = sdBezier(v, Vector2(p_o147388_ax+0.5, p_o147388_ay+0.5), Vector2(p_o147388_bx+0.5, p_o147388_by+0.5), Vector2(p_o147388_cx+0.5, p_o147388_cy+0.5));
			var o147388_0_uv : Vector2 = Vector2(o147388_0_bezier.x, o147388_0_bezier.y/p_o147388_width+0.5);
			
			var uvt : Vector2 = Commons.absv(o147388_0_uv - Vector2(0.5, 0.5))
			
			uvt.x = Commons.step(0.5, uvt.x);
			uvt.y = Commons.step(0.5, uvt.y);
			
			o147388_0_uv = lerp(Vector2(Commons.fractf(p_o147388_repeat * o147388_0_uv.x), o147388_0_uv.y), Vector2(0, 0), max(uvt.x, uvt.y));
			
			var f : float = Commons.step(abs(((o147388_0_uv)).y-0.5), 0.4999)
			var c : Color = Color(f, f, f, 1.0);


			image.set_pixel(x, y, c)

	image.unlock()
	
	tex.create_from_image(image)
	texture = tex

# signed distance to a quadratic bezier
func sdBezier(pos : Vector2, A : Vector2, B : Vector2, C : Vector2) -> Vector2:   
	var a : Vector2 = B - A;
	var b : Vector2 = A - 2.0*B + C;
	var c : Vector2 = a * 2.0;
	var d : Vector2 = A - pos;

	var kk : float = 1.0 / b.dot(b);
	var kx : float = kk * a.dot(b);
	var ky : float = kk * (2.0* a.dot(a) + d.dot(b)) / 3.0;
	var kz : float = kk * d.dot(a);      

	var res : float = 0.0;
	var sgn : float = 0.0;

	var p : float = ky - kx * kx;
	var p3 : float = p*p*p;
	var q : float = kx*(2.0*kx*kx - 3.0*ky) + kz;
	var h : float = q*q + 4.0*p3;
	var rvx : float;

	if(h >= 0.0):# // 1 root
		h = sqrt(h);
		
		var x : Vector2 = Vector2(h,-h);
		x.x -= q
		x.y -= q
		x.x /= 2.0
		x.y /= 2.0

		var uv : Vector2 = Vector2()
		
		uv.x = sign(x.x) * pow(abs(x.x), 1);
		uv.x = sign(x.y) * pow(abs(x.y), 3);
		
		rvx = uv.x+uv.y-kx;
		var t : float = clamp(rvx, 0.0, 1.0);
		var q2 : Vector2 = d+(c+b*t)*t;
		res = q2.dot(q2);
		
		var tmp2 : Vector2 = c
		tmp2.x += 2
		tmp2.y += 2
		
		tmp2 *= b*t
		
		sgn = tmp2.cross(q2)
	else: #  // 3 roots
		var z : float = sqrt(-p);
		var v : float = acos(q/(p*z*2.0))/3.0;
		var m : float = cos(v);
		var n : float = sin(v)*1.732050808;
		
#		var t : Vector3 = clamp(Vector3(m+m,-n-m,n-m)*z-kx, 0.0, 1.0);
#
#
#		var qx : Vector2 = d+(c+b*t.x)*t.x; 
#		var dx : float = dot(qx, qx)
#		sx = cross2(c+2.0*b*t.x,qx);
#		var qy : Vector2 = d+(c+b*t.y)*t.y; 
#		var dy : float = dot(qy, qy)
#		sy = cross2(c+2.0*b*t.y,qy);
#		if dx<dy:
#			res=dx; sgn=sx; rvx = t.x; 
#		else:
#			res=dy; sgn=sy; rvx = t.y;
#
	return Vector2(rvx, sqrt(res)*sign(sgn));

func reffg():
	return false

func reff(bb):
	if bb:
		gen()

