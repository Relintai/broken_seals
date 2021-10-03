tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

static func sdf_show(val : float, bevel : float) -> Color:
	var f : float = clamp(-val / max(bevel, 0.00001), 0.0, 1.0);
	
	return Color(f, f, f, 1)

static func sdf_circle(uv : Vector2, c : Vector2, r : float) -> float:
	c.x += 0.5
	c.y += 0.5
	
	return (uv - c).length() - r;

static func sdf_box(uv : Vector2, c : Vector2, wh : Vector2) -> float:
	c.x += 0.5
	c.y += 0.5
	
	var d : Vector2 = Commons.absv2(uv - c) - wh
	
	return Commons.maxv2(d, Vector2(0, 0)).length() + min(max(d.x, d.y), 0.0)

static func sdf_line(uv : Vector2, a : Vector2, b : Vector2, r : float) -> float:
	a.x += 0.5
	a.y += 0.5
	
	b.x += 0.5
	b.y += 0.5
	
	return sdLine(uv, a, b) - r


static func sdf_rhombus(uv : Vector2, c : Vector2, wh : Vector2) -> float:
	c.x += 0.5
	c.y += 0.5
	
	return sdRhombus(uv - c, wh);


static func sdf_arc(uv : Vector2, a : Vector2, r : Vector2) -> float:
	return sdArc(uv - Vector2(0.5, 0.5), Commons.modf(a.x, 360.0) * 0.01745329251, Commons.modf(a.y, 360.0)*0.01745329251, r.x, r.y)

static func sdr_ndot(a : Vector2, b : Vector2) -> float:
	return a.x * b.x - a.y * b.y;

static func sdRhombus(p : Vector2, b : Vector2) -> float:
	var q : Vector2 = Commons.absv2(p);
	var h : float = clamp((-2.0 * sdr_ndot(q,b) + sdr_ndot(b,b)) / b.dot(b), -1.0, 1.0);
	var d : float = ( q - 0.5*b * Vector2(1.0-h, 1.0+h)).length()
	return d * sign(q.x*b.y + q.y*b.x - b.x*b.y)

static func sdArc(p : Vector2, a1 : float, a2 : float, ra : float, rb : float) -> float:
	var amid : float = 0.5*(a1+a2)+1.6+3.14 * Commons.step(a1, a2);
	var alength : float = 0.5*(a1-a2)-1.6+3.14 * Commons.step(a1, a2);
	var sca : Vector2 = Vector2(cos(amid), sin(amid));
	var scb : Vector2 = Vector2(cos(alength), sin(alength));
	
	#p *= Matrix(Vector2(sca.x , sca.y), Vector2(-sca.y, sca.x));
	
	var pt : Vector2 = p
	
	p.x = pt.x * sca.x + pt.y * sca.y 
	p.y = pt.x * -sca.y + pt.y * sca.x
	
	p.x = abs(p.x);
	
	var k : float
	
	if (scb.y * p.x > scb.x * p.y):
		k = p.dot(scb)
	else:
		k = p.length();
	
	return sqrt( p.dot(p) + ra * ra - 2.0 * ra * k ) - rb;
	

static func sdf_boolean_union(a : float, b : float) -> float:
	return min(a, b)
	
static func sdf_boolean_substraction(a : float, b : float) -> float:
	return max(-a, b)

static func sdf_boolean_intersection(a : float, b : float) -> float:
	return max(a, b)
	
static func sdf_smooth_boolean_union(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0)
	return lerp(d2, d1, h) - k * h * (1.0 - h)

static func sdf_smooth_boolean_substraction(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 - 0.5 * (d2 + d1) / k, 0.0, 1.0)
	return lerp(d2, -d1, h) + k * h * (1.0 - h)

static func sdf_smooth_boolean_intersection(d1 : float, d2 : float, k : float) -> float:
	var h : float = clamp( 0.5 - 0.5 * (d2 - d1) / k, 0.0, 1.0)
	return lerp(d2, d1, h) + k * h * (1.0 - h)

static func sdf_rounded_shape(a : float, r : float) -> float:
	return a - r

static func sdf_annular_shape(a : float, r : float) -> float:
	return abs(a) - r

static func sdf_morph(a : float, b : float, amount : float) -> float:
	return lerp(a, b, amount)

static func sdLine(p : Vector2, a  : Vector2, b : Vector2) -> float:
	var pa : Vector2 = p - a
	var ba : Vector2 = b - a
	
	var h : float = clamp(pa.dot(ba) / ba.dot(ba), 0.0, 1.0);
	
	return (pa - (ba * h)).length()


#Needs thought
#func sdf_translate(a : float, x : float, y : float) -> float:
#	return lerp(a, b, amount)

static func sdf2d_rotate(uv : Vector2, a : float) -> Vector2:
	var rv : Vector2;
	var c : float = cos(a);
	var s : float = sin(a);
	uv -= Vector2(0.5, 0.5);
	rv.x = uv.x*c+uv.y*s;
	rv.y = -uv.x*s+uv.y*c;
	return rv+Vector2(0.5, 0.5);

# signed distance to a quadratic bezier
static func sdBezier(pos : Vector2, A : Vector2, B : Vector2, C : Vector2) -> Vector2:   
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

