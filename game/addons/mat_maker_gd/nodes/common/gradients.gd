extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#note: data : PoolRealArray -> pos, r, g, b, a, pos, r, g, b, a ....

static func circular_gradient_type_1(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_1(Commons.fractf(repeat * 0.15915494309 * atan((uv.x - 0.5) / uv.y - 0.5)), data)

static func circular_gradient_type_2(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_2(Commons.fractf(repeat * 0.15915494309 * atan((uv.x - 0.5) / uv.y - 0.5)), data)
	
static func circular_gradient_type_3(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_3(Commons.fractf(repeat * 0.15915494309 * atan((uv.x - 0.5) / uv.y - 0.5)), data)
	
static func circular_gradient_type_4(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_4(Commons.fractf(repeat * 0.15915494309 * atan((uv.x - 0.5) / uv.y - 0.5)), data)

static func gradient_type_1(x : float, data : PoolRealArray) -> Color:
	if data.size() % 5 != 0 || data.size() == 0:
		return Color()
	
	for i in range(0, data.size() - 5, 5):
		if x < 0.5 * (data[i] + data[i + 5]):
			return Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
	
	var ds = data.size() - 5
	return Color(data[ds + 1], data[ds + 2], data[ds + 3], data[ds + 4])

static func gradient_type_2(x : float, data : PoolRealArray) -> Color:
	if data.size() % 5 != 0 || data.size() == 0:
		return Color()
	
	for i in range(0, data.size() - 5, 5):
		if x < data[i]:
			if i == 0:
				return Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
			
			var cprev : Color = Color(data[i - 4], data[i - 3], data[i - 2], data[i - 1])
			var ccurr : Color = Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
			return lerp(cprev, ccurr, (x - data[i - 5]) / (data[i] - data[i - 5]));
	
	var ds = data.size() - 5
	return Color(data[ds + 1], data[ds + 2], data[ds + 3], data[ds + 4])

static func gradient_type_3(x : float, data : PoolRealArray) -> Color:
	if data.size() % 5 != 0 || data.size() == 0:
		return Color()
	
	for i in range(0, data.size() - 5, 5):
		if x < data[i]:
			if i == 0:
				return Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
			
			var cprev : Color = Color(data[i - 4], data[i - 3], data[i - 2], data[i - 1])
			var ccurr : Color = Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
			return lerp(cprev, ccurr, 0.5 - 0.5 * cos(3.14159265359 * ((x - data[i - 5]) / (data[i] - data[i - 5]))))
	
	var ds = data.size() - 5
	return Color(data[ds + 1], data[ds + 2], data[ds + 3], data[ds + 4])

#todo, logic is not yet finished
static func gradient_type_4(x : float, data : PoolRealArray) -> Color:
	if data.size() % 5 != 0 || data.size() == 0:
		return Color()
	
	for i in range(0, data.size() - 5, 5):
		if x < data[i]:
			if i == 0:
				return Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
			
			var cprev : Color = Color(data[i - 4], data[i - 3], data[i - 2], data[i - 1])
			var ccurr : Color = Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
			return lerp(cprev, ccurr, 0.5 - 0.5 * cos(3.14159265359 * ((x - data[i - 5]) / (data[i] - data[i - 5]))))
	
	var ds = data.size() - 5
	return Color(data[ds + 1], data[ds + 2], data[ds + 3], data[ds + 4])
	
	
#	if (x < gradient_0_pos):
#		return Color(gradient_0_r,gradient_0_g,gradient_0_b,gradient_0_a);
#	elif (x < gradient_1_pos):
#		return lerp(lerp(Color(gradient_1_r,gradient_1_g,gradient_1_b,gradient_1_a), Color(gradient_2_r,gradient_2_g,gradient_2_b,gradient_2_a), (x-gradient_1_pos)/(gradient_2_pos-gradient_1_pos)), lerp(Color(gradient_0_r,gradient_0_g,gradient_0_b,gradient_0_a), Color(gradient_1_r,gradient_1_g,gradient_1_b,gradient_1_a), (x-gradient_0_pos)/(gradient_1_pos-gradient_0_pos)), 1.0-0.5*(x-gradient_0_pos)/(gradient_1_pos-gradient_0_pos));
#	elif (x < gradient_2_pos):
#		return lerp(lerp(Color(gradient_0_r,gradient_0_g,gradient_0_b,gradient_0_a), Color(gradient_1_r,gradient_1_g,gradient_1_b,gradient_1_a), (x-gradient_0_pos)/(gradient_1_pos-gradient_0_pos)), lerp(Color(gradient_1_r,gradient_1_g,gradient_1_b,gradient_1_a), Color(gradient_2_r,gradient_2_g,gradient_2_b,gradient_2_a), (x-gradient_1_pos)/(gradient_2_pos-gradient_1_pos)), 0.5+0.5*(x-gradient_1_pos)/(gradient_2_pos-gradient_1_pos));
#
#	return Color(gradient_2_r,gradient_2_g,gradient_2_b,gradient_2_a);
