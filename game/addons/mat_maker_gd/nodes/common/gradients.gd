tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#note: data : PoolRealArray -> pos, r, g, b, a, pos, r, g, b, a ....

#gradient.mmg

#float $(name_uv)_r = 0.5+(cos($rotate*0.01745329251)*($uv.x-0.5)+sin($rotate*0.01745329251)*($uv.y-0.5))/(cos(abs(mod($rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);"

#output: $gradient(fract($(name_uv)_r*$repeat))

#repeat: default: 1, min: 1, max : 32, step: 1
#rotate: default: 0, min: -180, max: 180, step: 0.1

#default: "interpolation": 1,
# "points": [{"a": 1,"b": 0,"g": 0,"pos": 0,"r": 0},{"a": 1,"b": 1,"g": 1,"pos": 1,"r": 1} ],

#radial_gradient.mmg

#output: $gradient(fract($repeat*1.41421356237*length(fract($uv)-vec2(0.5, 0.5))))

#repeat: default: 1, min: 1, max : 32, step: 1

#circular_gradient.mmg

#output: gradient(fract($repeat*0.15915494309*atan($uv.y-0.5, $uv.x-0.5)))

#repeat: default: 1, min: 1, max : 32, step: 1

#gradient.gd

static func radial_gradient_type_1(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_1(Commons.fractf(repeat * 1.41421356237* (Commons.fractv2(uv) - Vector2(0.5, 0.5)).length()), data)

static func radial_gradient_type_2(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_2(Commons.fractf(repeat * 1.41421356237* (Commons.fractv2(uv) - Vector2(0.5, 0.5)).length()), data)
	
static func radial_gradient_type_3(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_3(Commons.fractf(repeat * 1.41421356237* (Commons.fractv2(uv) - Vector2(0.5, 0.5)).length()), data)
	
static func radial_gradient_type_4(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_4(Commons.fractf(repeat * 1.41421356237* (Commons.fractv2(uv) - Vector2(0.5, 0.5)).length()), data)



static func normal_gradient_type_1(uv : Vector2, repeat : float, rotate : float, data : PoolRealArray) -> Color:
	var rr : float = 0.5+(cos(rotate*0.01745329251)*(uv.x-0.5)+sin(rotate*0.01745329251)*(uv.y-0.5))/(cos(abs(Commons.modf(rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
	return gradient_type_1(Commons.fractf(rr * repeat), data)

static func normal_gradient_type_2(uv : Vector2, repeat : float, rotate : float, data : PoolRealArray) -> Color:
	var rr : float = 0.5+(cos(rotate*0.01745329251)*(uv.x-0.5)+sin(rotate*0.01745329251)*(uv.y-0.5))/(cos(abs(Commons.modf(rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
	return gradient_type_2(Commons.fractf(rr * repeat), data)
	
static func normal_gradient_type_3(uv : Vector2, repeat : float, rotate : float, data : PoolRealArray) -> Color:
	var rr : float = 0.5+(cos(rotate*0.01745329251)*(uv.x-0.5)+sin(rotate*0.01745329251)*(uv.y-0.5))/(cos(abs(Commons.modf(rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
	return gradient_type_3(Commons.fractf(rr * repeat), data)
	
static func normal_gradient_type_4(uv : Vector2, repeat : float, rotate : float, data : PoolRealArray) -> Color:
	var rr : float = 0.5+(cos(rotate*0.01745329251)*(uv.x-0.5)+sin(rotate*0.01745329251)*(uv.y-0.5))/(cos(abs(Commons.modf(rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
	return gradient_type_4(Commons.fractf(rr * repeat), data)



static func circular_gradient_type_1(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_1(Commons.fractf(repeat * 0.15915494309 * atan2((uv.y - 0.5), uv.x - 0.5)), data)

static func circular_gradient_type_2(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_2(Commons.fractf(repeat * 0.15915494309 * atan2((uv.y - 0.5), uv.x - 0.5)), data)
	
static func circular_gradient_type_3(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_3(Commons.fractf(repeat * 0.15915494309 * atan2((uv.y - 0.5), uv.x - 0.5)), data)
	
static func circular_gradient_type_4(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_4(Commons.fractf(repeat * 0.15915494309 * atan2((uv.y - 0.5), uv.x - 0.5)), data)


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
	
	for i in range(0, data.size(), 5):
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
	
	for i in range(0, data.size(), 5):
		if x < data[i]:
			if i == 0:
				return Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
			
			var cprev : Color = Color(data[i - 4], data[i - 3], data[i - 2], data[i - 1])
			var ccurr : Color = Color(data[i + 1], data[i + 2], data[i + 3], data[i + 4])
			return lerp(cprev, ccurr, 0.5 - 0.5 * cos(3.14159265359 * ((x - data[i - 5]) / (data[i] - data[i - 5]))))
	
	var ds = data.size() - 5
	return Color(data[ds + 1], data[ds + 2], data[ds + 3], data[ds + 4])

static func get_data_color(index : int, data : PoolRealArray) -> Color:
	var i : int = index * 5
	
	return Color(data[i + 1], data[i + 2],data[i + 3], data[i + 4])
	
static func get_data_pos(index : int, data : PoolRealArray) -> float:
	return data[index * 5]

static func gradient_type_4(x : float, data : PoolRealArray) -> Color:
	if data.size() % 5 != 0 || data.size() == 0:
		return Color()
	
	var ds : int = data.size() / 5
	var s : int = ds - 1
	
	for i in range(0, s):
		if x < get_data_pos(i, data):
			if i == 0:
				return get_data_color(i, data)
				
#			var dx : String = "(x-%s)/(%s-%s)" % [ pv(name, i), pv(name, i+1), pv(name, i) ]
			var dx : float = (x - get_data_pos(i, data))/(get_data_pos(i + 1, data) - get_data_pos(i, data))
#			var b : String = "mix(%s, %s, %s)" % [ pc(name, i), pc(name, i+1), dx ]
			var b : Color = lerp(get_data_color(i - 1, data), get_data_color(i - 1, data), dx)

			if i == 1:
#				var c : String = "mix(%s, %s, (x-%s)/(%s-%s))" % [ pc(name, i+1), pc(name, i+2), pv(name, i+1), pv(name, i+2), pv(name, i+1) ]
				var c : Color = lerp(get_data_color(i + 1, data), get_data_color(i + 2, data), (x - get_data_pos(i + 1, data))/(get_data_pos(i + 2, data) - get_data_pos(i + 1, data)))
#				shader += "    return mix("+c+", "+b+", 1.0-0.5*"+dx+");\n"
				return lerp(c, b, 1.0 - 0.5 * dx)
			
#			var a : String = "mix(%s, %s, (x-%s)/(%s-%s))" % [ pc(name, i-1), pc(name, i),  pv(name, i-1), pv(name, i), pv(name, i-1) ]
			var a : Color = lerp(get_data_color(i - 1, data), get_data_color(i, data), (x - get_data_pos(i - 1, data)) / (get_data_pos(i, data) - get_data_pos(i - 1, data)))
			
#			if i < s-1:
			if i < s - 1:
#				var c : String = "mix(%s, %s, (x-%s)/(%s-%s))" % [ pc(name, i+1), pc(name, i+2), pv(name, i+1), pv(name, i+2), pv(name, i+1) ]
				var c : Color = lerp(get_data_color(i + 1, data), get_data_color(i + 2, data), (x - get_data_pos(i + 1, data)) / (get_data_pos(i + 2, data) - get_data_pos(i + 1, data)))
#				var ac : String = "mix("+a+", "+c+", 0.5-0.5*cos(3.14159265359*"+dx+"))"
				var ac : Color = lerp(a, c, 0.5-0.5*cos(3.14159265359 * dx))
#				shader += "    return 0.5*("+b+" + "+ac+");\n"
				var dt : Color = b + ac

				dt.r *= 0.5
				dt.g *= 0.5
				dt.b *= 0.5
				dt.a = clamp(0, 1, dt.a)

				return dt
#			else
			else:
#				shader += "    return mix("+a+", "+b+", 0.5+0.5*"+dx+");\n"
				return lerp(a, b, 0.5 + 0.5 * dx)

	return get_data_color(ds - 1, data)

#todo make it selectable
static func gradient_type_5(x : float, data : PoolRealArray) -> Color:
	if data.size() % 5 != 0 || data.size() == 0:
		return Color()
	
	var ds : int = data.size() / 5
	var s : int = ds - 1
	
	for i in range(0, s):
		if x < get_data_pos(i, data):
			if i == 0:
				return get_data_color(i, data)
				
#			var dx : String = "(x-%s)/(%s-%s)" % [ pv(name, i), pv(name, i+1), pv(name, i) ]
			var dx : float = (x - get_data_pos(i, data))/(get_data_pos(i + 1, data) - get_data_pos(i, data))
#			var b : String = "mix(%s, %s, %s)" % [ pc(name, i), pc(name, i+1), dx ]
			var b : Color = lerp(get_data_color(i - 1, data), get_data_color(i - 1, data), dx)

			if i == 1:
#				var c : String = "mix(%s, %s, (x-%s)/(%s-%s))" % [ pc(name, i+1), pc(name, i+2), pv(name, i+1), pv(name, i+2), pv(name, i+1) ]
				var c : Color = lerp(get_data_color(i + 1, data), get_data_color(i + 2, data), (x - get_data_pos(i + 1, data))/(get_data_pos(i + 2, data) - get_data_pos(i + 1, data)))
#				shader += "    return mix("+c+", "+b+", 1.0-0.5*"+dx+");\n"
				return lerp(c, b, 1.0 - 0.5 * dx)
			
#			var a : String = "mix(%s, %s, (x-%s)/(%s-%s))" % [ pc(name, i-1), pc(name, i),  pv(name, i-1), pv(name, i), pv(name, i-1) ]
			var a : Color = lerp(get_data_color(i - 1, data), get_data_color(i, data), (x - get_data_pos(i - 1, data)) / (get_data_pos(i, data) - get_data_pos(i - 1, data)))
			
#			if i < s-1:
			if i < s - 1:
#				var c : String = "mix(%s, %s, (x-%s)/(%s-%s))" % [ pc(name, i+1), pc(name, i+2), pv(name, i+1), pv(name, i+2), pv(name, i+1) ]
				var c : Color = lerp(get_data_color(i+1, data), get_data_color(i+2, data), (x - get_data_pos(i + 1, data)) / (get_data_pos(i + 2, data) - get_data_pos(i + 1, data)))
#				var ac : String = "mix("+a+", "+c+", 0.5-0.5*cos(3.14159265359*"+dx+"))"
				var ac : Color = lerp(a, c, 0.5-0.5*cos(3.14159265359 * dx))
#				shader += "    return 0.5*("+b+" + "+ac+");\n"
				var dt : Color = b + ac

				dt.r *= 0.5
				dt.g *= 0.5
				dt.b *= 0.5
				dt.a = clamp(0, 1, dt.a)

				return dt
#			else
			else:
#				shader += "    return mix("+a+", "+b+", 0.5+0.5*"+dx+");\n"
				return lerp(a, b, 0.5 + 0.5 * dx)

	return get_data_color(ds - 1, data)
