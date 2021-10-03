tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

static func rgb_to_hsv(c : Vector3) -> Vector3:
	var K : Color = Color(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	
	var p : Color 
	
	if c.y < c.z:
		p = Color(c.z, c.y, K.a, K.b)
	else:
		p = Color(c.y, c.z, K.r, K.g);
	
	var q : Color
	
	if c.x < p.r:
		q = Color(p.r, p.g, p.a, c.x)
	else:
		q = Color(c.x, p.g, p.b, p.r);

	var d : float = q.r - min(q.a, q.g);
	var e : float = 1.0e-10;
	
	return Vector3(abs(q.b + (q.a - q.g) / (6.0 * d + e)), d / (q.r + e), q.r);

static func hsv_to_rgb(c : Vector3) -> Vector3:
	var K : Color = Color(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	
	var p : Vector3 = Commons.absv3(Commons.fractv3(Vector3(c.x, c.x, c.x) + Vector3(K.r, K.g, K.b)) * 6.0 - Vector3(K.a, K.a, K.a));
	
	return c.z * lerp(Vector3(K.r, K.r, K.r), Commons.clampv3(p - Vector3(K.r, K.r, K.r), Vector3(), Vector3(1, 1, 1)), c.y);

static func adjust_hsv(color : Color, hue : float, saturation : float, value : float) -> Color:
	var hsv : Vector3 = rgb_to_hsv(Vector3(color.r, color.g, color.b));
	
	var x : float = Commons.fract(hsv.x + hue)
	var y : float = clamp(hsv.y * saturation, 0.0, 1.0)
	var z : float = clamp(hsv.z * value, 0.0, 1.0)
	
	var h : Vector3 = hsv_to_rgb(Vector3(x, y, z))

	return Color(h.x, h.y, h.z, color.a);

static func brightness_contrast(color : Color, brightness : float, contrast : float) -> Color:
	var bv : Vector3 = Vector3(brightness, brightness, brightness)
	var cvv : Vector3 = Vector3(color.r * contrast, color.g * contrast, color.b * contrast)
	
	var cv : Vector3 = cvv + bv + Vector3(0.5, 0.5, 0.5) - (Vector3(contrast, contrast, contrast) * 0.5)
	
	var v : Vector3 = Commons.clampv3(cv, Vector3(), Vector3(1, 1, 1))
	
	return Color(v.x, v.y, v.z, 1);

static func grayscale_min(c : Vector3) -> float:
	return min(c.x, min(c.y, c.z));

static func grayscale_max(c : Vector3) -> float:
	return max(c.x, max(c.y, c.z));

static func grayscale_lightness(c : Vector3) -> float:
	return 0.5*(max(c.x, max(c.y, c.z)) + min(c.x, min(c.y, c.z)));

static func grayscale_average(c : Vector3) -> float:
	return 0.333333333333*(c.x + c.y + c.z);

static func grayscale_luminosity(c : Vector3) -> float:
	return 0.21 * c.x + 0.72 * c.y + 0.07 * c.z;

static func invert(color : Color) -> Color:
	return Color(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);
