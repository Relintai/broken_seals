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



var p_o95415_repeat = 1.000000000;

var p_o95415_gradient_0_pos = 0.000000000;
var p_o95415_gradient_0_r = 0.000000000;
var p_o95415_gradient_0_g = 0.000000000;
var p_o95415_gradient_0_b = 0.000000000;
var p_o95415_gradient_0_a = 1.000000000;
var p_o95415_gradient_1_pos = 0.490909091;
var p_o95415_gradient_1_r = 1.000000000;
var p_o95415_gradient_1_g = 0.000000000;
var p_o95415_gradient_1_b = 0.000000000;
var p_o95415_gradient_1_a = 1.000000000;
var p_o95415_gradient_2_pos = 1.000000000;
var p_o95415_gradient_2_r = 1.000000000;
var p_o95415_gradient_2_g = 1.000000000;
var p_o95415_gradient_2_b = 1.000000000;
var p_o95415_gradient_2_a = 1.000000000;


func gradient_type_1_orig(x : float) -> Color:
	if (x < 0.5*(p_o95415_gradient_0_pos+p_o95415_gradient_1_pos)):
		return Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a);
	elif (x < 0.5*(p_o95415_gradient_1_pos+p_o95415_gradient_2_pos)):
		return Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a);

	return Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a);

func gradient_type_2_orig(x : float) -> Color:
	if (x < p_o95415_gradient_0_pos):
		return Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a);
	elif (x < p_o95415_gradient_1_pos):
		return lerp(Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a), Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), ((x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos)));
	elif (x < p_o95415_gradient_2_pos):
		return lerp(Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a), ((x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos)));

	return Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a);


func gradient_type_3_orig(x : float) -> Color:
	if (x < p_o95415_gradient_0_pos):
		return Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a);
	elif (x < p_o95415_gradient_1_pos):
		return lerp(Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a), Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), 0.5-0.5*cos(3.14159265359*(x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos)));
	if (x < p_o95415_gradient_2_pos):
		return lerp(Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a), 0.5-0.5*cos(3.14159265359*(x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos)));

	return Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a);

func gradient_type_4_orig(x : float) -> Color:
	if (x < p_o95415_gradient_0_pos):
		return Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a);
	elif (x < p_o95415_gradient_1_pos):
		return lerp(lerp(Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a), (x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos)), lerp(Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a), Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), (x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos)), 1.0-0.5*(x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos));
	elif (x < p_o95415_gradient_2_pos):
		return lerp(lerp(Color(p_o95415_gradient_0_r,p_o95415_gradient_0_g,p_o95415_gradient_0_b,p_o95415_gradient_0_a), Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), (x-p_o95415_gradient_0_pos)/(p_o95415_gradient_1_pos-p_o95415_gradient_0_pos)), lerp(Color(p_o95415_gradient_1_r,p_o95415_gradient_1_g,p_o95415_gradient_1_b,p_o95415_gradient_1_a), Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a), (x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos)), 0.5+0.5*(x-p_o95415_gradient_1_pos)/(p_o95415_gradient_2_pos-p_o95415_gradient_1_pos));
  
	return Color(p_o95415_gradient_2_r,p_o95415_gradient_2_g,p_o95415_gradient_2_b,p_o95415_gradient_2_a);
 
