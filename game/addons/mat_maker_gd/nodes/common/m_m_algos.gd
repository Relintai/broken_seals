tool
extends Reference

#pattern.mmg

#----------------------
#hlsl_defs.tmpl

##define hlsl_atan(x,y) atan2(x, y)
##define mod(x,y) ((x)-(y)*floor((x)/(y)))
#inline float4 textureLod(sampler2D tex, float2 uv, float lod) {
#	return tex2D(tex, uv);
#}
#inline float2 tofloat2(float x) {
#	return float2(x, x);
#}
#inline float2 tofloat2(float x, float y) {
#	return float2(x, y);
#}
#inline float3 tofloat3(float x) {
#	return float3(x, x, x);
#}
#inline float3 tofloat3(float x, float y, float z) {
#	return float3(x, y, z);
#}
#inline float3 tofloat3(float2 xy, float z) {
#	return float3(xy.x, xy.y, z);
#}
#inline float3 tofloat3(float x, float2 yz) {
#	return float3(x, yz.x, yz.y);
#}
#inline float4 tofloat4(float x, float y, float z, float w) {
#	return float4(x, y, z, w);
#}
#inline float4 tofloat4(float x) {
#	return float4(x, x, x, x);
#}
#inline float4 tofloat4(float x, float3 yzw) {
#	return float4(x, yzw.x, yzw.y, yzw.z);
#}
#inline float4 tofloat4(float2 xy, float2 zw) {
#	return float4(xy.x, xy.y, zw.x, zw.y);
#}
#inline float4 tofloat4(float3 xyz, float w) {
#	return float4(xyz.x, xyz.y, xyz.z, w);
#}
#inline float2x2 tofloat2x2(float2 v1, float2 v2) {
#	return float2x2(v1.x, v1.y, v2.x, v2.y);
#}
	
#----------------------
#glsl_defs.tmpl

#float rand(vec2 x) {
#    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5453);
#}

#vec2 rand2(vec2 x) {
#    return fract(cos(mod(vec2(dot(x, vec2(13.9898, 8.141)),
#						      dot(x, vec2(3.4562, 17.398))), vec2(3.14))) * 43758.5453);
#}

#vec3 rand3(vec2 x) {
#    return fract(cos(mod(vec3(dot(x, vec2(13.9898, 8.141)),
#							  dot(x, vec2(3.4562, 17.398)),
#                              dot(x, vec2(13.254, 5.867))), vec3(3.14))) * 43758.5453);
#}

#float param_rnd(float minimum, float maximum, float seed) {
#	return minimum+(maximum-minimum)*rand(vec2(seed));
#}

#vec3 rgb2hsv(vec3 c) {
#	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
#	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
#	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
#
#	float d = q.x - min(q.w, q.y);
#	float e = 1.0e-10;
#	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
#}

#vec3 hsv2rgb(vec3 c) {
#	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
#	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
#	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
#}

#----------------------

static func clampv3(v : Vector3, mi : Vector3, ma : Vector3) -> Vector3:
	v.x = clamp(v.x, mi.x, ma.x)
	v.y = clamp(v.y, mi.y, ma.y)
	v.z = clamp(v.z, mi.z, ma.z)
	
	return v

static func floorc(a : Color) -> Color:
	var v : Color = Color()
	
	v.r = floor(a.r)
	v.g = floor(a.g)
	v.b = floor(a.b)
	v.a = floor(a.a)
	
	return v

static func floorv2(a : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = floor(a.x)
	v.y = floor(a.y)
	
	return v
	
static func floorv3(a : Vector3) -> Vector3:
	var v : Vector3 = Vector3()
	
	v.x = floor(a.x)
	v.y = floor(a.y)
	v.z = floor(a.z)
	
	return v
	
static func smoothstepv2(a : float, b : float, c : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = smoothstep(a, b, c.x)
	v.y = smoothstep(a, b, c.y)
	
	return v

static func maxv2(a : Vector2, b : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = max(a.x, b.x)
	v.y = max(a.y, b.y)
	
	return v

static func maxv3(a : Vector3, b : Vector3) -> Vector3:
	var v : Vector3 = Vector3()
	
	v.x = max(a.x, b.x)
	v.y = max(a.y, b.y)
	v.z = max(a.z, b.z)
	
	return v

static func absv2(v : Vector2) -> Vector2:
	v.x = abs(v.x)
	v.y = abs(v.y)
	
	return v
	
static func absv3(v : Vector3) -> Vector3:
	v.x = abs(v.x)
	v.y = abs(v.y)
	v.z = abs(v.z)
	
	return v

static func cosv2(v : Vector2) -> Vector2:
	v.x = cos(v.x)
	v.y = cos(v.y)
	
	return v

static func cosv3(v : Vector3) -> Vector3:
	v.x = cos(v.x)
	v.y = cos(v.y)
	v.z = cos(v.z)
	
	return v

static func powv2(x : Vector2, y : Vector2) -> Vector2:
	x.x = pow(x.x, y.x)
	x.y = pow(x.y, y.y)
	
	return x

static func modv3(a : Vector3, b : Vector3) -> Vector3:
	var v : Vector3 = Vector3()
	
	v.x = modf(a.x, b.x)
	v.y = modf(a.y, b.y)
	v.z = modf(a.z, b.z)
	
	return v
	
	
static func modv2(a : Vector2, b : Vector2) -> Vector2:
	var v : Vector2 = Vector2()
	
	v.x = modf(a.x, b.x)
	v.y = modf(a.y, b.y)

	return v

static func modf(x : float, y : float) -> float:
	return x - y * floor(x / y)

static func fractv2(v : Vector2) -> Vector2:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	
	return v
	
static func fractv3(v : Vector3) -> Vector3:
	v.x = v.x - floor(v.x)
	v.y = v.y - floor(v.y)
	v.z = v.z - floor(v.z)
	
	return v
	
static func fract(f : float) -> float:
	return f - floor(f)

static func clampv2(v : Vector2, pmin : Vector2, pmax : Vector2) -> Vector2:
	v.x = clamp(v.x, pmin.x, pmax.x)
	v.y = clamp(v.y, pmin.y, pmax.y)
	
	return v

static func minv2(v1 : Vector2, v2 : Vector2) -> Vector2:
	v1.x = min(v1.x, v2.x)
	v1.y = min(v1.y, v2.y)
	
	return v1
	
static func minv3(v1 : Vector3, v2 : Vector3) -> Vector3:
	v1.x = min(v1.x, v2.x)
	v1.y = min(v1.y, v2.y)
	v1.z = min(v1.z, v2.z)
	
	return v1

static func rand(x : Vector2) -> float:
	return fract(cos(x.dot(Vector2(13.9898, 8.141))) * 43758.5453);

static func rand2(x : Vector2) -> Vector2:
	return fractv2(cosv2(Vector2(x.dot(Vector2(13.9898, 8.141)),
						  x.dot(Vector2(3.4562, 17.398)))) * 43758.5453);

static func rand3(x : Vector2) -> Vector3:
	return fractv3(cosv3(Vector3(x.dot(Vector2(13.9898, 8.141)),
						  x.dot(Vector2(3.4562, 17.398)),
						  x.dot(Vector2(13.254, 5.867)))) * 43758.5453);

static func step(edge : float, x : float) -> float:
	if x < edge:
		return 0.0
	else:
		return 1.0

static func stepv2(edge : Vector2, x : Vector2) -> Vector2:
	edge.x = step(edge.x, x.x)
	edge.y = step(edge.y, x.y)
	
	return edge

static func signv2(x : Vector2) -> Vector2:
	x.x = sign(x.x)
	x.y = sign(x.y)

	return x

static func transform(uv : Vector2, translate : Vector2, rotate : float, scale : Vector2, repeat : bool) -> Vector2:
	var rv : Vector2 = Vector2();
	uv -= translate;
	uv -= Vector2(0.5, 0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += Vector2(0.5, 0.5);
	
	if (repeat):
		return fractv2(rv);
	else:
		return clampv2(rv, Vector2(0, 0), Vector2(1, 1));

static func fractf(x : float) -> float:
	return x - floor(x)

#float mix_mul(float x, float y) {
#	return x*y;
#}

static func mix_mul(x : float, y : float) -> float:
	return x*y;

#float mix_add(float x, float y) {
#	return min(x+y, 1.0);
#}

static func mix_add(x : float, y : float) -> float:
	return min(x+y, 1.0);

#float mix_max(float x, float y) {
#	return max(x, y);
#}

static func mix_max(x : float, y : float) -> float:
	return max(x, y);

#float mix_min(float x, float y) {
#	return min(x, y);
#}

static func mix_min(x : float, y : float) -> float:
	return min(x, y);

#float mix_xor(float x, float y) {
#	return min(x+y, 2.0-x-y);
#}

static func mix_xor(x : float, y : float) -> float:
	return min(x+y, 2.0-x-y);

#float mix_pow(float x, float y) {
#	return pow(x, y);
#}

static func mix_pow(x : float, y : float) -> float:
	return pow(x, y);


#float wave_constant(float x) {
#	return 1.0;
#}

static func wave_constant(x : float) -> float:
	return 1.0;

#float wave_sine(float x) {
#	return 0.5-0.5*cos(3.14159265359*2.0*x);
#}

static func wave_sine(x : float) -> float:
	return 0.5-0.5*cos(3.14159265359*2.0*x);

#float wave_triangle(float x) {
#	x = fract(x);
#	return min(2.0*x, 2.0-2.0*x);
#}

static func wave_triangle(x : float) -> float:
	x = fractf(x);
	return min(2.0*x, 2.0-2.0*x);

#float wave_sawtooth(float x) {
#	return fract(x);
#}

static func wave_sawtooth(x : float) -> float:
	return fractf(x);

#float wave_square(float x) {
#	return (fract(x) < 0.5) ? 0.0 : 1.0;
#}

static func wave_square(x : float) -> float:
	if (fractf(x) < 0.5):
		return 0.0
	else:
		return 1.0

#float wave_bounce(float x) {
#	x = 2.0*(fract(x)-0.5);
#	return sqrt(1.0-x*x);
#}

static func wave_bounce(x : float) -> float:
	x = 2.0*(fractf(x)-0.5);
	return sqrt(1.0-x*x);

static func sinewave(uv : Vector2, amplitude : float, frequency : float, phase : float) -> Color:
	var f : float = 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
	return Color(f, f, f, 1)

#from runes.mmg (old)

static func ThickLine(uv : Vector2, posA : Vector2, posB : Vector2, radiusInv : float) -> float:
	var dir : Vector2 = posA - posB;
	var dirLen : float = dir.length()
	var dirN : Vector2 = dir.normalized()
	var dotTemp : float = clamp((uv - posB).dot(dirN), 0.0, dirLen);
	var proj : Vector2 = dotTemp * dirN + posB;
	var d1 : float = (uv - proj).length()
	var finalGray : float = clamp(1.0 - d1 * radiusInv, 0.0, 1.0);
	
	return finalGray;

# ===============  BLUR.GD ===============================

#----------------------
#directional_blur.mmg

#{
#	"connections": [
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer",
#			"to_port": 0
#		},
#		{
#			"from": "buffer",
#			"from_port": 0,
#			"to": "edge_detect_3_3_2",
#			"to_port": 0
#		},
#		{
#			"from": "edge_detect_3_3_2",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 1,
#			"to": "edge_detect_3_3_2",
#			"to_port": 1
#		}
#	],
#	"label": "Directional Blur",
#	"longdesc": "Applies a directional gaussian blur to its input",
#	"name": "directional_blur",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "buffer",
#			"node_position": {
#				"x": -381.25,
#				"y": -270.75
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -436.666626,
#				"y": -413.666656
#			},
#			"parameters": {
#				"param0": 9,
#				"param1": 50,
#				"param2": 45
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Grid size:",
#					"linked_widgets": [
#						{
#							"node": "buffer",
#							"widget": "size"
#						},
#						{
#							"node": "edge_detect_3_3_2",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution of the input",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "Sigma",
#					"linked_widgets": [
#						{
#							"node": "edge_detect_3_3_2",
#							"widget": "sigma"
#						}
#					],
#					"longdesc": "The strength of the blur filter",
#					"name": "param1",
#					"shortdesc": "Sigma",
#					"type": "linked_control"
#				},
#				{
#					"label": "Angle",
#					"linked_widgets": [
#						{
#							"node": "edge_detect_3_3_2",
#							"widget": "angle"
#						}
#					],
#					"longdesc": "The angle of the directional blur effect",
#					"name": "param2",
#					"shortdesc": "Angle",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -779.666626,
#				"y": -247.392853
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input image",
#					"name": "in",
#					"shortdesc": "Input",
#					"type": "rgba"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "A map that controls the strength of the blur filter",
#					"name": "amount",
#					"shortdesc": "Strength map",
#					"type": "f"
#				}
#			],
#			"seed_value": 91624,
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": -45.452393,
#				"y": -195.392853
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "Shows the generated blurred image",
#					"name": "port0",
#					"shortdesc": "Output",
#					"type": "rgba"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "edge_detect_3_3_2",
#			"node_position": {
#				"x": -376.725464,
#				"y": -184.178955
#			},
#			"parameters": {
#				"angle": 45,
#				"sigma": 50,
#				"size": 9
#			},
#			"seed_value": -47470,
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec4(1.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgba"
#					},
#					{
#						"default": "1.0",
#						"function": true,
#						"label": "Label",
#						"name": "amount",
#						"type": "f"
#					}
#				],
#				"instance": "vec4 $(name)_fct(vec2 uv) {\n\tvec2 e = vec2(cos($angle*0.01745329251), -sin($angle*0.01745329251))/$size;\n\tvec4 rv = vec4(0.0);\n\tfloat sum = 0.0;\n\tfloat sigma = $sigma*$amount(uv);\n\tfor (float i = -50.0; i <= 50.0; i += 1.0) {\n\t\tfloat coef = exp(-0.5*(pow(i/sigma, 2.0)))/(6.28318530718*sigma*sigma);\n\t\trv += $in(uv+i*e)*coef;\n\t\tsum += coef;\n\t}\n\treturn rv/sum;\n}",
#				"name": "Directional Blur",
#				"outputs": [
#					{
#						"rgba": "$(name)_fct($uv)",
#						"type": "rgba"
#					}
#				],
#				"parameters": [
#					{
#						"default": 9,
#						"first": 4,
#						"label": "Size",
#						"last": 12,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"control": "None",
#						"default": 0.5,
#						"label": "Sigma",
#						"max": 50,
#						"min": 0,
#						"name": "sigma",
#						"step": 0.1,
#						"type": "float"
#					},
#					{
#						"control": "None",
#						"default": 0,
#						"label": "Angle",
#						"max": 180,
#						"min": -180,
#						"name": "angle",
#						"step": 0.1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		}
#	],
#	"parameters": {
#		"param0": 9,
#		"param1": 50,
#		"param2": 45
#	},
#	"shortdesc": "Directional blur",
#	"type": "graph"
#}

#----------------------
#fast_blur.mmg

#{
#	"connections": [
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "fast_blur_shader",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer_2",
#			"to_port": 0
#		},
#		{
#			"from": "fast_blur_shader",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		}
#	],
#	"label": "Fast Blur",
#	"longdesc": "",
#	"name": "fast_blur",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "fast_blur_shader",
#			"node_position": {
#				"x": -168,
#				"y": 120
#			},
#			"parameters": {
#				"quality": 1,
#				"sigma": 100
#			},
#			"type": "fast_blur_shader"
#		},
#		{
#			"name": "buffer_2",
#			"node_position": {
#				"x": -187,
#				"y": 61.5
#			},
#			"parameters": {
#				"size": 11
#			},
#			"type": "buffer",
#			"version": 1
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -602,
#				"y": 91.75
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input image",
#					"name": "input",
#					"shortdesc": "Input",
#					"type": "rgba"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 88,
#				"y": 61.75
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The generated blurred image",
#					"name": "output",
#					"shortdesc": "Output",
#					"type": "rgba"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -254.5,
#				"y": -122.5
#			},
#			"parameters": {
#				"param0": 11,
#				"param1": 100,
#				"param2": 1
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Resolution",
#					"linked_widgets": [
#						{
#							"node": "buffer_2",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution used to sample the input image",
#					"name": "param0",
#					"shortdesc": "Resolution",
#					"type": "linked_control"
#				},
#				{
#					"label": "Sigma",
#					"linked_widgets": [
#						{
#							"node": "fast_blur_shader",
#							"widget": "sigma"
#						}
#					],
#					"longdesc": "The standard deviation of the gaussian distribution",
#					"name": "param1",
#					"shortdesc": "Sigma",
#					"type": "linked_control"
#				},
#				{
#					"label": "Quality",
#					"linked_widgets": [
#						{
#							"node": "fast_blur_shader",
#							"widget": "quality"
#						}
#					],
#					"longdesc": "The quality of the effect (increasing quality increases compute time)",
#					"name": "param2",
#					"shortdesc": "Quality",
#					"type": "linked_control"
#				}
#			]
#		}
#	],
#	"parameters": {
#		"param0": 11,
#		"param1": 100,
#		"param2": 1
#	},
#	"shortdesc": "",
#	"type": "graph"
#}

#----------------------
#fast_blur_shader.mmg

#{
#	"name": "fast_blur_shader",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"parameters": {
#		"quality": 1,
#		"sigma": 100
#	},
#	"shader_model": {
#		"code": "",
#		"global": "",
#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"function": true,
#				"label": "",
#				"name": "in",
#				"type": "rgba"
#			}
#		],
#		"instance": "vec4 $(name)_blur(vec2 uv, vec2 scale, float sigma, int quality) {\n    vec4 O = vec4(0.0);\n\tfloat samples = sigma * 4.0; \n\tint LOD = max(0, int(log2(float(samples)))-quality-2);\n\tint sLOD = 1 << LOD;\n    int s = max(1, int(samples/float(sLOD)));\n\tfloat sum = 0.0;\n    for (int i = 0; i < s*s; i++) {\n        vec2 d = vec2(float(i%s), float(i/s))*float(sLOD) - 0.5*float(samples);\n\t\tvec2 dd = d / sigma;\n\t\tfloat g = exp(-.5*dot(dd,dd))/(6.28*sigma*sigma);\n        O += g * textureLod($in.texture, uv + scale * d, float(LOD));\n\t\tsum += g;\n    }\n    \n    return O / sum;\n}\n",
#		"name": "Fast Blur",
#		"outputs": [
#			{
#				"rgba": "$(name)_blur($uv, vec2(1.0)/$in.size, max(1.0, floor($sigma*$in.size/2048.0)), int($quality))",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 1,
#				"label": "",
#				"max": 256,
#				"min": 1,
#				"name": "sigma",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "",
#				"max": 3,
#				"min": 0,
#				"name": "quality",
#				"step": 1,
#				"type": "float"
#			}
#		]
#	},
#	"type": "shader"
#}

#----------------------
#gaussian_blur.mmg

#{
#	"connections": [
#		{
#			"from": "switch",
#			"from_port": 0,
#			"to": "buffer_2",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer",
#			"to_port": 0
#		},
#		{
#			"from": "switch",
#			"from_port": 0,
#			"to": "switch_2",
#			"to_port": 1
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "switch",
#			"to_port": 1
#		},
#		{
#			"from": "buffer",
#			"from_port": 0,
#			"to": "gaussian_blur_x",
#			"to_port": 0
#		},
#		{
#			"from": "gaussian_blur_x",
#			"from_port": 0,
#			"to": "switch",
#			"to_port": 0
#		},
#		{
#			"from": "gaussian_blur_y",
#			"from_port": 0,
#			"to": "switch_2",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "gaussian_blur_y",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 1,
#			"to": "gaussian_blur_x",
#			"to_port": 1
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 1,
#			"to": "gaussian_blur_y",
#			"to_port": 1
#		},
#		{
#			"from": "buffer_3",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "switch_2",
#			"from_port": 0,
#			"to": "buffer_3",
#			"to_port": 0
#		}
#	],
#	"label": "Gaussian Blur",
#	"longdesc": "Applys a gaussian blur on its input",
#	"name": "gaussian_blur",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "buffer_2",
#			"node_position": {
#				"x": -399.875,
#				"y": -43.625
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "switch",
#			"node_position": {
#				"x": -496.452393,
#				"y": -130.166656
#			},
#			"parameters": {
#				"choices": 2,
#				"outputs": 1,
#				"source": 0
#			},
#			"type": "switch"
#		},
#		{
#			"name": "switch_2",
#			"node_position": {
#				"x": -240.452393,
#				"y": -133.666656
#			},
#			"parameters": {
#				"choices": 2,
#				"outputs": 1,
#				"source": 0
#			},
#			"type": "switch"
#		},
#		{
#			"name": "buffer",
#			"node_position": {
#				"x": -402.25,
#				"y": -315.75
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -439.666626,
#				"y": -456.666656
#			},
#			"parameters": {
#				"param0": 9,
#				"param1": 50,
#				"param2": 0
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Grid size:",
#					"linked_widgets": [
#						{
#							"node": "buffer",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_2",
#							"widget": "size"
#						},
#						{
#							"node": "gaussian_blur_x",
#							"widget": "size"
#						},
#						{
#							"node": "gaussian_blur_y",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_3",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution of the input image",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "Sigma:",
#					"linked_widgets": [
#						{
#							"node": "gaussian_blur_x",
#							"widget": "sigma"
#						},
#						{
#							"node": "gaussian_blur_y",
#							"widget": "sigma"
#						}
#					],
#					"longdesc": "The strength of the blur filter",
#					"name": "param1",
#					"shortdesc": "Sigma",
#					"type": "linked_control"
#				},
#				{
#					"configurations": {
#						"Both": [
#							{
#								"node": "switch",
#								"value": 0,
#								"widget": "source"
#							},
#							{
#								"node": "switch_2",
#								"value": 0,
#								"widget": "source"
#							}
#						],
#						"X": [
#							{
#								"node": "switch",
#								"value": 0,
#								"widget": "source"
#							},
#							{
#								"node": "switch_2",
#								"value": 1,
#								"widget": "source"
#							}
#						],
#						"Y": [
#							{
#								"node": "switch",
#								"value": 1,
#								"widget": "source"
#							},
#							{
#								"node": "switch_2",
#								"value": 0,
#								"widget": "source"
#							}
#						]
#					},
#					"label": "Direction:",
#					"linked_widgets": [
#						{
#							"node": "switch",
#							"widget": "source"
#						},
#						{
#							"node": "switch_2",
#							"widget": "source"
#						}
#					],
#					"longdesc": "Apply the blur filter horizontally, vertically of in both directions",
#					"name": "param2",
#					"shortdesc": "Direction",
#					"type": "config_control"
#				}
#			]
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -928.666626,
#				"y": -188.392853
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input image",
#					"name": "input",
#					"shortdesc": "Input",
#					"type": "rgba"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "A map that controls the strength of the blur filter",
#					"name": "amount",
#					"shortdesc": "Strength map",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 193.547607,
#				"y": -135.392853
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "Shows the generated blurred image",
#					"name": "port0",
#					"shortdesc": "Output",
#					"type": "rgba"
#				}
#			],
#			"seed_value": 77778,
#			"type": "ios"
#		},
#		{
#			"name": "gaussian_blur_x",
#			"node_position": {
#				"x": -412.993408,
#				"y": -221.281738
#			},
#			"parameters": {
#				"sigma": 50,
#				"size": 9
#			},
#			"type": "gaussian_blur_x"
#		},
#		{
#			"name": "gaussian_blur_y",
#			"node_position": {
#				"x": -405.993408,
#				"y": 38.718262
#			},
#			"parameters": {
#				"sigma": 50,
#				"size": 9
#			},
#			"seed_value": 12279,
#			"type": "gaussian_blur_y"
#		},
#		{
#			"name": "buffer_3",
#			"node_position": {
#				"x": -50.246796,
#				"y": -133.96936
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		}
#	],
#	"parameters": {
#		"param0": 9,
#		"param1": 50,
#		"param2": 0
#	},
#	"shortdesc": "Gaussian blur",
#	"type": "graph"
#}

#----------------------
#gaussian_blur_x.mmg

#{
#	"name": "gaussian_blur_x",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"parameters": {
#		"sigma": 35.700001,
#		"size": 9
#	},
#	"shader_model": {
#		"code": "",
#		"global": "",
#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"function": true,
#				"label": "",
#				"name": "in",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"name": "amount",
#				"type": "f"
#			}
#		],
#		"instance": "vec4 $(name)_fct(vec2 uv) {\n\tfloat e = 1.0/$size;\n\tvec4 rv = vec4(0.0);\n\tfloat sum = 0.0;\n\tfloat sigma = max(0.000001, $sigma*$amount(uv));\n\tfor (float i = -50.0; i <= 50.0; i += 1.0) {\n\t\tfloat coef = exp(-0.5*(pow(i/sigma, 2.0)))/(6.28318530718*sigma*sigma);\n\t\trv += $in(uv+vec2(i*e, 0.0))*coef;\n\t\tsum += coef;\n\t}\n\treturn rv/sum;\n}",
#		"name": "Gaussian blur X",
#		"outputs": [
#			{
#				"rgba": "$(name)_fct($uv)",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 4,
#				"label": "Size",
#				"last": 12,
#				"name": "size",
#				"type": "size"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Sigma",
#				"max": 50,
#				"min": 0,
#				"name": "sigma",
#				"step": 0.1,
#				"type": "float"
#			}
#		]
#	},
#	"type": "shader"
#}

#----------------------
#gaussian_blur_y.mmg

#{
#	"name": "gaussian_blur_y",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"parameters": {
#		"sigma": 35.700001,
#		"size": 9
#	},
#	"shader_model": {
#		"code": "",
#		"global": "",
#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"function": true,
#				"label": "",
#				"name": "in",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"name": "amount",
#				"type": "f"
#			}
#		],
#		"instance": "vec4 $(name)_fct(vec2 uv) {\n\tfloat e = 1.0/$size;\n\tvec4 rv = vec4(0.0);\n\tfloat sum = 0.0;\n\tfloat sigma = max(0.000001, $sigma*$amount(uv));\n\tfor (float i = -50.0; i <= 50.0; i += 1.0) {\n\t\tfloat coef = exp(-0.5*(pow(i/sigma, 2.0)))/(6.28318530718*sigma*sigma);\n\t\trv += $in(uv+vec2(0.0, i*e))*coef;\n\t\tsum += coef;\n\t}\n\treturn rv/sum;\n}",
#		"name": "Gaussian blur Y",
#		"outputs": [
#			{
#				"rgba": "$(name)_fct($uv)",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 4,
#				"label": "Size",
#				"last": 12,
#				"name": "size",
#				"type": "size"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Sigma",
#				"max": 50,
#				"min": 0,
#				"name": "sigma",
#				"step": 0.1,
#				"type": "float"
#			}
#		]
#	},
#	"type": "shader"
#}


#----------------------
#slope_blur.mmg

#{
#	"connections": [
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer",
#			"to_port": 0
#		},
#		{
#			"from": "buffer",
#			"from_port": 0,
#			"to": "edge_detect_3_3_2",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 1,
#			"to": "edge_detect_3_3_2",
#			"to_port": 1
#		},
#		{
#			"from": "edge_detect_3_3_2",
#			"from_port": 0,
#			"to": "buffer_2",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		}
#	],
#	"label": "Slope Blur",
#	"longdesc": "Applys a blur effect on its input, following slopes of an input height map",
#	"name": "slope_blur",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "buffer",
#			"node_position": {
#				"x": -395.25,
#				"y": -274.75
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 10
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -462.666626,
#				"y": -397.666656
#			},
#			"parameters": {
#				"param0": 10,
#				"param1": 30
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Grid size:",
#					"linked_widgets": [
#						{
#							"node": "buffer",
#							"widget": "size"
#						},
#						{
#							"node": "edge_detect_3_3_2",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_2",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution of the input image",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "Sigma",
#					"linked_widgets": [
#						{
#							"node": "edge_detect_3_3_2",
#							"widget": "sigma"
#						}
#					],
#					"longdesc": "The strength of the blur filter",
#					"name": "param1",
#					"shortdesc": "Sigma",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -872.666626,
#				"y": -243.392853
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input image",
#					"name": "in",
#					"shortdesc": "Input",
#					"type": "rgba"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "A height map whose slopes control the strength and direction of the blur filter",
#					"name": "heightmap",
#					"shortdesc": "Height map",
#					"type": "f"
#				}
#			],
#			"seed_value": 91624,
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": -45.452393,
#				"y": -195.392853
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "Shows the generated blurred image",
#					"name": "port0",
#					"shortdesc": "Output",
#					"type": "rgba"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "edge_detect_3_3_2",
#			"node_position": {
#				"x": -401.725464,
#				"y": -199.178955
#			},
#			"parameters": {
#				"sigma": 30,
#				"size": 10
#			},
#			"seed_value": -47470,
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec4(1.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgba"
#					},
#					{
#						"default": "1.0",
#						"function": true,
#						"label": "",
#						"name": "heightmap",
#						"type": "f"
#					}
#				],
#				"instance": "vec4 $(name)_fct(vec2 uv) {\n\tfloat dx = 1.0/$size;\n    float v = $heightmap(uv);\n\tvec2 slope = vec2($heightmap(uv+vec2(dx, 0.0))-v, $heightmap(uv+vec2(0.0, dx))-v);\n\tfloat slope_strength = length(slope)*$size;\n    vec2 norm_slope =  (slope_strength == 0.0) ? vec2(0.0, 1.0) : normalize(slope);\n    vec2 e = dx*norm_slope;\n\tvec4 rv = vec4(0.0);\n\tfloat sum = 0.0;\n\tfloat sigma = max($sigma*slope_strength, 0.0001);\n\tfor (float i = 0.0; i <= 50.0; i += 1.0) {\n\t\tfloat coef = exp(-0.5*(pow(i/sigma, 2.0)))/(6.28318530718*sigma*sigma);\n\t\trv += $in(uv+i*e)*coef;\n\t\tsum += coef;\n\t}\n\treturn rv/sum;\n}",
#				"name": "Slope Blur",
#				"outputs": [
#					{
#						"rgba": "$(name)_fct($uv)",
#						"type": "rgba"
#					}
#				],
#				"parameters": [
#					{
#						"default": 9,
#						"first": 4,
#						"label": "Size",
#						"last": 12,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"control": "None",
#						"default": 0.5,
#						"label": "Sigma",
#						"max": 50,
#						"min": 0,
#						"name": "sigma",
#						"step": 0.1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "buffer_2",
#			"node_position": {
#				"x": -392.952209,
#				"y": -115.576294
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 10
#			},
#			"type": "buffer"
#		}
#	],
#	"parameters": {
#		"param0": 10,
#		"param1": 30
#	},
#	"shortdesc": "Slope blur",
#	"type": "graph"
#}

# ============= CURVES.GD ======================


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

# =============  DILATE.GD ==============


#----------------------
#dilate.mmg

#{
#	"connections": [
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer",
#			"to_port": 0
#		},
#		{
#			"from": "buffer",
#			"from_port": 0,
#			"to": "dilate_pass_1",
#			"to_port": 0
#		},
#		{
#			"from": "dilate_pass_1",
#			"from_port": 0,
#			"to": "buffer_2",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "dilate_pass_4",
#			"to_port": 0
#		},
#		{
#			"from": "dilate_pass_3",
#			"from_port": 0,
#			"to": "buffer_2_3",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2_3",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2_2",
#			"from_port": 0,
#			"to": "dilate_pass_3",
#			"to_port": 1
#		},
#		{
#			"from": "dilate_pass_4",
#			"from_port": 0,
#			"to": "dilate_pass_3",
#			"to_port": 0
#		},
#		{
#			"from": "default_color",
#			"from_port": 0,
#			"to": "buffer_2_2",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 1,
#			"to": "default_color",
#			"to_port": 0
#		}
#	],
#	"label": "Dilate",
#	"longdesc": "Dilates the white areas of a mask, using the colors of an optional input",
#	"name": "dilate",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "buffer",
#			"node_position": {
#				"x": -473.691315,
#				"y": -200.988342
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "buffer_2",
#			"node_position": {
#				"x": -255.691315,
#				"y": -123.988342
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -140.306458,
#				"y": -377.953613
#			},
#			"parameters": {
#				"param0": 9,
#				"param1": 0.1,
#				"param2": 0,
#				"param3": 0
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "buffer",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_2",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_2_2",
#							"widget": "size"
#						},
#						{
#							"node": "dilate_pass_1",
#							"widget": "s"
#						},
#						{
#							"node": "dilate_pass_4",
#							"widget": "s"
#						},
#						{
#							"node": "buffer_2_3",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution of the input images",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "dilate_pass_1",
#							"widget": "d"
#						},
#						{
#							"node": "dilate_pass_4",
#							"widget": "d"
#						}
#					],
#					"longdesc": "The length of the dilate effect",
#					"name": "param1",
#					"shortdesc": "Length",
#					"type": "linked_control"
#				},
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "dilate_pass_3",
#							"widget": "amount"
#						}
#					],
#					"longdesc": "0 to generate a gradient to black while dilating, 1 to fill with input color",
#					"name": "param2",
#					"shortdesc": "Fill",
#					"type": "linked_control"
#				},
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "dilate_pass_4",
#							"widget": "distance"
#						}
#					],
#					"name": "param3",
#					"shortdesc": "Distance function",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -872.306458,
#				"y": -171.4814
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input mask whose white areas will be dilated",
#					"name": "mask",
#					"shortdesc": "Mask",
#					"type": "f"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "The optional source for colors",
#					"name": "source",
#					"shortdesc": "Source",
#					"type": "rgb"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 254.21106,
#				"y": -64.4814
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "Shows the dilated image",
#					"name": "out",
#					"shortdesc": "Output",
#					"type": "rgb"
#				}
#			],
#			"seed_value": -14401,
#			"type": "ios"
#		},
#		{
#			"name": "buffer_2_2",
#			"node_position": {
#				"x": -255.323547,
#				"y": -44.695679
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "dilate_pass_1",
#			"node_position": {
#				"x": -252.698792,
#				"y": -201.368988
#			},
#			"parameters": {
#				"d": 0.1,
#				"s": 9
#			},
#			"seed_value": 71939,
#			"type": "dilate_pass_1"
#		},
#		{
#			"name": "dilate_pass_3",
#			"node_position": {
#				"x": -31.698792,
#				"y": -72.368988
#			},
#			"parameters": {
#				"amount": 0
#			},
#			"type": "dilate_pass_3"
#		},
#		{
#			"name": "dilate_pass_4",
#			"node_position": {
#				"x": -31.689392,
#				"y": -186.577301
#			},
#			"parameters": {
#				"d": 0.1,
#				"distance": 0,
#				"s": 9
#			},
#			"type": "dilate_pass_2"
#		},
#		{
#			"name": "buffer_2_3",
#			"node_position": {
#				"x": -46.966125,
#				"y": -0.711548
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "default_color",
#			"node_position": {
#				"x": -469.868713,
#				"y": -98.02066
#			},
#			"parameters": {
#				"default": {
#					"a": 1,
#					"b": 1,
#					"g": 1,
#					"r": 1,
#					"type": "Color"
#				}
#			},
#			"type": "default_color"
#		}
#	],
#	"parameters": {
#		"param0": 9,
#		"param1": 0.1,
#		"param2": 0,
#		"param3": 0
#	},
#	"shortdesc": "Dilate",
#	"type": "graph"
#}

#----------------------
#dilate_pass_1.mmg

#{
#	"name": "distance_pass_1",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"parameters": {
#		"d": 0.1,
#		"s": 9
#	},
#	"seed_value": 8258,
#	"shader_model": {
#		"code": "",
#		"global": "",
#		"inputs": [
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"name": "in",
#				"type": "f"
#			}
#		],
#		"instance": "vec3 $(name)_distance_h(vec2 uv) {\n\tvec2 e = vec2(1.0/$s, 0.0);\n\tint steps = int($s*$d);\n\tfloat rv = 0.0;\n\tvec2 source_uv;\n\tfor (int i = 0; i < steps; ++i) {\n\t\tsource_uv = uv+float(i)*e;\n\t\tif ($in(source_uv) > 0.5) {\n\t\t\trv = 1.0-float(i)*e.x/$d;\n\t\t\tbreak;\n\t\t}\n\t\tsource_uv = uv-float(i)*e;\n\t\tif ($in(source_uv) > 0.5) {\n\t\t\trv = 1.0-float(i)*e.x/$d;\n\t\t\tbreak;\n\t\t}\n\t}\n\treturn vec3(rv, source_uv);\n}\n",
#		"name": "Distance pass 1",
#		"outputs": [
#			{
#				"rgb": "$(name)_distance_h($uv)",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 6,
#				"label": "",
#				"last": 12,
#				"name": "s",
#				"type": "size"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "",
#				"max": 1,
#				"min": 0,
#				"name": "d",
#				"step": 0.01,
#				"type": "float"
#			}
#		]
#	},
#	"type": "shader"
#}

#----------------------
#dilate_pass_2.mmg

#{
#	"name": "dilate_pass_2",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"parameters": {
#		"d": 0.25,
#		"distance": 0,
#		"s": 9
#	},
#	"seed_value": 44978,
#	"shader_model": {
#		"code": "",
#		"global": "float dilate_distance_euclidian(float x, float y, float d) {\n\treturn 1.0-sqrt((1.0-x)*(1.0-x)+y*y/d/d);\n}\n\nfloat dilate_distance_manhattan(float x, float y, float d) {\n\treturn 1.0-(abs(1.0-x)+abs(y)/d);\n}\n\nfloat dilate_distance_chebyshev(float x, float y, float d) {\n\treturn 1.0-max(abs(1.0-x), abs(y)/d);\n}\n\n",
#		"inputs": [
#			{
#				"default": "vec3(0.0)",
#				"function": true,
#				"label": "",
#				"name": "in",
#				"type": "rgb"
#			}
#		],
#		"instance": "vec3 $(name)_distance_v(vec2 uv) {\n\tvec2 e = vec2(0.0, 1.0/$s);\n\tint steps = int($s*$d);\n\tvec3 p = $in(uv);\n\tfor (int i = 0; i < steps; ++i) {\n\t\tvec2 dx = float(i)*e;\n\t\tvec3 p2 = $in(uv+dx);\n\t\tif (p2.x > p.x) {\n\t\t\tp2.x = dilate_distance_$distance(p2.x, dx.y, $d);\n\t\t\tp = mix(p, p2, step(p.x, p2.x));\n\t\t}\n\t\tp2 = $in(uv-dx);\n\t\tif (p2.x > p.x) {\n\t\t\tp2.x = dilate_distance_$distance(p2.x, dx.y, $d);\n\t\t\tp = mix(p, p2, step(p.x, p2.x));\n\t\t}\n\t}\n\treturn p;\n}\n",
#		"name": "Distance pass 2",
#		"outputs": [
#			{
#				"rgb": "$(name)_distance_v($uv)",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 6,
#				"label": "",
#				"last": 12,
#				"name": "s",
#				"type": "size"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "",
#				"max": 1,
#				"min": 0,
#				"name": "d",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": 2,
#				"label": "",
#				"name": "distance",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Euclidian",
#						"value": "euclidian"
#					},
#					{
#						"name": "Manhattan",
#						"value": "manhattan"
#					},
#					{
#						"name": "Chebyshev",
#						"value": "chebyshev"
#					}
#				]
#			}
#		]
#	},
#	"type": "shader"
#}

#----------------------
#dilate_pass_3.mmg

#{
#	"name": "distance_pass_3",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"parameters": {
#		"amount": 0
#	},
#	"shader_model": {
#		"code": "",
#		"global": "",
#		"inputs": [
#			{
#				"default": "vec3(0.0)",
#				"label": "",
#				"name": "distance",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(1.0)",
#				"label": "",
#				"name": "source",
#				"type": "rgb"
#			}
#		],
#		"instance": "",
#		"name": "Distance pass 3",
#		"outputs": [
#			{
#				"rgb": "$source($distance($uv).yz)*mix($distance($uv).x, 1.0, $amount)",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"max": 1,
#				"min": 0,
#				"name": "amount",
#				"step": 0.01,
#				"type": "float"
#			}
#		]
#	},
#	"type": "shader"
#}

# ==========  EDGE_DETECT.GD =============


#----------------------
#edge_detect.mmg
#An edge detect filter that detects edges along all directions and draws them in white on a black background

#		"inputs": [
#			{
#				"default": "vec3(0.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgb"
#			}
#		],
#		"instance": "float $(name)_fct(vec2 uv) {\n\tvec3 e_base = vec3(1.0/$size, -1.0/$size, 0);\n\tvec3 ref = $in(uv);\n\tvec3 e = vec3(0);\n\tfloat rv = 0.0;\n\tfor (int i = 0; i < int($width); ++i) {\n\t\te += e_base;\n\t\trv += length($in(uv+e.xy)-ref);\n\t\trv += length($in(uv-e.xy)-ref);\n\t\trv += length($in(uv+e.xx)-ref);\n\t\trv += length($in(uv-e.xx)-ref);\n\t\trv += length($in(uv+e.xz)-ref);\n\t\trv += length($in(uv-e.xz)-ref);\n\t\trv += length($in(uv+e.zx)-ref);\n\t\trv += length($in(uv-e.zx)-ref);\n\t\trv *= 2.0;\n\t}\n\treturn rv*pow(2.0, -$width);\n}",
#		"outputs": [
#			{
#				"f": "clamp(100.0*($(name)_fct($uv)-$threshold), 0.0, 1.0)",
#				"longdesc": "Shows the generated outlines",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 4,
#				"label": "Size",
#				"last": 12,
#				"longdesc": "The resolution of the input image",
#				"name": "size",
#				"shortdesc": "Size",
#				"type": "size"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Width",
#				"max": 5,
#				"min": 1,
#				"name": "width",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Threshold",
#				"max": 1,
#				"min": 0,
#				"name": "threshold",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#edge_detect_1.mmg
#An edge detect filter that detects edges along all directions and draws them in white on a black background

#		"inputs": [
#			{
#				"default": "vec3(0.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgb"
#			}
#		],
#		"instance": "float $(name)_fct(vec2 uv) {\n\tvec3 e = vec3(1.0/$size, -1.0/$size, 0);\n\tvec3 rv = 8.0*$in(uv);\n\trv -= $in(uv+e.xy);\n\trv -= $in(uv-e.xy);\n\trv -= $in(uv+e.xx);\n\trv -= $in(uv-e.xx);\n\trv -= $in(uv+e.xz);\n\trv -= $in(uv-e.xz);\n\trv -= $in(uv+e.zx);\n\trv -= $in(uv-e.zx);\n\trv = abs(rv);\n\treturn max(rv.x, max(rv.y ,rv.z))*$size;\n}",
#		"outputs": [
#			{
#				"f": "clamp($(name)_fct($uv), 0.0, 1.0)",
#				"longdesc": "Shows the generated outlines",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 4,
#				"label": "Size",
#				"last": 12,
#				"longdesc": "The resolution of the input image",
#				"name": "size",
#				"shortdesc": "Size",
#				"type": "size"
#			}
#		],

#----------------------
#edge_detect_2.mmg
#An edge detect filter that detects edges horizontally and vertically and draws them in white on a black background

#		"inputs": [
#			{
#				"default": "vec3(0.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgb"
#			}
#		],
#		"instance": "float $(name)_fct(vec2 uv) {\n\tvec2 e = vec2(1.0/$size, 0.0);\n\tvec3 rv = 4.0*$in(uv);\n\trv -= $in(uv+e.xy);\n\trv -= $in(uv-e.xy);\n\trv -= $in(uv+e.yx);\n\trv -= $in(uv-e.yx);\n\trv = abs(rv);\n\treturn max(rv.x, max(rv.y ,rv.z))*$size;\n}",
#		"outputs": [
#			{
#				"f": "clamp($(name)_fct($uv), 0.0, 1.0)",
#				"longdesc": "Shows the generated outlines",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 4,
#				"label": "Size",
#				"last": 12,
#				"longdesc": "The resolution of the input image",
#				"name": "size",
#				"shortdesc": "Size",
#				"type": "size"
#			}
#		],

#----------------------
#edge_detect_3.mmg
#An edge detect filter that detects edges along diagonals and draws them in white on a black background

#		"inputs": [
#			{
#				"default": "vec3(0.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgb"
#			}
#		],
#		"instance": "float $(name)_fct(vec2 uv) {\n\tvec2 e = vec2(1.0/$size, -1.0/$size);\n\tvec3 rv = 4.0*$in(uv);\n\trv -= $in(uv+e.xy);\n\trv -= $in(uv-e.xy);\n\trv -= $in(uv+e.xx);\n\trv -= $in(uv-e.xx);\n\trv = abs(rv);\n\treturn max(rv.x, max(rv.y ,rv.z))*$size;\n}",
#		"outputs": [
#			{
#				"f": "clamp($(name)_fct($uv), 0.0, 1.0)",
#				"longdesc": "Shows the generated outlines",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 4,
#				"label": "Size",
#				"last": 12,
#				"longdesc": "The resolution of the input image",
#				"name": "size",
#				"shortdesc": "Size",
#				"type": "size"
#			}
#		],

#----------------------
#mul_detect.mmg

#		"code": "float $(name_uv)_d = ($in($uv)-$v)/$t;",
#		"global": "",
#		"inputs": [
#			{
#				"default": "1.0",
#				"label": "",
#				"name": "mul",
#				"type": "f"
#			},
#			{
#				"default": "0.0",
#				"label": "",
#				"name": "in",
#				"type": "f"
#			}
#		],
#		"instance": "",
#		"name": "MulDetect",
#		"outputs": [
#			{
#				"f": "$mul($uv)*clamp(1.0-$(name_uv)_d*$(name_uv)_d, 0.0, 1.0)",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Value",
#				"max": 1,
#				"min": 0,
#				"name": "v",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Tolerance",
#				"max": 1,
#				"min": 0.01,
#				"name": "t",
#				"step": 0.001,
#				"type": "float"
#			}
#		]
		
# ================ FILLS.GD ============


#----------------------
#fill.mmg
#Fills areas defined by white outlines of its input

#{
#	"connections": [
#		{
#			"from": "iterate_buffer",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "iterate_buffer",
#			"from_port": 1,
#			"to": "fill_iterate",
#			"to_port": 0
#		},
#		{
#			"from": "fill_iterate",
#			"from_port": 0,
#			"to": "iterate_buffer",
#			"to_port": 1
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "fill_preprocess",
#			"to_port": 0
#		},
#		{
#			"from": "fill_preprocess",
#			"from_port": 0,
#			"to": "iterate_buffer",
#			"to_port": 0
#		}
#	],
#	"nodes": [
#		{
#			"name": "iterate_buffer",
#			"node_position": {
#				"x": -129.307083,
#				"y": -370.480591
#			},
#			"parameters": {
#				"iterations": 10,
#				"size": 8
#			},
#			"seed_value": 29168,
#			"type": "iterate_buffer"
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -542.307068,
#				"y": -370.662445
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input image whose white outlines must be filled",
#					"name": "port0",
#					"shortdesc": "Input",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 198.267258,
#				"y": -362.662445
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "Generates fill data, to be connected to a fill companion node",
#					"name": "port0",
#					"shortdesc": "Output",
#					"type": "rgba"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -171.110138,
#				"y": -541.509705
#			},
#			"parameters": {
#				"param0": 8,
#				"param1": 10
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "iterate_buffer",
#							"widget": "size"
#						},
#						{
#							"node": "fill_preprocess",
#							"widget": "s"
#						},
#						{
#							"node": "fill_iterate",
#							"widget": "s"
#						}
#					],
#					"longdesc": "The resolution of the inptu image",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "iterate_buffer",
#							"widget": "iterations"
#						}
#					],
#					"longdesc": "The number of iterations of the algorithm. The optimal value depends a lot on the input image.",
#					"name": "param1",
#					"shortdesc": "Iterations",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "fill_iterate",
#			"node_position": {
#				"x": -92.913391,
#				"y": -290.886963
#			},
#			"parameters": {
#				"s": 8
#			},
#			"type": "fill_iterate"
#		},
#		{
#			"name": "fill_preprocess",
#			"node_position": {
#				"x": -110.443481,
#				"y": -427.202026
#			},
#			"parameters": {
#				"s": 8
#			},
#			"type": "fill_preprocess"
#		}
#	],
#	"parameters": {
#		"param0": 8,
#		"param1": 10
#	},
#	"shortdesc": "Fill",
#	"type": "graph"
#}

#----------------------
#fill_iterate.mmg

#		"inputs": [
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"name": "in",
#				"type": "rgba"
#			}
#		],
#		"instance": "vec4 $(name)_fill(vec2 uv) {\n\tfloat size = $s;\n\tint iterations = min(int(size), 256);\n\tvec4 color = $in(fract(uv));\n\tif (color.z+color.w < 1.0/size) {\n\t\treturn vec4(0.0);\n\t}\n\tvec2 offsets[8] = { vec2(1.0, 0.0), vec2(-1.0, 0.0), vec2(0.0, 1.0), vec2(0.0, -1.0), vec2(1.0, 1.0), vec2(-1.0, 1.0), vec2(-1.0, 1.0), vec2(-1.0, -1.0) };\n\tfor (int o = 0; o < 8; ++o) {\n\t\tvec2 uv2 = uv;\n\t\tvec2 offset = offsets[o]/size;\n\t\tfor (int i = 1; i < iterations; i += 1) {\n\t\t\tuv2 += offset;\n\t\t\tvec4 color2 = $in(fract(uv2));\n\t\t\tif (color2.z+color2.w == 0.0) {\n\t\t\t\tbreak;\n\t\t\t}\n\t\t\tvec2 p1 = color.xy+floor(uv-color.xy);\n\t\t\tvec2 p2 = color2.xy+floor(uv2-color2.xy);\n\t\t\tvec2 p = min(p1, p2);\n\t\t\tvec2 s = max(p1+color.zw, p2+color2.zw)-p;\n\t\t\tcolor = mix(vec4(0.0, 0.0, 1.0, 1.0), vec4(fract(p), s), step(s.xyxy, vec4(1.0)));\n\t\t}\n\t}\n\treturn floor(color*size)/size;\n}\n",
#		"outputs": [
#			{
#				"rgba": "$(name)_fill($uv)",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 6,
#				"label": "",
#				"last": 12,
#				"name": "s",
#				"type": "size"
#			}
#		]

#----------------------
#fill_preprocess.mmg

#		"inputs": [
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"name": "in",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"rgba": "flood_fill_preprocess($uv, $in($uv), $s)",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 10,
#				"first": 0,
#				"label": "",
#				"last": 12,
#				"name": "s",
#				"type": "size"
#			}
#		]




#----------------------
#fill_to_color.mmg
#A fill companion node that fills each area with a color taken from a color map image

#		"code": "vec4 $(name_uv)_bb = $in($uv);",
#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The input fill data, to be connected to the output of a Fill node",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(1.0)",
#				"label": "",
#				"longdesc": "The image from which colors are taken",
#				"name": "map",
#				"shortdesc": "Color map",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated output image",
#				"rgba": "mix($edgecolor, $map(fract($(name_uv)_bb.xy+0.5*$(name_uv)_bb.zw)), step(0.0000001, dot($(name_uv)_bb.zw, vec2(1.0))))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"a": 1,
#					"b": 1,
#					"g": 1,
#					"r": 1
#				},
#				"label": "Edge Color",
#				"longdesc": "The color used to draw outlines",
#				"name": "edgecolor",
#				"shortdesc": "Outline color",
#				"type": "color"
#			}
#		],

#----------------------
#fill_to_position.mmg
#A fill companion node that fills each area with a greyscale value that depends on its position

#		"code": "vec2 $(name_uv)_c = fract($in($uv).xy+0.5*$in($uv).zw);",
#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The input fill data, to be connected to the output of a Fill node",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$axis",
#				"longdesc": "The generated output image",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 2,
#				"label": "",
#				"longdesc": "The position value to be used:\n- X for horizontal axis\n- Y for vertical axis\n- Radial for distance to center",
#				"name": "axis",
#				"shortdesc": "Position",
#				"type": "enum",
#				"values": [
#					{
#						"name": "X",
#						"value": "$(name_uv)_c.x"
#					},
#					{
#						"name": "Y",
#						"value": "$(name_uv)_c.y"
#					},
#					{
#						"name": "Radial",
#						"value": "length($(name_uv)_c-vec2(0.5))"
#					}
#				]
#			}
#		],

#----------------------
#fill_to_random_color.mmg
#A fill companion node that fills each area with a random color

#		"code": "vec4 $(name_uv)_bb = $in($uv);",
#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The input fill data, to be connected to the output of a Fill node",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated output image",
#				"rgb": "mix($edgecolor.rgb, rand3(vec2(float($seed), rand(vec2(rand($(name_uv)_bb.xy), rand($(name_uv)_bb.zw))))), step(0.0000001, dot($(name_uv)_bb.zw, vec2(1.0))))",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"a": 1,
#					"b": 1,
#					"g": 1,
#					"r": 1
#				},
#				"label": "Edge Color",
#				"longdesc": "The color used for outlines",
#				"name": "edgecolor",
#				"shortdesc": "Outline color",
#				"type": "color"
#			}
#		],

#----------------------
#fill_to_random_grey.mmg
#A fill companion node that fills each area with a random greyscale value

#		"code": "vec4 $(name_uv)_bb = $in($uv);",
#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The input fill data, to be connected to the output of a Fill node",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"f": "mix($edgecolor, rand(vec2(float($seed), rand(vec2(rand($(name_uv)_bb.xy), rand($(name_uv)_bb.zw))))), step(0.0000001, dot($(name_uv)_bb.zw, vec2(1.0))))",
#				"longdesc": "The generated output image",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Edge color",
#				"longdesc": "The value used for the outlines",
#				"max": 1,
#				"min": 0,
#				"name": "edgecolor",
#				"shortdesc": "Outline color",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#fill_to_size.mmg
#A fill companion node that fills each area with a greyscale value that depends on its size

#		"code": "vec4 $(name_uv)_bb = $in($uv);",
#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The input fill data, to be connected to the output of a Fill node",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$formula",
#				"longdesc": "The generated output image",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "The size value to be used (area, width, height or maximum between width and height)",
#				"name": "formula",
#				"shortdesc": "Size",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Area",
#						"value": "sqrt($(name_uv)_bb.z*$(name_uv)_bb.w)"
#					},
#					{
#						"name": "Width",
#						"value": "$(name_uv)_bb.z"
#					},
#					{
#						"name": "Height",
#						"value": "$(name_uv)_bb.w"
#					},
#					{
#						"name": "max(W, H)",
#						"value": "max($(name_uv)_bb.z, $(name_uv)_bb.w)"
#					}
#				]
#			}
#		],

#----------------------
#fill_to_uv.mmg
#A fill companion node that generated an UV map that follows each filled area

#		"code": "vec4 $(name_uv)_bb = $in($uv);",
#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The input fill data, to be connected to the output of a Fill node",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated output UV map, to be connected to a Custom UV node",
#				"rgb": "fill_to_uv_$mode($uv, $(name_uv)_bb, float($seed))",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "The mode decides how the UVs are layed out on each bounding box:\n- Stretch mode where the UV layout is stretched to the bounding box. \n- Square mode where the UV layout is even and centerered based on the longest axis of the bounding box.",
#				"name": "mode",
#				"shortdesc": "Mode",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Stretch",
#						"value": "stretch"
#					},
#					{
#						"name": "Square",
#						"value": "square"
#					}
#				]
#			}
#		],

#vec4 flood_fill_preprocess(vec2 uv, float c, float s) {
#	if (c > 0.5) {
#		return vec4(0.0);
#	} else {
#		return vec4(floor(uv*s)/s, vec2(1.0/s));
#	}
#}

static func flood_fill_preprocess(uv : Vector2, c : float, s : float) -> Color:
	if (c > 0.5):
		return Color(0, 0, 0, 0)
	else:
		uv = floorv2(uv * s) / s
		var f : float = 1.0 / s
		return Color(uv.x, uv.y, f, f)

#vec3 fill_to_uv_stretch(vec2 coord, vec4 bb, float seed) {
#	vec2 uv_islands = fract(coord-bb.xy)/bb.zw;
#	float random_value = rand(vec2(seed)+bb.xy+bb.zw);
#	return vec3(uv_islands, random_value);
#}

static func fill_to_uv_stretch(coord : Vector2, bb : Color, pseed : float) -> Vector3:
	var uv_islands : Vector2 = fractv2(coord - Vector2(bb.r, bb.g)) / Vector2(bb.b, bb.a)
	var random_value : float = rand(Vector2(pseed, pseed) + Vector2(bb.r, bb.g) + Vector2(bb.b, bb.a))
	return Vector3(uv_islands.x, uv_islands.y, random_value)
	
#vec3 fill_to_uv_square(vec2 coord, vec4 bb, float seed) {
#	vec2 uv_islands;
#
#	if (bb.z > bb.w) {
#		vec2 adjusted_coord = coord + vec2(0.0, (bb.z - bb.w) / 2.0);
#		uv_islands = fract(adjusted_coord-bb.xy)/bb.zz;
#	} else {
#		vec2 adjusted_coord = coord + vec2((bb.w - bb.z) / 2.0, 0.0);
#		uv_islands = fract(adjusted_coord-bb.xy)/bb.ww;
#	}
#
#	float random_value = rand(vec2(seed)+bb.xy+bb.zw);
#	return vec3(uv_islands, random_value);
#}

static func fill_to_uv_square(coord : Vector2, bb : Color, pseed : float) -> Vector3:
	var uv_islands : Vector2 = Vector2()

	if (bb.b > bb.a):
		var adjusted_coord : Vector2 = coord + Vector2(0.0, (bb.b - bb.a) / 2.0);
		uv_islands = fractv2(adjusted_coord - Vector2(bb.r, bb.g)) / Vector2(bb.b, bb.b)
	else:
		var adjusted_coord : Vector2 = coord + Vector2((bb.a - bb.b) / 2.0, 0.0);
		uv_islands = fractv2(adjusted_coord - Vector2(bb.r, bb.g)) / Vector2(bb.a, bb.a)

	var random_value : float = rand(Vector2(pseed, pseed) + Vector2(bb.r, bb.g) + Vector2(bb.b, bb.a))
	return Vector3(uv_islands.x, uv_islands.y, random_value)

#====== FILTER.GD ======


#adjust_hsv.mmg
#brightness_contrast.mmg
#greyscale.mmg

#main node methods: adjust_hsv, brightness_contrast

#----------------------
#colorize.mmg
#Remaps a greyscale image to a custom gradient

#Inputs:
#input, float, $uv.x - The input greyscale image - (Image input)

#Outputs:
#output (rgba) $gradient($input($uv)) - Image output

#Parameters:
#gradient, Gradient 

#----------------------
#default_color.mmg

#		"inputs": [
#			{
#				"default": "$default",
#				"label": "",
#				"name": "in",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"rgba": "$in($uv)",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"a": 1,
#					"b": 1,
#					"g": 1,
#					"r": 1
#				},
#				"label": "",
#				"name": "default",
#				"type": "color"
#			}
#		]

#----------------------
#decompose.mmg
#Decomposes an RGBA input into 4 greyscale images

#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"label": "",
#				"longdesc": "The RGBA input image",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$i($uv).r",
#				"longdesc": "Shows the Red channel of the input",
#				"shortdesc": "Red",
#				"type": "f"
#			},
#			{
#				"f": "$i($uv).g",
#				"longdesc": "Shows the Green channel of the input",
#				"shortdesc": "Green",
#				"type": "f"
#			},
#			{
#				"f": "$i($uv).b",
#				"longdesc": "Shows the Blue channel of the input",
#				"shortdesc": "Blue",
#				"type": "f"
#			},
#			{
#				"f": "$i($uv).a",
#				"longdesc": "Shows the Alpha channel of the input",
#				"shortdesc": "Alpha",
#				"type": "f"
#			}
#		],

#----------------------
#auto_tones.mmg

#{
#	"connections": [
#		{
#			"from": "graph",
#			"from_port": 0,
#			"to": "tones_map",
#			"to_port": 1
#		},
#		{
#			"from": "graph",
#			"from_port": 1,
#			"to": "tones_map",
#			"to_port": 2
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "graph",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "tones_map",
#			"to_port": 0
#		},
#		{
#			"from": "tones_map",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		}
#	],
#	"label": "Auto Tones",
#	"longdesc": "Finds the minimum and maximum values in the input texture and tone maps it to the full 0.0 - 1.0 range.",
#	"name": "auto_tones",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"connections": [
#				{
#					"from": "combine",
#					"from_port": 0,
#					"to": "iterate_buffer",
#					"to_port": 0
#				},
#				{
#					"from": "decompose",
#					"from_port": 0,
#					"to": "gen_outputs",
#					"to_port": 0
#				},
#				{
#					"from": "decompose",
#					"from_port": 1,
#					"to": "gen_outputs",
#					"to_port": 1
#				},
#				{
#					"from": "iterate_buffer",
#					"from_port": 0,
#					"to": "decompose",
#					"to_port": 0
#				},
#				{
#					"from": "iterate_buffer",
#					"from_port": 1,
#					"to": "14423",
#					"to_port": 0
#				},
#				{
#					"from": "14423",
#					"from_port": 0,
#					"to": "iterate_buffer",
#					"to_port": 1
#				},
#				{
#					"from": "gen_inputs",
#					"from_port": 0,
#					"to": "combine",
#					"to_port": 0
#				},
#				{
#					"from": "gen_inputs",
#					"from_port": 0,
#					"to": "combine",
#					"to_port": 1
#				}
#			],
#			"label": "Find Min Max",
#			"longdesc": "",
#			"name": "graph",
#			"node_position": {
#				"x": 1105.399902,
#				"y": -179.398849
#			},
#			"nodes": [
#				{
#					"name": "14423",
#					"node_position": {
#						"x": 344,
#						"y": 217
#					},
#					"parameters": {
#						"size": 10
#					},
#					"shader_model": {
#						"code": "",
#						"global": "",
#						"inputs": [
#							{
#								"default": "vec3(0.0)",
#								"function": true,
#								"label": "",
#								"name": "in",
#								"type": "rgb"
#							}
#						],
#						"instance": "vec3 $(name)_compare(vec2 uv, float size) {\n\tfloat iter = $in(uv).b;\n\tsize = size / pow(2.0, (iter * 100.0) );\n\titer += 0.01;\n\tfloat pixel_offset = 1.0 / size;\n\tvec2 half_res_uv = floor(uv * size / 2.0) / size * 2.0 + pixel_offset / 2.0;\n\tvec3 values[4];\n\tvalues[0] = $in(half_res_uv);\n\tvalues[1] = $in(half_res_uv + vec2(pixel_offset, 0.0));\n\tvalues[2] = $in(half_res_uv + vec2(0.0, pixel_offset));\n\tvalues[3] = $in(half_res_uv + vec2(pixel_offset, pixel_offset));\n\t\n\tfloat lowest = 1.0;\n\tfloat highest = 0.0;\n\t\n\tfor (int i = 0; i < 4; i++) {\n\t\tlowest = values[i].r < lowest ? values[i].r : lowest;\n\t\thighest = values[i].g > highest ? values[i].g : highest;\n\t}\n\t\n\treturn vec3( lowest, highest , iter);\n}",
#						"name": "Compare Neighbor",
#						"outputs": [
#							{
#								"rgb": "$(name)_compare($uv, $size)",
#								"type": "rgb"
#							}
#						],
#						"parameters": [
#							{
#								"default": 10,
#								"first": 1,
#								"label": "",
#								"last": 13,
#								"name": "size",
#								"type": "size"
#							}
#						]
#					},
#					"type": "shader"
#				},
#				{
#					"name": "iterate_buffer",
#					"node_position": {
#						"x": 328,
#						"y": 63
#					},
#					"parameters": {
#						"filter": false,
#						"iterations": 13,
#						"mipmap": false,
#						"size": 10
#					},
#					"seed_value": 29168,
#					"type": "iterate_buffer"
#				},
#				{
#					"name": "combine",
#					"node_position": {
#						"x": 376,
#						"y": -75
#					},
#					"parameters": {
#
#					},
#					"type": "combine"
#				},
#				{
#					"name": "decompose",
#					"node_position": {
#						"x": 605,
#						"y": 64
#					},
#					"parameters": {
#
#					},
#					"type": "decompose"
#				},
#				{
#					"name": "gen_inputs",
#					"node_position": {
#						"x": -199,
#						"y": 23
#					},
#					"parameters": {
#
#					},
#					"ports": [
#						{
#							"group_size": 0,
#							"longdesc": "",
#							"name": "in",
#							"shortdesc": "In",
#							"type": "f"
#						}
#					],
#					"type": "ios"
#				},
#				{
#					"name": "gen_outputs",
#					"node_position": {
#						"x": 831,
#						"y": 42
#					},
#					"parameters": {
#
#					},
#					"ports": [
#						{
#							"group_size": 0,
#							"longdesc": "",
#							"name": "min",
#							"shortdesc": "Min",
#							"type": "f"
#						},
#						{
#							"group_size": 0,
#							"longdesc": "",
#							"name": "max",
#							"shortdesc": "Max",
#							"type": "f"
#						}
#					],
#					"type": "ios"
#				},
#				{
#					"name": "gen_parameters",
#					"node_position": {
#						"x": 248.399994,
#						"y": -292
#					},
#					"parameters": {
#						"param0": 10
#					},
#					"type": "remote",
#					"widgets": [
#						{
#							"label": "Size",
#							"linked_widgets": [
#								{
#									"node": "iterate_buffer",
#									"widget": "size"
#								},
#								{
#									"node": "14423",
#									"widget": "size"
#								}
#							],
#							"name": "param0",
#							"type": "linked_control"
#						}
#					]
#				}
#			],
#			"parameters": {
#				"param0": 10
#			},
#			"shortdesc": "",
#			"type": "graph"
#		},
#		{
#			"name": "tones_map",
#			"node_position": {
#				"x": 1142.528442,
#				"y": -88.26989
#			},
#			"parameters": {
#
#			},
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec4(0.5 ,0.5, 0.5, 1.0)",
#						"label": "",
#						"longdesc": "The input image",
#						"name": "in",
#						"shortdesc": "Input",
#						"type": "f"
#					},
#					{
#						"default": "0.0",
#						"label": "",
#						"name": "in_min",
#						"type": "f"
#					},
#					{
#						"default": "1.0",
#						"label": "",
#						"name": "in_max",
#						"type": "f"
#					}
#				],
#				"instance": "",
#				"longdesc": "Maps linearly an input tones interval to an output tones interval.",
#				"name": "Mapping",
#				"outputs": [
#					{
#						"f": "($in($uv)-$in_min($uv))/($in_max($uv)-$in_min($uv))",
#						"longdesc": "Shows the generated remapped image",
#						"shortdesc": "Output",
#						"type": "f"
#					}
#				],
#				"parameters": [
#
#				],
#				"shortdesc": "Tones map"
#			},
#			"type": "shader"
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": 665.528564,
#				"y": -136.535721
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input image",
#					"name": "in",
#					"shortdesc": "Input",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 1425.400024,
#				"y": -135.535721
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "Shows the generated remapped image",
#					"name": "out",
#					"shortdesc": "Output",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": 1024.664307,
#				"y": -298.400757
#			},
#			"parameters": {
#				"param0": 10
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "graph",
#							"widget": "param0"
#						}
#					],
#					"longdesc": "Buffers are used to find the mininum and maximum values for the input image. If the input has small details a higher resolution buffer might be needed to capture precise min and max values.\n\nNote: The output itself will not be buffered.",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				}
#			]
#		}
#	],
#	"parameters": {
#		"param0": 10
#	},
#	"shortdesc": "Auto Tones",
#	"type": "graph"
#}

#----------------------
#blend.mmg
#Blends its input, using an optional mask

#Outputs:

#Output - (color)
#vec4 $(name_uv)_s1 = $s1($uv);
#vec4 $(name_uv)_s2 = $s2($uv);
#float $(name_uv)_a = $amount*$a($uv);
#vec4(blend_$blend_type($uv, $(name_uv)_s1.rgb, $(name_uv)_s2.rgb, $(name_uv)_a*$(name_uv)_s1.a), min(1.0, $(name_uv)_s2.a+$(name_uv)_a*$(name_uv)_s1.a))

#Inputs:
#in1, color, default vec4($uv.x, 1.0, 1.0, 1.0)
#in2, color, default vec4($uv.x, 1.0, 1.0, 1.0)
#blend_type, enum, default: 0, Normal,Dissolve,Multiply,Screen,Overlay,Hard Light,Soft Light,Burn,Dodge,Lighten,Darken,Difference
#opactiy, float, min: 0, max: 1, default: 0.5, step: 0.01 (input float)

#----------------------
#combine.mmg
#Combines 4 greyscale inputs into an RGBA image

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "R",
#				"longdesc": "The greyscale input for the red channel",
#				"name": "r",
#				"shortdesc": "Red",
#				"type": "f"
#			},
#			{
#				"default": "0.0",
#				"label": "G",
#				"longdesc": "The greyscale input for the green channel",
#				"name": "g",
#				"shortdesc": "Green",
#				"type": "f"
#			},
#			{
#				"default": "0.0",
#				"label": "B",
#				"longdesc": "The greyscale input for the blue channel",
#				"name": "b",
#				"shortdesc": "Blue",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "A",
#				"longdesc": "The greyscale input for the alpha channel",
#				"name": "a",
#				"shortdesc": "Alpha",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the combined RGBA image",
#				"rgba": "vec4($r($uv), $g($uv), $b($uv), $a($uv))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],

#----------------------
#emboss.mmg
#Creates highlights and shadows from an input heightmap

#float $(name)_fct(vec2 uv) {
#	float pixels = max(1.0, $width);
#	float e = 1.0/$size;
#	float rv = 0.0;
#
#	for (float dx = -pixels; dx <= pixels; dx += 1.0) {
#		for (float dy = -pixels; dy <= pixels; dy += 1.0) {
#			if (abs(dx) > 0.5 || abs(dy) > 0.5) {
#				rv += $in(uv+e*vec2(dx, dy))*cos(atan(dy, dx)-$angle*3.14159265359/180.0)/length(vec2(dx, dy));
#			}
#		}
#	}
#
#	return $amount*rv/pixels+0.5;
#}

#Outputs:

#Output - (float)
#$(name)_fct($uv)

#Inputs:
#input, float, default 0
#size, int (image size)
#angle, float, min: -180, max: 180, default: 0, step: 0.1
#amount, float, min: 0, max: 10, default: 1, step: 0.1
#width, float, min: 1, max: 5, default: 1, step: 1

#----------------------
#invert.mmg
#A filter that inverts the R, G, and B channels of its input while keeping the A channel unchanged

#Outputs:

#Output - (rgba)
#vec4(vec3(1.0)-$in($uv).rgb, $in($uv).a)

#Inputs:
#input, rgba, default vec4(1.0, 1.0, 1.0, 1.0)

#----------------------
#normal_map.mmg

#{
#	"connections": [
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer",
#			"to_port": 0
#		},
#		{
#			"from": "buffer",
#			"from_port": 0,
#			"to": "switch",
#			"to_port": 1
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "switch",
#			"to_port": 0
#		},
#		{
#			"from": "edge_detect_1",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "switch",
#			"from_port": 0,
#			"to": "edge_detect_1",
#			"to_port": 0
#		}
#	],
#	"label": "Normal Map",
#	"longdesc": "Generates a normal map from a height map",
#	"name": "normal_map",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "buffer",
#			"node_position": {
#				"x": -695.663818,
#				"y": 34.60614
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 10
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -731.910156,
#				"y": -131.916687
#			},
#			"parameters": {
#				"param0": 10,
#				"param1": 1,
#				"param2": 0,
#				"param4": 1
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "edge_detect_1",
#							"widget": "format"
#						}
#					],
#					"longdesc": "The format of the generated normal map\nIn most cases this should be set to default",
#					"name": "param2",
#					"shortdesc": "Format",
#					"type": "linked_control"
#				},
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "buffer",
#							"widget": "size"
#						},
#						{
#							"node": "edge_detect_1",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution of the generated normal map",
#					"name": "param0",
#					"shortdesc": "Resolution",
#					"type": "linked_control"
#				},
#				{
#					"label": "",
#					"linked_widgets": [
#						{
#							"node": "edge_detect_1",
#							"widget": "amount"
#						}
#					],
#					"longdesc": "The strength of the normal map filter",
#					"name": "param1",
#					"shortdesc": "Strength",
#					"type": "linked_control"
#				},
#				{
#					"configurations": {
#						"False": [
#							{
#								"node": "switch",
#								"value": 0,
#								"widget": "source"
#							}
#						],
#						"True": [
#							{
#								"node": "switch",
#								"value": 1,
#								"widget": "source"
#							}
#						]
#					},
#					"label": "Buffer",
#					"linked_widgets": [
#						{
#							"node": "switch",
#							"widget": "source"
#						}
#					],
#					"longdesc": "When set, a buffer is used to sample the input before the normal map filter",
#					"name": "param4",
#					"shortdesc": "Buffer",
#					"type": "config_control"
#				}
#			]
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": -445.663818,
#				"y": 75.047363
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "Shows the generated normal map",
#					"name": "Normal",
#					"shortdesc": "Output",
#					"type": "rgb"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -1094.910156,
#				"y": 74.047363
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input height map",
#					"name": "Bump",
#					"shortdesc": "Input",
#					"type": "f"
#				}
#			],
#			"seed_value": 12483,
#			"type": "ios"
#		},
#		{
#			"name": "switch",
#			"node_position": {
#				"x": -673.5,
#				"y": 113.297363
#			},
#			"parameters": {
#				"choices": 2,
#				"outputs": 1,
#				"source": 1
#			},
#			"type": "switch"
#		},
#		{
#			"name": "edge_detect_1",
#			"node_position": {
#				"x": -676.092529,
#				"y": 193.868774
#			},
#			"parameters": {
#				"amount": 1,
#				"format": 0,
#				"size": 10
#			},
#			"shader_model": {
#				"code": "",
#				"global": "vec3 process_normal_default(vec3 v, float multiplier) {\n\treturn 0.5*normalize(v.xyz*multiplier+vec3(0.0, 0.0, -1.0))+vec3(0.5);\n}\n\nvec3 process_normal_opengl(vec3 v, float multiplier) {\n\treturn 0.5*normalize(v.xyz*multiplier+vec3(0.0, 0.0, 1.0))+vec3(0.5);\n}\n\nvec3 process_normal_directx(vec3 v, float multiplier) {\n\treturn 0.5*normalize(v.xyz*vec3(1.0, -1.0, 1.0)*multiplier+vec3(0.0, 0.0, 1.0))+vec3(0.5);\n}\n",
#				"inputs": [
#					{
#						"default": "0.0",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "f"
#					}
#				],
#				"instance": "vec3 $(name)_fct(vec2 uv) {\n\tvec3 e = vec3(1.0/$size, -1.0/$size, 0);\n\tvec2 rv = vec2(1.0, -1.0)*$in(uv+e.xy);\n\trv += vec2(-1.0, 1.0)*$in(uv-e.xy);\n\trv += vec2(1.0, 1.0)*$in(uv+e.xx);\n\trv += vec2(-1.0, -1.0)*$in(uv-e.xx);\n\trv += vec2(2.0, 0.0)*$in(uv+e.xz);\n\trv += vec2(-2.0, 0.0)*$in(uv-e.xz);\n\trv += vec2(0.0, 2.0)*$in(uv+e.zx);\n\trv += vec2(0.0, -2.0)*$in(uv-e.zx);\n\treturn vec3(rv, 0.0);\n}",
#				"name": "Normal map",
#				"outputs": [
#					{
#						"rgb": "process_normal_$format($(name)_fct($uv), $amount*$size/128.0)",
#						"type": "rgb"
#					}
#				],
#				"parameters": [
#					{
#						"default": 0,
#						"label": "",
#						"name": "format",
#						"type": "enum",
#						"values": [
#							{
#								"name": "Default",
#								"value": "default"
#							},
#							{
#								"name": "OpenGL",
#								"value": "opengl"
#							},
#							{
#								"name": "DirectX",
#								"value": "directx"
#							}
#						]
#					},
#					{
#						"default": 9,
#						"first": 4,
#						"label": "",
#						"last": 12,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"control": "None",
#						"default": 0.5,
#						"label": "",
#						"max": 2,
#						"min": 0,
#						"name": "amount",
#						"step": 0.01,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		}
#	],
#	"parameters": {
#		"param0": 10,
#		"param1": 1,
#		"param2": 0,
#		"param4": 1
#	},
#	"shortdesc": "Normal map",
#	"type": "graph"
#}

#----------------------
#sharpen.mmg
#Sharpens it input image

#		"inputs": [
#			{
#				"default": "vec3(0.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgb"
#			}
#		],
#		"instance": "vec3 $(name)_fct(vec2 uv) {\n\tvec2 e = vec2(1.0/$size, 0.0);\n\tvec3 rv = 5.0*$in(uv);\n\trv -= $in(uv+e.xy);\n\trv -= $in(uv-e.xy);\n\trv -= $in(uv+e.yx);\n\trv -= $in(uv-e.yx);\n\treturn rv;\n}",
#		"outputs": [
#			{
#				"longdesc": "Shows the generated sharpened image",
#				"rgb": "$(name)_fct($uv)",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"default": 9,
#				"first": 4,
#				"label": "Size",
#				"last": 12,
#				"longdesc": "The resolution of the input image",
#				"name": "size",
#				"shortdesc": "Size",
#				"type": "size"
#			}
#		],

#----------------------
#tones.mmg

#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"label": "",
#				"name": "input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"rgba": "adjust_levels($input($uv), $in_min, $in_mid, $in_max, $out_min, $out_max)",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"a": 0,
#					"b": 0,
#					"g": 0,
#					"r": 0
#				},
#				"label": "",
#				"name": "in_min",
#				"type": "color"
#			},
#			{
#				"default": {
#					"a": 0.498039,
#					"b": 0.498039,
#					"g": 0.498039,
#					"r": 0.498039
#				},
#				"label": "",
#				"name": "in_mid",
#				"type": "color"
#			},
#			{
#				"default": {
#					"a": 1,
#					"b": 1,
#					"g": 1,
#					"r": 1
#				},
#				"label": "",
#				"name": "in_max",
#				"type": "color"
#			},
#			{
#				"default": {
#					"a": 1,
#					"b": 0,
#					"g": 0,
#					"r": 0
#				},
#				"label": "",
#				"name": "out_min",
#				"type": "color"
#			},
#			{
#				"default": {
#					"a": 1,
#					"b": 1,
#					"g": 1,
#					"r": 1
#				},
#				"label": "",
#				"name": "out_max",
#				"type": "color"
#			}
#		]
#	},

#----------------------
#tones_map.mmg
#Maps linearly an input tones interval to an output tones interval.

#		"inputs": [
#			{
#				"default": "vec4(0.5 ,0.5, 0.5, 1.0)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the generated remapped image",
#				"rgba": "vec4(vec3($out_min)+($in($uv).rgb-vec3($in_min))*vec3(($out_max-$out_min)/($in_max-$in_min)), $in($uv).a)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Input min",
#				"longdesc": "The minimum value of the input interval",
#				"max": 1,
#				"min": 0,
#				"name": "in_min",
#				"shortdesc": "InputMin",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Input max",
#				"longdesc": "The maximum value of the input interval",
#				"max": 1,
#				"min": 0,
#				"name": "in_max",
#				"shortdesc": "InputMax",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Output min",
#				"longdesc": "The minimum value of the output interval",
#				"max": 1,
#				"min": 0,
#				"name": "out_min",
#				"shortdesc": "OutputMin",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Output max",
#				"longdesc": "The maximum value of the output interval",
#				"max": 1,
#				"min": 0,
#				"name": "out_max",
#				"shortdesc": "OutputMax",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#make_tileable.mmg
#Creates a tileable version of its input image by moving different parts around to hide seams.

#vec4 make_tileable_$(name)(vec2 uv, float w) {
#	vec4 a = $in(uv);
#	vec4 b = $in(fract(uv+vec2(0.5)));
#	float coef_ab = sin(1.57079632679*clamp((length(uv-vec2(0.5))-0.5+w)/w, 0.0, 1.0));
#	vec4 c = $in(fract(uv+vec2(0.25)));
#	float coef_abc = sin(1.57079632679*clamp((min(min(length(uv-vec2(0.0, 0.5)), length(uv-vec2(0.5, 0.0))), min(length(uv-vec2(1.0, 0.5)), length(uv-vec2(0.5, 1.0))))-w)/w, 0.0, 1.0));
#	return mix(c, mix(a, b, coef_ab), coef_abc);
#}

#Inputs:
#input, rgba, default: vec4(1.0)
#width, float, min:0, max: 1: default: 0.1, step: 0.01

#Outputs:
#output (rgba) 
#make_tileable_$(name)($uv, 0.5*$w)

#----------------------
#occlusion.mmg

#{
#	"connections": [
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer",
#			"to_port": 0
#		},
#		{
#			"from": "blend",
#			"from_port": 0,
#			"to": "colorize",
#			"to_port": 0
#		},
#		{
#			"from": "buffer",
#			"from_port": 0,
#			"to": "blend",
#			"to_port": 0
#		},
#		{
#			"from": "colorize",
#			"from_port": 0,
#			"to": "_2",
#			"to_port": 0
#		},
#		{
#			"from": "_2",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "buffer",
#			"from_port": 0,
#			"to": "gaussian_blur_x",
#			"to_port": 0
#		},
#		{
#			"from": "gaussian_blur_x",
#			"from_port": 0,
#			"to": "buffer_2",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "gaussian_blur_y",
#			"to_port": 0
#		},
#		{
#			"from": "gaussian_blur_y",
#			"from_port": 0,
#			"to": "blend",
#			"to_port": 1
#		}
#	],
#	"label": "Occlusion",
#	"longdesc": "Generates an ambient occlusion map from a height map",
#	"name": "occlusion",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "buffer_2",
#			"node_position": {
#				"x": -409.875,
#				"y": -112.625
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 8
#			},
#			"seed_value": 61344,
#			"type": "buffer"
#		},
#		{
#			"name": "buffer",
#			"node_position": {
#				"x": -408.25,
#				"y": -265.75
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 8
#			},
#			"seed_value": 53030,
#			"type": "buffer"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -463.666626,
#				"y": -384.666656
#			},
#			"parameters": {
#				"param0": 8,
#				"param2": 1.5
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Grid size:",
#					"linked_widgets": [
#						{
#							"node": "buffer",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_2",
#							"widget": "size"
#						},
#						{
#							"node": "gaussian_blur_x",
#							"widget": "size"
#						},
#						{
#							"node": "gaussian_blur_y",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution of the input height map",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "Strength",
#					"linked_widgets": [
#						{
#							"node": "_2",
#							"widget": "g"
#						}
#					],
#					"longdesc": "The strength of the occlusion map effect",
#					"name": "param2",
#					"shortdesc": "Strength",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -824.666626,
#				"y": -116.392853
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input heightmap",
#					"name": "port0",
#					"shortdesc": "Input",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 33.547607,
#				"y": -132.392853
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The generated occlusion map",
#					"name": "port0",
#					"shortdesc": "Output",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "blend",
#			"node_position": {
#				"x": -422.79895,
#				"y": 63.16272
#			},
#			"parameters": {
#				"amount": 1,
#				"blend_type": 11
#			},
#			"type": "blend"
#		},
#		{
#			"name": "colorize",
#			"node_position": {
#				"x": -167.79895,
#				"y": -178.83728
#			},
#			"parameters": {
#				"gradient": {
#					"interpolation": 1,
#					"points": [
#						{
#							"a": 1,
#							"b": 1,
#							"g": 1,
#							"pos": 0,
#							"r": 1
#						},
#						{
#							"a": 1,
#							"b": 0,
#							"g": 0,
#							"pos": 1,
#							"r": 0
#						}
#					],
#					"type": "Gradient"
#				}
#			},
#			"seed_value": 33856,
#			"type": "colorize"
#		},
#		{
#			"name": "_2",
#			"node_position": {
#				"x": -145.403687,
#				"y": -112.29187
#			},
#			"parameters": {
#				"g": 1.5
#			},
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "0.0",
#						"label": "",
#						"name": "in",
#						"type": "f"
#					}
#				],
#				"instance": "",
#				"name": "",
#				"outputs": [
#					{
#						"f": "pow($in($uv), $g)",
#						"type": "f"
#					}
#				],
#				"parameters": [
#					{
#						"default": 1,
#						"label": "",
#						"max": 2,
#						"min": 0,
#						"name": "g",
#						"step": 0.1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "gaussian_blur_x",
#			"node_position": {
#				"x": -413.053711,
#				"y": -189.016876
#			},
#			"parameters": {
#				"sigma": 50,
#				"size": 8
#			},
#			"type": "gaussian_blur_x"
#		},
#		{
#			"name": "gaussian_blur_y",
#			"node_position": {
#				"x": -405.053711,
#				"y": -21.016876
#			},
#			"parameters": {
#				"sigma": 50,
#				"size": 8
#			},
#			"type": "gaussian_blur_y"
#		}
#	],
#	"parameters": {
#		"param0": 8,
#		"param2": 1.5
#	},
#	"shortdesc": "Occlusion",
#	"type": "graph"
#}

#----------------------
#occlusion2.mmg

#{
#	"connections": [
#		{
#			"from": "colorize",
#			"from_port": 0,
#			"to": "_2",
#			"to_port": 0
#		},
#		{
#			"from": "_2",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "fast_blur",
#			"to_port": 0
#		},
#		{
#			"from": "fast_blur",
#			"from_port": 0,
#			"to": "blend",
#			"to_port": 1
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "blend",
#			"to_port": 0
#		},
#		{
#			"from": "blend",
#			"from_port": 0,
#			"to": "colorize",
#			"to_port": 0
#		}
#	],
#	"label": "Occlusion",
#	"longdesc": "Generates an ambient occlusion map from a height map",
#	"name": "occlusion2",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -522.866638,
#				"y": -383.867035
#			},
#			"parameters": {
#				"param0": 11,
#				"param1": 20,
#				"param2": 1.5,
#				"param3": 1
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Resolution",
#					"linked_widgets": [
#						{
#							"node": "fast_blur",
#							"widget": "param0"
#						}
#					],
#					"longdesc": "The resolution of the input height map",
#					"name": "param0",
#					"shortdesc": "Resolution",
#					"type": "linked_control"
#				},
#				{
#					"label": "Strength",
#					"linked_widgets": [
#						{
#							"node": "_2",
#							"widget": "g"
#						}
#					],
#					"longdesc": "The strength of the occlusion map effect",
#					"name": "param2",
#					"shortdesc": "Strength",
#					"type": "linked_control"
#				},
#				{
#					"label": "Radius",
#					"linked_widgets": [
#						{
#							"node": "fast_blur",
#							"widget": "param1"
#						}
#					],
#					"longdesc": "The radius of the blur used for the occlusion effect",
#					"name": "param1",
#					"shortdesc": "Radius",
#					"type": "linked_control"
#				},
#				{
#					"label": "Quality",
#					"linked_widgets": [
#						{
#							"node": "fast_blur",
#							"widget": "param2"
#						}
#					],
#					"longdesc": "The quality of the blur operation used for the occlusion effect",
#					"name": "param3",
#					"shortdesc": "Quality",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -842.266602,
#				"y": -108.396729
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input heightmap",
#					"name": "port0",
#					"shortdesc": "Input",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 77.5476,
#				"y": -86.015305
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The generated occlusion map",
#					"name": "port0",
#					"shortdesc": "Output",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "blend",
#			"node_position": {
#				"x": -422.79895,
#				"y": 11.18788
#			},
#			"parameters": {
#				"amount": 1,
#				"blend_type": 11
#			},
#			"type": "blend"
#		},
#		{
#			"name": "colorize",
#			"node_position": {
#				"x": -124.598953,
#				"y": -131.660126
#			},
#			"parameters": {
#				"gradient": {
#					"interpolation": 1,
#					"points": [
#						{
#							"a": 1,
#							"b": 1,
#							"g": 1,
#							"pos": 0,
#							"r": 1
#						},
#						{
#							"a": 1,
#							"b": 0,
#							"g": 0,
#							"pos": 1,
#							"r": 0
#						}
#					],
#					"type": "Gradient"
#				}
#			},
#			"seed_value": 33856,
#			"type": "colorize"
#		},
#		{
#			"name": "_2",
#			"node_position": {
#				"x": -104.603699,
#				"y": -57.918201
#			},
#			"parameters": {
#				"g": 1.5
#			},
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "0.0",
#						"label": "",
#						"name": "in",
#						"type": "f"
#					}
#				],
#				"instance": "",
#				"name": "",
#				"outputs": [
#					{
#						"f": "pow($in(fract($uv)), $g)",
#						"type": "f"
#					}
#				],
#				"parameters": [
#					{
#						"control": "None",
#						"default": 1,
#						"label": "",
#						"max": 2,
#						"min": 0,
#						"name": "g",
#						"step": 0.1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"connections": [
#				{
#					"from": "buffer_2",
#					"from_port": 0,
#					"to": "fast_blur_shader",
#					"to_port": 0
#				},
#				{
#					"from": "gen_inputs",
#					"from_port": 0,
#					"to": "buffer_2",
#					"to_port": 0
#				},
#				{
#					"from": "fast_blur_shader",
#					"from_port": 0,
#					"to": "gen_outputs",
#					"to_port": 0
#				}
#			],
#			"label": "Fast Blur",
#			"longdesc": "",
#			"name": "fast_blur",
#			"node_position": {
#				"x": -435.552002,
#				"y": -135.436234
#			},
#			"nodes": [
#				{
#					"name": "fast_blur_shader",
#					"node_position": {
#						"x": -161.600006,
#						"y": 143.188766
#					},
#					"parameters": {
#						"quality": 1,
#						"sigma": 20
#					},
#					"shader_model": {
#						"code": "",
#						"global": "",
#						"inputs": [
#							{
#								"default": "vec4(1.0)",
#								"function": true,
#								"label": "",
#								"name": "in",
#								"type": "rgba"
#							}
#						],
#						"instance": "vec4 $(name)_blur(vec2 uv, vec2 scale, float sigma, int quality) {\n    vec4 O = vec4(0.0);\n\tfloat samples = sigma * 4.0; \n\tint LOD = max(0, int(log2(float(samples)))-quality-2);\n\tint sLOD = 1 << LOD;\n    int s = max(1, int(samples/float(sLOD)));\n\tfloat sum = 0.0;\n    for (int i = 0; i < s*s; i++) {\n        vec2 d = vec2(float(i%s), float(i/s))*float(sLOD) - 0.5*float(samples);\n\t\tvec2 dd = d / sigma;\n\t\tfloat g = exp(-.5*dot(dd,dd))/(6.28*sigma*sigma);\n        O += g * textureLod($in.texture, uv + scale * d, float(LOD));\n\t\tsum += g;\n    }\n    \n    return O / sum;\n}\n",
#						"name": "Fast Blur",
#						"outputs": [
#							{
#								"rgba": "$(name)_blur($uv, vec2(1.0)/$in.size, max(1.0, floor($sigma*$in.size/2048.0)), int($quality))",
#								"type": "rgba"
#							}
#						],
#						"parameters": [
#							{
#								"control": "None",
#								"default": 1,
#								"label": "",
#								"max": 256,
#								"min": 1,
#								"name": "sigma",
#								"step": 1,
#								"type": "float"
#							},
#							{
#								"control": "None",
#								"default": 1,
#								"label": "",
#								"max": 3,
#								"min": 0,
#								"name": "quality",
#								"step": 1,
#								"type": "float"
#							}
#						]
#					},
#					"type": "shader"
#				},
#				{
#					"name": "buffer_2",
#					"node_position": {
#						"x": -187,
#						"y": 61.5
#					},
#					"parameters": {
#						"size": 11
#					},
#					"type": "buffer",
#					"version": 1
#				},
#				{
#					"name": "gen_inputs",
#					"node_position": {
#						"x": -602,
#						"y": 91.75
#					},
#					"parameters": {
#
#					},
#					"ports": [
#						{
#							"group_size": 0,
#							"name": "port0",
#							"type": "f"
#						}
#					],
#					"type": "ios"
#				},
#				{
#					"name": "gen_outputs",
#					"node_position": {
#						"x": 88,
#						"y": 61.75
#					},
#					"parameters": {
#
#					},
#					"ports": [
#						{
#							"group_size": 0,
#							"name": "port0",
#							"type": "rgba"
#						}
#					],
#					"type": "ios"
#				},
#				{
#					"name": "gen_parameters",
#					"node_position": {
#						"x": -254.5,
#						"y": -122.5
#					},
#					"parameters": {
#						"param0": 11,
#						"param1": 20,
#						"param2": 1
#					},
#					"type": "remote",
#					"widgets": [
#						{
#							"label": "Resolution",
#							"linked_widgets": [
#								{
#									"node": "buffer_2",
#									"widget": "size"
#								}
#							],
#							"name": "param0",
#							"type": "linked_control"
#						},
#						{
#							"label": "Sigma",
#							"linked_widgets": [
#								{
#									"node": "fast_blur_shader",
#									"widget": "sigma"
#								}
#							],
#							"name": "param1",
#							"type": "linked_control"
#						},
#						{
#							"label": "Quality",
#							"linked_widgets": [
#								{
#									"node": "fast_blur_shader",
#									"widget": "quality"
#								}
#							],
#							"name": "param2",
#							"type": "linked_control"
#						}
#					]
#				}
#			],
#			"parameters": {
#				"param0": 11,
#				"param1": 20,
#				"param2": 1
#			},
#			"shortdesc": "",
#			"type": "graph"
#		}
#	],
#	"parameters": {
#		"param0": 11,
#		"param1": 20,
#		"param2": 1.5,
#		"param3": 1
#	},
#	"shortdesc": "Occlusion",
#	"type": "graph"
#}

#----------------------
#pixelize.mmg
#Creates a pixelated image from its input, and also quantifies the colors with optional dithering.

#		"code": "vec2 $(name_uv)_uv = floor(($uv*vec2($x, $y)))+vec2(0.5);\nvec3 $(name_uv)_dither = fract(vec3(dot(vec2(171.0, 231.0), $(name_uv)_uv))/vec3(103.0, 71.0, 97.0));\n",
#		"inputs": [
#			{
#				"default": "vec3(1.0)",
#				"label": "",
#				"longdesc": "The image to be pixelated",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "A pixelated version of the input image",
#				"rgb": "floor($i($(name_uv)_uv/vec2($x, $y))*$c+$d*($(name_uv)_dither-vec3(0.5)))/$c",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Columns:",
#				"longdesc": "Number of pixel columns of the output",
#				"max": 256,
#				"min": 1,
#				"name": "x",
#				"shortdesc": "Columns",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Rows:",
#				"longdesc": "Number of pixel rows of the output",
#				"max": 256,
#				"min": 1,
#				"name": "y",
#				"shortdesc": "Rows",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Levels:",
#				"longdesc": "Number of color levels for each channel",
#				"max": 32,
#				"min": 2,
#				"name": "c",
#				"shortdesc": "Levels",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Dither:",
#				"longdesc": "Amount of dithering in the output image",
#				"max": 1,
#				"min": 0,
#				"name": "d",
#				"shortdesc": "Dithering",
#				"step": 0.01,
#				"type": "float"
#			}
#		]

#----------------------
#quantize.mmg
#Quantizes the red, green and blue channels of its input

#		"inputs": [
#			{
#				"default": "vec4(2.0*vec3(length($uv-vec2(0.5))), 1.0)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The quantized image",
#				"rgba": "vec4(floor($in($uv).rgb*$steps)/$steps, $in($uv).a)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 4,
#				"label": "",
#				"longdesc": "The number of quantization steps",
#				"max": 32,
#				"min": 2,
#				"name": "steps",
#				"shortdesc": "Steps",
#				"step": 1,
#				"type": "float"
#			}
#		],

#----------------------
#skew.mmg

#		"global": "vec2 uvskew_h(vec2 uv, float amount) {\n\treturn vec2(uv.x+amount*(uv.y-0.5), uv.y);\n}\nvec2 uvskew_v(vec2 uv, float amount) {\n\treturn vec2(uv.x, uv.y+amount*(uv.x-0.5));\n}",
#		"inputs": [
#			{
#				"default": "vec4($uv, 0, 1)",
#				"label": "",
#				"name": "i",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"rgba": "$i(uvskew_$direction($uv, $amount))",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"name": "direction",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Horizontal",
#						"value": "h"
#					},
#					{
#						"name": "Vertical",
#						"value": "v"
#					}
#				]
#			},
#			{
#				"default": 0,
#				"label": "",
#				"max": 3,
#				"min": -3,
#				"name": "amount",
#				"step": 0.005,
#				"type": "float",
#				"widget": "spinbox"
#			}
#		]

#----------------------
#tonality.mmg
#Remaps a greyscale image tonality using a curve

#		"inputs": [
#			{
#				"default": "$uv.x",
#				"label": "",
#				"longdesc": "The input greyscale image",
#				"name": "input",
#				"shortdesc": "Input",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$curve($input($uv))",
#				"longdesc": "The remapped greyscale image",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"points": [
#						{
#							"ls": 0,
#							"rs": 1,
#							"x": 0,
#							"y": 0
#						},
#						{
#							"ls": 1,
#							"rs": 0,
#							"x": 1,
#							"y": 1
#						}
#					],
#					"type": "Curve"
#				},
#				"label": "",
#				"longdesc": "The tonality curve to which the input is remapped",
#				"name": "curve",
#				"shortdesc": "Curve",
#				"type": "curve"
#			}
#		],

#----------------------
#tones_range.mmg
#Outputs the tone range around a specified value

#		"code": "float $(name_uv)_step = clamp(($in($uv) - ($value))/max(0.0001, $width)+0.5, 0.0, 1.0);\nfloat $(name_uv)_false = clamp((min($(name_uv)_step, 1.0-$(name_uv)_step) * 2.0) / (1.0 - $contrast), 0.0, 1.0);\nfloat $(name_uv)_true = 1.0-$(name_uv)_false;",
#		"inputs": [
#			{
#				"default": "($uv.x + $uv.y) / 2.0",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$(name_uv)_$invert",
#				"longdesc": "Shows the generated high contrast image",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Value",
#				"longdesc": "The center value of the selection",
#				"max": 1,
#				"min": 0,
#				"name": "value",
#				"shortdesc": "Value",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.25,
#				"label": "Width",
#				"longdesc": "The width (in tones space) of the selection area",
#				"max": 1,
#				"min": 0,
#				"name": "width",
#				"shortdesc": "Width",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Contrast",
#				"longdesc": "Adjusts the falloff of the output",
#				"max": 1,
#				"min": 0,
#				"name": "contrast",
#				"shortdesc": "Contrast",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Invert",
#				"longdesc": "Invert the generated image if set",
#				"name": "invert",
#				"shortdesc": "Invert",
#				"type": "boolean"
#			}
#		],

#----------------------
#tones_step.mmg
#Emphasizes dark and light tones around a specified value

#		"code": "vec3 $(name_uv)_false = clamp(($in($uv).rgb-vec3($value))/max(0.0001, $width)+vec3(0.5), vec3(0.0), vec3(1.0));\nvec3 $(name_uv)_true = vec3(1.0)-$(name_uv)_false;",
#		"inputs": [
#			{
#				"default": "vec4(0.5 ,0.5, 0.5, 1.0)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the generated high contrast image",
#				"rgba": "vec4($(name_uv)_$invert, $in($uv).a)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Value",
#				"longdesc": "The value of the input that separate dark and light zones of the result",
#				"max": 1,
#				"min": 0,
#				"name": "value",
#				"shortdesc": "Value",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Width",
#				"longdesc": "The width (in tones space) of the transition area",
#				"max": 1,
#				"min": 0,
#				"name": "width",
#				"shortdesc": "width",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Invert",
#				"longdesc": "Invert the generated image if set",
#				"name": "invert",
#				"shortdesc": "Invert",
#				"type": "boolean"
#			}
#		],

#----------------------
#math.mmg
#Performs a math operation using its inputs or parameter values

#		"code": "float $(name_uv)_clamp_false = $op;\nfloat $(name_uv)_clamp_true = clamp($(name_uv)_clamp_false, 0.0, 1.0);\n",
#		"inputs": [
#			{
#				"default": "$default_in1",
#				"label": "2:A",
#				"longdesc": "The A operand",
#				"name": "in1",
#				"shortdesc": "A",
#				"type": "f"
#			},
#			{
#				"default": "$default_in2",
#				"label": "B",
#				"longdesc": "The B operand",
#				"name": "in2",
#				"shortdesc": "B",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$(name_uv)_clamp_$clamp",
#				"longdesc": "Shows a greyscale image of the result",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 19,
#				"label": "",
#				"longdesc": "The operation to be performed",
#				"name": "op",
#				"shortdesc": "Operation",
#				"type": "enum",
#				"values": [
#					{
#						"name": "A+B",
#						"value": "$in1($uv)+$in2($uv)"
#					},
#					{
#						"name": "A-B",
#						"value": "$in1($uv)-$in2($uv)"
#					},
#					{
#						"name": "A*B",
#						"value": "$in1($uv)*$in2($uv)"
#					},
#					{
#						"name": "A/B",
#						"value": "$in1($uv)/$in2($uv)"
#					},
#					{
#						"name": "log(A)",
#						"value": "log($in1($uv))"
#					},
#					{
#						"name": "log2(A)",
#						"value": "log2($in1($uv))"
#					},
#					{
#						"name": "pow(A, B)",
#						"value": "pow($in1($uv),$in2($uv))"
#					},
#					{
#						"name": "abs(A)",
#						"value": "abs($in1($uv))"
#					},
#					{
#						"name": "round(A)",
#						"value": "round($in1($uv))"
#					},
#					{
#						"name": "floor(A)",
#						"value": "floor($in1($uv))"
#					},
#					{
#						"name": "ceil(A)",
#						"value": "ceil($in1($uv))"
#					},
#					{
#						"name": "trunc(A)",
#						"value": "trunc($in1($uv))"
#					},
#					{
#						"name": "fract(A)",
#						"value": "fract($in1($uv))"
#					},
#					{
#						"name": "min(A, B)",
#						"value": "min($in1($uv),$in2($uv))"
#					},
#					{
#						"name": "max(A, B)",
#						"value": "max($in1($uv),$in2($uv))"
#					},
#					{
#						"name": "A<B",
#						"value": "step($in1($uv),$in2($uv))"
#					},
#					{
#						"name": "cos(A*B)",
#						"value": "cos($in1($uv)*$in2($uv))"
#					},
#					{
#						"name": "sin(A*B)",
#						"value": "sin($in1($uv)*$in2($uv))"
#					},
#					{
#						"name": "tan(A*B)",
#						"value": "tan($in1($uv)*$in2($uv))"
#					},
#					{
#						"name": "sqrt(1-A²)",
#						"value": "sqrt(1.0-$in1($uv)*$in1($uv))"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The default value for A, used if the corresponding input is not connected",
#				"max": 1,
#				"min": 0,
#				"name": "default_in1",
#				"shortdesc": "Default A",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The default value for B, used if the corresponding input is not connected",
#				"max": 1,
#				"min": 0,
#				"name": "default_in2",
#				"shortdesc": "Default B",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Clamp result",
#				"longdesc": "The result is clamped to [0, 1] if this option is checked",
#				"name": "clamp",
#				"shortdesc": "Clamp",
#				"type": "boolean"
#			}
#		],

#----------------------
#smooth_curvature.mmg

#{
#	"connections": [
#		{
#			"from": "blend",
#			"from_port": 0,
#			"to": "blend_2",
#			"to_port": 1
#		},
#		{
#			"from": "blend_2",
#			"from_port": 0,
#			"to": "blend_3",
#			"to_port": 1
#		},
#		{
#			"from": "blend_3",
#			"from_port": 0,
#			"to": "blend_4",
#			"to_port": 1
#		},
#		{
#			"from": "blend_4",
#			"from_port": 0,
#			"to": "invert",
#			"to_port": 0
#		},
#		{
#			"from": "invert",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "normal_map",
#			"to_port": 0
#		},
#		{
#			"from": "598_3",
#			"from_port": 0,
#			"to": "fast_blur",
#			"to_port": 0
#		},
#		{
#			"from": "fast_blur",
#			"from_port": 0,
#			"to": "blend_4",
#			"to_port": 0
#		},
#		{
#			"from": "598_2",
#			"from_port": 0,
#			"to": "fast_blur_2",
#			"to_port": 0
#		},
#		{
#			"from": "fast_blur_2",
#			"from_port": 0,
#			"to": "blend_3",
#			"to_port": 0
#		},
#		{
#			"from": "598_4",
#			"from_port": 0,
#			"to": "fast_blur_3",
#			"to_port": 0
#		},
#		{
#			"from": "fast_blur_3",
#			"from_port": 0,
#			"to": "blend_2",
#			"to_port": 0
#		},
#		{
#			"from": "598_5",
#			"from_port": 0,
#			"to": "fast_blur_4",
#			"to_port": 0
#		},
#		{
#			"from": "fast_blur_4",
#			"from_port": 0,
#			"to": "blend",
#			"to_port": 0
#		},
#		{
#			"from": "598_6",
#			"from_port": 0,
#			"to": "fast_blur_5",
#			"to_port": 0
#		},
#		{
#			"from": "fast_blur_5",
#			"from_port": 0,
#			"to": "blend",
#			"to_port": 1
#		},
#		{
#			"from": "normal_map",
#			"from_port": 0,
#			"to": "buffer_2",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "598_3",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "598_2",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "598_4",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "598_5",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "598_6",
#			"to_port": 0
#		}
#	],
#	"label": "Smooth Curvature",
#	"longdesc": "Creates a smooth curvature map from a height map",
#	"name": "smooth_curvature",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "normal_map",
#			"node_position": {
#				"x": -684.409058,
#				"y": 680
#			},
#			"parameters": {
#				"param0": 11,
#				"param1": 1,
#				"param2": 0,
#				"param4": 1
#			},
#			"type": "normal_map"
#		},
#		{
#			"name": "blend",
#			"node_position": {
#				"x": 510.361206,
#				"y": 903.779297
#			},
#			"parameters": {
#				"amount": 1,
#				"blend_type": 4
#			},
#			"type": "blend"
#		},
#		{
#			"name": "blend_2",
#			"node_position": {
#				"x": 510.179382,
#				"y": 803.915527
#			},
#			"parameters": {
#				"amount": 1,
#				"blend_type": 4
#			},
#			"type": "blend"
#		},
#		{
#			"name": "blend_3",
#			"node_position": {
#				"x": 509.270233,
#				"y": 702.279175
#			},
#			"parameters": {
#				"amount": 1,
#				"blend_type": 4
#			},
#			"type": "blend"
#		},
#		{
#			"name": "blend_4",
#			"node_position": {
#				"x": 509.542999,
#				"y": 600.279175
#			},
#			"parameters": {
#				"amount": 1,
#				"blend_type": 4
#			},
#			"type": "blend"
#		},
#		{
#			"name": "invert",
#			"node_position": {
#				"x": 754.354553,
#				"y": 603.172791
#			},
#			"parameters": {
#
#			},
#			"type": "invert"
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -1097.162842,
#				"y": 678.835876
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input height map",
#					"name": "port0",
#					"shortdesc": "Height map",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 908.046326,
#				"y": 596.806824
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The generated curvature map",
#					"name": "port0",
#					"shortdesc": "Output",
#					"type": "rgba"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -121.992188,
#				"y": 350.266235
#			},
#			"parameters": {
#				"param0": 11,
#				"param2": 1
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Size",
#					"linked_widgets": [
#						{
#							"node": "normal_map",
#							"widget": "param0"
#						},
#						{
#							"node": "598_3",
#							"widget": "size"
#						},
#						{
#							"node": "fast_blur",
#							"widget": "param0"
#						},
#						{
#							"node": "598_2",
#							"widget": "size"
#						},
#						{
#							"node": "fast_blur_2",
#							"widget": "param0"
#						},
#						{
#							"node": "598_4",
#							"widget": "size"
#						},
#						{
#							"node": "fast_blur_3",
#							"widget": "param0"
#						},
#						{
#							"node": "fast_blur_4",
#							"widget": "param0"
#						},
#						{
#							"node": "598_5",
#							"widget": "size"
#						},
#						{
#							"node": "fast_blur_5",
#							"widget": "param0"
#						},
#						{
#							"node": "598_6",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_2",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The buffer size for the filter",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "Intensity",
#					"linked_widgets": [
#						{
#							"node": "normal_map",
#							"widget": "param1"
#						}
#					],
#					"longdesc": "The contrast of the generated highlights",
#					"name": "param2",
#					"shortdesc": "Intensity",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "598_3",
#			"node_position": {
#				"x": -94.135475,
#				"y": 510.526459
#			},
#			"parameters": {
#				"amount": 1,
#				"size": 11,
#				"width": 1
#			},
#			"shader_model": {
#				"code": "vec2 $(name_uv)_emboss = $(name)_fct($uv);",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec3(0.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgb"
#					}
#				],
#				"instance": "vec2 $(name)_fct(vec2 uv) {\n\tfloat pixels = max(1.0, $width);\n\tfloat e = 1.0/$size;\n\tvec2 rv = vec2(0.0);\n\tfor (float dx = -pixels; dx <= pixels; dx += 1.0) {\n\t\tfor (float dy = -pixels; dy <= pixels; dy += 1.0) {\n\t\t\tif (abs(dx) > 0.5 || abs(dy) > 0.5) {\n\t\t\t\trv += $in(uv+e*vec2(dx, dy)).xy*cos(vec2(atan(dy, dx))-vec2(0.0, 0.5)*3.14159265359)/length(vec2(dx, dy));\n\t\t\t}\n\t\t}\n\t}\n\treturn $amount*rv/pixels+0.5;\n}",
#				"name": "Curvature",
#				"outputs": [
#					{
#						"f": "0.5*($(name_uv)_emboss.x+$(name_uv)_emboss.y)",
#						"type": "f"
#					}
#				],
#				"parameters": [
#					{
#						"default": 9,
#						"first": 6,
#						"label": "Size",
#						"last": 12,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Amount",
#						"max": 10,
#						"min": 0,
#						"name": "amount",
#						"step": 0.1,
#						"type": "float"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Width",
#						"max": 5,
#						"min": 1,
#						"name": "width",
#						"step": 1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "598_2",
#			"node_position": {
#				"x": -100.207932,
#				"y": 638.757874
#			},
#			"parameters": {
#				"amount": 1,
#				"size": 11,
#				"width": 2
#			},
#			"shader_model": {
#				"code": "vec2 $(name_uv)_emboss = $(name)_fct($uv);",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec3(0.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgb"
#					}
#				],
#				"instance": "vec2 $(name)_fct(vec2 uv) {\n\tfloat pixels = max(1.0, $width);\n\tfloat e = 1.0/$size;\n\tvec2 rv = vec2(0.0);\n\tfor (float dx = -pixels; dx <= pixels; dx += 1.0) {\n\t\tfor (float dy = -pixels; dy <= pixels; dy += 1.0) {\n\t\t\tif (abs(dx) > 0.5 || abs(dy) > 0.5) {\n\t\t\t\trv += $in(uv+e*vec2(dx, dy)).xy*cos(vec2(atan(dy, dx))-vec2(0.0, 0.5)*3.14159265359)/length(vec2(dx, dy));\n\t\t\t}\n\t\t}\n\t}\n\treturn $amount*rv/pixels+0.5;\n}",
#				"name": "Curvature",
#				"outputs": [
#					{
#						"f": "0.5*($(name_uv)_emboss.x+$(name_uv)_emboss.y)",
#						"type": "f"
#					}
#				],
#				"parameters": [
#					{
#						"default": 9,
#						"first": 6,
#						"label": "Size",
#						"last": 12,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Amount",
#						"max": 10,
#						"min": 0,
#						"name": "amount",
#						"step": 0.1,
#						"type": "float"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Width",
#						"max": 5,
#						"min": 1,
#						"name": "width",
#						"step": 1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "598_4",
#			"node_position": {
#				"x": -97.532082,
#				"y": 755.803345
#			},
#			"parameters": {
#				"amount": 1,
#				"size": 11,
#				"width": 4
#			},
#			"shader_model": {
#				"code": "vec2 $(name_uv)_emboss = $(name)_fct($uv);",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec3(0.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgb"
#					}
#				],
#				"instance": "vec2 $(name)_fct(vec2 uv) {\n\tfloat pixels = max(1.0, $width);\n\tfloat e = 1.0/$size;\n\tvec2 rv = vec2(0.0);\n\tfor (float dx = -pixels; dx <= pixels; dx += 1.0) {\n\t\tfor (float dy = -pixels; dy <= pixels; dy += 1.0) {\n\t\t\tif (abs(dx) > 0.5 || abs(dy) > 0.5) {\n\t\t\t\trv += $in(uv+e*vec2(dx, dy)).xy*cos(vec2(atan(dy, dx))-vec2(0.0, 0.5)*3.14159265359)/length(vec2(dx, dy));\n\t\t\t}\n\t\t}\n\t}\n\treturn $amount*rv/pixels+0.5;\n}",
#				"name": "Curvature",
#				"outputs": [
#					{
#						"f": "0.5*($(name_uv)_emboss.x+$(name_uv)_emboss.y)",
#						"type": "f"
#					}
#				],
#				"parameters": [
#					{
#						"default": 9,
#						"first": 6,
#						"label": "Size",
#						"last": 12,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Amount",
#						"max": 10,
#						"min": 0,
#						"name": "amount",
#						"step": 0.1,
#						"type": "float"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Width",
#						"max": 5,
#						"min": 1,
#						"name": "width",
#						"step": 1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "598_5",
#			"node_position": {
#				"x": -95.713867,
#				"y": 877.621521
#			},
#			"parameters": {
#				"amount": 1,
#				"size": 11,
#				"width": 8
#			},
#			"shader_model": {
#				"code": "vec2 $(name_uv)_emboss = $(name)_fct($uv);",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec3(0.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgb"
#					}
#				],
#				"instance": "vec2 $(name)_fct(vec2 uv) {\n\tfloat pixels = max(1.0, $width);\n\tfloat e = 1.0/$size;\n\tvec2 rv = vec2(0.0);\n\tfor (float dx = -pixels; dx <= pixels; dx += 1.0) {\n\t\tfor (float dy = -pixels; dy <= pixels; dy += 1.0) {\n\t\t\tif (abs(dx) > 0.5 || abs(dy) > 0.5) {\n\t\t\t\trv += $in(uv+e*vec2(dx, dy)).xy*cos(vec2(atan(dy, dx))-vec2(0.0, 0.5)*3.14159265359)/length(vec2(dx, dy));\n\t\t\t}\n\t\t}\n\t}\n\treturn $amount*rv/pixels+0.5;\n}",
#				"name": "Curvature",
#				"outputs": [
#					{
#						"f": "0.5*($(name_uv)_emboss.x+$(name_uv)_emboss.y)",
#						"type": "f"
#					}
#				],
#				"parameters": [
#					{
#						"default": 9,
#						"first": 6,
#						"label": "Size",
#						"last": 12,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Amount",
#						"max": 10,
#						"min": 0,
#						"name": "amount",
#						"step": 0.1,
#						"type": "float"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Width",
#						"max": 5,
#						"min": 1,
#						"name": "width",
#						"step": 1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "598_6",
#			"node_position": {
#				"x": -92.077492,
#				"y": 992.848633
#			},
#			"parameters": {
#				"amount": 1,
#				"size": 11,
#				"width": 16
#			},
#			"shader_model": {
#				"code": "vec2 $(name_uv)_emboss = $(name)_fct($uv);",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec3(0.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgb"
#					}
#				],
#				"instance": "vec2 $(name)_fct(vec2 uv) {\n\tfloat pixels = max(1.0, $width);\n\tfloat e = 1.0/$size;\n\tvec2 rv = vec2(0.0);\n\tfor (float dx = -pixels; dx <= pixels; dx += 1.0) {\n\t\tfor (float dy = -pixels; dy <= pixels; dy += 1.0) {\n\t\t\tif (abs(dx) > 0.5 || abs(dy) > 0.5) {\n\t\t\t\trv += $in(uv+e*vec2(dx, dy)).xy*cos(vec2(atan(dy, dx))-vec2(0.0, 0.5)*3.14159265359)/length(vec2(dx, dy));\n\t\t\t}\n\t\t}\n\t}\n\treturn $amount*rv/pixels+0.5;\n}",
#				"name": "Curvature",
#				"outputs": [
#					{
#						"f": "0.5*($(name_uv)_emboss.x+$(name_uv)_emboss.y)",
#						"type": "f"
#					}
#				],
#				"parameters": [
#					{
#						"default": 9,
#						"first": 6,
#						"label": "Size",
#						"last": 12,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Amount",
#						"max": 10,
#						"min": 0,
#						"name": "amount",
#						"step": 0.1,
#						"type": "float"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Width",
#						"max": 5,
#						"min": 1,
#						"name": "width",
#						"step": 1,
#						"type": "float"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"connections": [
#				{
#					"from": "buffer_2",
#					"from_port": 0,
#					"to": "fast_blur_shader",
#					"to_port": 0
#				},
#				{
#					"from": "gen_inputs",
#					"from_port": 0,
#					"to": "buffer_2",
#					"to_port": 0
#				},
#				{
#					"from": "fast_blur_shader",
#					"from_port": 0,
#					"to": "gen_outputs",
#					"to_port": 0
#				}
#			],
#			"label": "Fast Blur",
#			"longdesc": "",
#			"name": "fast_blur",
#			"node_position": {
#				"x": 167.483093,
#				"y": 509.757843
#			},
#			"nodes": [
#				{
#					"name": "fast_blur_shader",
#					"node_position": {
#						"x": -168,
#						"y": 120
#					},
#					"parameters": {
#						"quality": 1,
#						"sigma": 2
#					},
#					"type": "fast_blur_shader"
#				},
#				{
#					"name": "buffer_2",
#					"node_position": {
#						"x": -187,
#						"y": 61.5
#					},
#					"parameters": {
#						"size": 11
#					},
#					"type": "buffer",
#					"version": 1
#				},
#				{
#					"name": "gen_inputs",
#					"node_position": {
#						"x": -602,
#						"y": 91.75
#					},
#					"parameters": {
#
#					},
#					"ports": [
#						{
#							"group_size": 0,
#							"name": "port0",
#							"type": "f"
#						}
#					],
#					"type": "ios"
#				},
#				{
#					"name": "gen_outputs",
#					"node_position": {
#						"x": 88,
#						"y": 61.75
#					},
#					"parameters": {
#
#					},
#					"ports": [
#						{
#							"group_size": 0,
#							"name": "port0",
#							"type": "rgba"
#						}
#					],
#					"type": "ios"
#				},
#				{
#					"name": "gen_parameters",
#					"node_position": {
#						"x": -254.5,
#						"y": -122.5
#					},
#					"parameters": {
#						"param0": 11,
#						"param1": 2,
#						"param2": 1
#					},
#					"type": "remote",
#					"widgets": [
#						{
#							"label": "Resolution",
#							"linked_widgets": [
#								{
#									"node": "buffer_2",
#									"widget": "size"
#								}
#							],
#							"name": "param0",
#							"type": "linked_control"
#						},
#						{
#							"label": "Sigma",
#							"linked_widgets": [
#								{
#									"node": "fast_blur_shader",
#									"widget": "sigma"
#								}
#							],
#							"name": "param1",
#							"type": "linked_control"
#						},
#						{
#							"label": "Quality",
#							"linked_widgets": [
#								{
#									"node": "fast_blur_shader",
#									"widget": "quality"
#								}
#							],
#							"name": "param2",
#							"type": "linked_control"
#						}
#					]
#				}
#			],
#			"parameters": {
#				"param0": 11,
#				"param1": 2,
#				"param2": 1
#			},
#			"shortdesc": "",
#			"type": "graph"
#		},
#		{
#			"name": "fast_blur_2",
#			"node_position": {
#				"x": 167.156082,
#				"y": 638.560974
#			},
#			"parameters": {
#				"param0": 11,
#				"param1": 5,
#				"param2": 1
#			},
#			"type": "fast_blur"
#		},
#		{
#			"name": "fast_blur_3",
#			"node_position": {
#				"x": 171.701691,
#				"y": 756.742798
#			},
#			"parameters": {
#				"param0": 11,
#				"param1": 8,
#				"param2": 1
#			},
#			"type": "fast_blur"
#		},
#		{
#			"name": "fast_blur_4",
#			"node_position": {
#				"x": 167.377045,
#				"y": 877.651917
#			},
#			"parameters": {
#				"param0": 11,
#				"param1": 16,
#				"param2": 1
#			},
#			"type": "fast_blur"
#		},
#		{
#			"name": "fast_blur_5",
#			"node_position": {
#				"x": 170.104279,
#				"y": 992.197327
#			},
#			"parameters": {
#				"param0": 11,
#				"param1": 34,
#				"param2": 1
#			},
#			"type": "fast_blur"
#		},
#		{
#			"name": "buffer_2",
#			"node_position": {
#				"x": -426.44928,
#				"y": 678.75
#			},
#			"parameters": {
#				"filter": false,
#				"mipmap": false,
#				"size": 11
#			},
#			"type": "buffer",
#			"version": 2
#		}
#	],
#	"parameters": {
#		"param0": 11,
#		"param2": 1
#	},
#	"shortdesc": "Smooth Curvature",
#	"type": "graph"
#}

#----------------------
#smooth_curvature2.mmg

#{
#	"connections": [
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer",
#			"to_port": 0
#		},
#		{
#			"from": "buffer",
#			"from_port": 0,
#			"to": "switch",
#			"to_port": 1
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "switch",
#			"to_port": 0
#		},
#		{
#			"from": "598",
#			"from_port": 0,
#			"to": "buffer_2",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "switch_2",
#			"to_port": 1
#		},
#		{
#			"from": "598",
#			"from_port": 0,
#			"to": "switch_2",
#			"to_port": 0
#		},
#		{
#			"from": "switch_2",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "switch",
#			"from_port": 0,
#			"to": "598",
#			"to_port": 0
#		}
#	],
#	"label": "Smooth Curvature 2",
#	"longdesc": "",
#	"name": "smooth_curvature2",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "buffer",
#			"node_position": {
#				"x": 300.603302,
#				"y": -549.522034
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 10
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "598",
#			"node_position": {
#				"x": 286.999847,
#				"y": -359.903259
#			},
#			"parameters": {
#				"quality": 4,
#				"radius": 1,
#				"strength": 1
#			},
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "0.5",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "f"
#					}
#				],
#				"instance": "float $(name)_curve( vec2 p, vec2 o ){\n\tfloat a = $in(p+o);\n\tfloat b = $in(p-o);\n\tfloat c = $in(p+o*vec2(1.0,-1.0));\n\tfloat d = $in(p-o*vec2(1.0,-1.0));\n\treturn -a - b - c - d;\n}\n\nfloat $(name)_curvature_map(vec2 p, float r, float q){\n\tfloat s = r/q;\n\tfloat H = $in(p)*4.0;\n\tfloat v = 0.0;\n\tvec2 o;\n\tfor( o.x = 0.0; o.x < q; o.x++ ){\n\t\tfor( o.y = 0.0; o.y < q; o.y++ ){\n\t\t\tfloat c = $(name)_curve(p, o*s);\n\t\t\tv += (H + c) * ((r-length(o*s)) / r);\n\t\t}\n\t}\n\treturn v/(q*q);\n}\n\nfloat $(name)_curvature(vec2 uv, float quality, float strength, float radius) {\n\tfloat c = $(name)_curvature_map(uv, 0.050 * radius, quality)*strength / radius;\n\treturn 0.5 + c;\n}",
#				"name": "Smooth Curvature",
#				"outputs": [
#					{
#						"f": "$(name)_curvature($uv, $quality, $strength, $radius)",
#						"type": "f"
#					}
#				],
#				"parameters": [
#					{
#						"control": "None",
#						"default": 4,
#						"label": "Quality",
#						"longdesc": "How many times the input is sampled to generate the curvature map",
#						"max": 16,
#						"min": 2,
#						"name": "quality",
#						"shortdesc": "Quality",
#						"step": 1,
#						"type": "float"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Strength",
#						"longdesc": "The intensity of the curvature map",
#						"max": 2,
#						"min": 0,
#						"name": "strength",
#						"shortdesc": "Strength",
#						"step": 0.01,
#						"type": "float"
#					},
#					{
#						"control": "None",
#						"default": 1,
#						"label": "Radius",
#						"longdesc": "The radius of the smoothing of the curvature effect",
#						"max": 2,
#						"min": 0,
#						"name": "radius",
#						"shortdesc": "Radius",
#						"step": 0.01,
#						"type": "float"
#					}
#				],
#				"shortdesc": "Smooth Curvature"
#			},
#			"type": "shader"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": 242.146149,
#				"y": -788.088806
#			},
#			"parameters": {
#				"param0": 10,
#				"param1": 4,
#				"param2": 1,
#				"param3": 1,
#				"param4": 1
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Size",
#					"linked_widgets": [
#						{
#							"node": "buffer",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_2",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution of the curvature map if buffer is used",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "Quality",
#					"linked_widgets": [
#						{
#							"node": "598",
#							"widget": "quality"
#						}
#					],
#					"longdesc": "How many times the input is sampled to generate the curvature map",
#					"name": "param1",
#					"shortdesc": "Quality",
#					"type": "linked_control"
#				},
#				{
#					"label": "Strength",
#					"linked_widgets": [
#						{
#							"node": "598",
#							"widget": "strength"
#						}
#					],
#					"longdesc": "The intensity of the curvature map",
#					"name": "param2",
#					"shortdesc": "Strength",
#					"type": "linked_control"
#				},
#				{
#					"label": "Radius",
#					"linked_widgets": [
#						{
#							"node": "598",
#							"widget": "radius"
#						}
#					],
#					"longdesc": "The radius of the smoothing of the curvature effect",
#					"name": "param3",
#					"shortdesc": "Radius",
#					"type": "linked_control"
#				},
#				{
#					"configurations": {
#						"False": [
#							{
#								"node": "switch",
#								"value": 0,
#								"widget": "source"
#							},
#							{
#								"node": "switch_2",
#								"value": 0,
#								"widget": "source"
#							}
#						],
#						"True": [
#							{
#								"node": "switch",
#								"value": 1,
#								"widget": "source"
#							},
#							{
#								"node": "switch_2",
#								"value": 1,
#								"widget": "source"
#							}
#						]
#					},
#					"label": "Buffer",
#					"linked_widgets": [
#						{
#							"node": "switch",
#							"widget": "source"
#						},
#						{
#							"node": "switch_2",
#							"widget": "source"
#						}
#					],
#					"longdesc": "When set, a buffer is used to sample the input before the normal map filter",
#					"name": "param4",
#					"shortdesc": "Buffer",
#					"type": "config_control"
#				}
#			]
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -135.453888,
#				"y": -518.927429
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The input height map",
#					"name": "Heightmap",
#					"shortdesc": "Input",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 586.203247,
#				"y": -534.919678
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "Shows the generated curvature map",
#					"name": "Curvature",
#					"shortdesc": "Output",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "switch",
#			"node_position": {
#				"x": 310.739746,
#				"y": -451.658417
#			},
#			"parameters": {
#				"choices": 2,
#				"outputs": 1,
#				"source": 1
#			},
#			"type": "switch"
#		},
#		{
#			"name": "buffer_2",
#			"node_position": {
#				"x": 293.839874,
#				"y": -225.201691
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 10
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "switch_2",
#			"node_position": {
#				"x": 312.239838,
#				"y": -129.465912
#			},
#			"parameters": {
#				"choices": 2,
#				"outputs": 1,
#				"source": 1
#			},
#			"type": "switch"
#		},
#		{
#			"name": "blend",
#			"node_position": {
#				"x": 802.064697,
#				"y": -277.727295
#			},
#			"parameters": {
#				"amount": 0.5,
#				"blend_type": 0
#			},
#			"shader_model": {
#				"code": "vec4 $(name_uv)_s1 = $s1($uv);\nvec4 $(name_uv)_s2 = $s2($uv);\nfloat $(name_uv)_a = $amount*$a($uv);\n",
#				"global": "vec3 blend_normal(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*c1 + (1.0-opacity)*c2;\n}\n\nvec3 blend_dissolve(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\tif (rand(uv) < opacity) {\n\t\treturn c1;\n\t} else {\n\t\treturn c2;\n\t}\n}\n\nvec3 blend_multiply(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*c1*c2 + (1.0-opacity)*c2;\n}\n\nvec3 blend_screen(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*(1.0-(1.0-c1)*(1.0-c2)) + (1.0-opacity)*c2;\n}\n\nfloat blend_overlay_f(float c1, float c2) {\n\treturn (c1 < 0.5) ? (2.0*c1*c2) : (1.0-2.0*(1.0-c1)*(1.0-c2));\n}\n\nvec3 blend_overlay(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*vec3(blend_overlay_f(c1.x, c2.x), blend_overlay_f(c1.y, c2.y), blend_overlay_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n}\n\nvec3 blend_hard_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*0.5*(c1*c2+blend_overlay(uv, c1, c2, 1.0)) + (1.0-opacity)*c2;\n}\n\nfloat blend_soft_light_f(float c1, float c2) {\n\treturn (c2 < 0.5) ? (2.0*c1*c2+c1*c1*(1.0-2.0*c2)) : 2.0*c1*(1.0-c2)+sqrt(c1)*(2.0*c2-1.0);\n}\n\nvec3 blend_soft_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*vec3(blend_soft_light_f(c1.x, c2.x), blend_soft_light_f(c1.y, c2.y), blend_soft_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n}\n\nfloat blend_burn_f(float c1, float c2) {\n\treturn (c1==0.0)?c1:max((1.0-((1.0-c2)/c1)),0.0);\n}\n\nvec3 blend_burn(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*vec3(blend_burn_f(c1.x, c2.x), blend_burn_f(c1.y, c2.y), blend_burn_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n}\n\nfloat blend_dodge_f(float c1, float c2) {\n\treturn (c1==1.0)?c1:min(c2/(1.0-c1),1.0);\n}\n\nvec3 blend_dodge(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*vec3(blend_dodge_f(c1.x, c2.x), blend_dodge_f(c1.y, c2.y), blend_dodge_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n}\n\nvec3 blend_lighten(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*max(c1, c2) + (1.0-opacity)*c2;\n}\n\nvec3 blend_darken(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*min(c1, c2) + (1.0-opacity)*c2;\n}\n\nvec3 blend_difference(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\treturn opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;\n}\n",
#				"inputs": [
#					{
#						"default": "vec4(round($uv.x) , 1.0, 1.0, 1.0)",
#						"label": "Source1",
#						"longdesc": "The foreground input",
#						"name": "s1",
#						"shortdesc": "Foreground",
#						"type": "rgba"
#					},
#					{
#						"default": "vec4(1.0, $uv.y, 1.0, 1.0)",
#						"label": "Source2",
#						"longdesc": "The background input",
#						"name": "s2",
#						"shortdesc": "Background",
#						"type": "rgba"
#					},
#					{
#						"default": "1.0",
#						"label": "Opacity",
#						"longdesc": "The optional opacity mask",
#						"name": "a",
#						"shortdesc": "Mask",
#						"type": "f"
#					}
#				],
#				"instance": "",
#				"longdesc": "Blends its input, using an optional mask",
#				"name": "Blend",
#				"outputs": [
#					{
#						"longdesc": "Shows the result of the blend operation",
#						"rgba": "vec4(blend_$blend_type($uv, $(name_uv)_s1.rgb, $(name_uv)_s2.rgb, $(name_uv)_a*$(name_uv)_s1.a), min(1.0, $(name_uv)_s2.a+$(name_uv)_a*$(name_uv)_s1.a))",
#						"shortdesc": "Output",
#						"type": "rgba"
#					}
#				],
#				"parameters": [
#					{
#						"default": 0,
#						"label": "",
#						"longdesc": "The algorithm used to blend the inputs",
#						"name": "blend_type",
#						"shortdesc": "Blend mode",
#						"type": "enum",
#						"values": [
#							{
#								"name": "Normal",
#								"value": "normal"
#							},
#							{
#								"name": "Dissolve",
#								"value": "dissolve"
#							},
#							{
#								"name": "Multiply",
#								"value": "multiply"
#							},
#							{
#								"name": "Screen",
#								"value": "screen"
#							},
#							{
#								"name": "Overlay",
#								"value": "overlay"
#							},
#							{
#								"name": "Hard Light",
#								"value": "hard_light"
#							},
#							{
#								"name": "Soft Light",
#								"value": "soft_light"
#							},
#							{
#								"name": "Burn",
#								"value": "burn"
#							},
#							{
#								"name": "Dodge",
#								"value": "dodge"
#							},
#							{
#								"name": "Lighten",
#								"value": "lighten"
#							},
#							{
#								"name": "Darken",
#								"value": "darken"
#							},
#							{
#								"name": "Difference",
#								"value": "difference"
#							}
#						]
#					},
#					{
#						"control": "None",
#						"default": 0.5,
#						"label": "3:",
#						"longdesc": "The opacity of the blend operation",
#						"max": 1,
#						"min": 0,
#						"name": "amount",
#						"shortdesc": "Opacity",
#						"step": 0.01,
#						"type": "float"
#					}
#				],
#				"shortdesc": "Blend"
#			},
#			"type": "shader"
#		}
#	],
#	"parameters": {
#		"param0": 10,
#		"param1": 4,
#		"param2": 1,
#		"param3": 1,
#		"param4": 1
#	},
#	"shortdesc": "Smooth Curvature",
#	"type": "graph"
#}

#----------------------
#supersample.mmg
#A filter that samples sub-pixel details to make them visible

#		"inputs": [
#			{
#				"default": "vec4(1.0, 1.0, 1.0, 1.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"instance": "vec4 supersample_$(name)(vec2 uv, float size, int count, float width) {\n\tvec4 rv = vec4(0.0);\n\tvec2 step_size = vec2(width)/size/float(count);\n\tuv -= vec2(0.5)/size;\n\tfor (int x = 0; x < count; ++x) {\n\t\tfor (int y = 0; y < count; ++y) {\n\t\t\trv += $in(uv+(vec2(float(x), float(y))+vec2(0.5))*step_size);\n\t\t}\n\t}\n\treturn rv/float(count*count);\n}",
#		"outputs": [
#			{
#				"longdesc": "Shows the supersampled image. Due to the performance cost of this node, it is recommended to connect a buffer directly to this output.",
#				"rgba": "supersample_$(name)($uv, $size, int($count), $width)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 10,
#				"first": 4,
#				"label": "Size",
#				"last": 12,
#				"longdesc": "The resolution of the output",
#				"name": "size",
#				"shortdesc": "Size",
#				"type": "size"
#			},
#			{
#				"control": "None",
#				"default": 2,
#				"label": "Count",
#				"longdesc": "The number of samples on each axis. High values will badly impact performances.",
#				"max": 5,
#				"min": 2,
#				"name": "count",
#				"shortdesc": "Count",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Width",
#				"longdesc": "The width of the sampled area. Setting this value higher than 1 will sample neighbouring pixels and antialias the result.",
#				"max": 2,
#				"min": 1,
#				"name": "width",
#				"shortdesc": "Width",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#swap_channels.mmg
#Swaps the channels of its RGBA input

#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"label": "",
#				"longdesc": "The input RGBA image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The output RGBA image",
#				"rgba": "vec4($out_r,$out_g,$out_b,$out_a)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 2,
#				"label": "R",
#				"longdesc": "The input channel to be assigned to the Red channel",
#				"name": "out_r",
#				"shortdesc": "Red",
#				"type": "enum",
#				"values": [
#					{
#						"name": "0",
#						"value": "0.0"
#					},
#					{
#						"name": "1",
#						"value": "1.0"
#					},
#					{
#						"name": "R",
#						"value": "$in($uv).r"
#					},
#					{
#						"name": "-R",
#						"value": "1.0-$in($uv).r"
#					},
#					{
#						"name": "G",
#						"value": "$in($uv).g"
#					},
#					{
#						"name": "-G",
#						"value": "1.0-$in($uv).g"
#					},
#					{
#						"name": "B",
#						"value": "$in($uv).b"
#					},
#					{
#						"name": "-B",
#						"value": "1.0-$in($uv).b"
#					},
#					{
#						"name": "A",
#						"value": "$in($uv).a"
#					},
#					{
#						"name": "-A",
#						"value": "1.0-$in($uv).a"
#					}
#				]
#			},
#			{
#				"default": 4,
#				"label": "G",
#				"longdesc": "The input channel to be assigned to the Green channel",
#				"name": "out_g",
#				"shortdesc": "Green",
#				"type": "enum",
#				"values": [
#					{
#						"name": "0",
#						"value": "0.0"
#					},
#					{
#						"name": "1",
#						"value": "1.0"
#					},
#					{
#						"name": "R",
#						"value": "$in($uv).r"
#					},
#					{
#						"name": "-R",
#						"value": "1.0-$in($uv).r"
#					},
#					{
#						"name": "G",
#						"value": "$in($uv).g"
#					},
#					{
#						"name": "-G",
#						"value": "1.0-$in($uv).g"
#					},
#					{
#						"name": "B",
#						"value": "$in($uv).b"
#					},
#					{
#						"name": "-B",
#						"value": "1.0-$in($uv).b"
#					},
#					{
#						"name": "A",
#						"value": "$in($uv).a"
#					},
#					{
#						"name": "-A",
#						"value": "1.0-$in($uv).a"
#					}
#				]
#			},
#			{
#				"default": 6,
#				"label": "B",
#				"longdesc": "The input channel to be assigned to the Blue channel",
#				"name": "out_b",
#				"shortdesc": "Blue",
#				"type": "enum",
#				"values": [
#					{
#						"name": "0",
#						"value": "0.0"
#					},
#					{
#						"name": "1",
#						"value": "1.0"
#					},
#					{
#						"name": "R",
#						"value": "$in($uv).r"
#					},
#					{
#						"name": "-R",
#						"value": "1.0-$in($uv).r"
#					},
#					{
#						"name": "G",
#						"value": "$in($uv).g"
#					},
#					{
#						"name": "-G",
#						"value": "1.0-$in($uv).g"
#					},
#					{
#						"name": "B",
#						"value": "$in($uv).b"
#					},
#					{
#						"name": "-B",
#						"value": "1.0-$in($uv).b"
#					},
#					{
#						"name": "A",
#						"value": "$in($uv).a"
#					},
#					{
#						"name": "-A",
#						"value": "1.0-$in($uv).a"
#					}
#				]
#			},
#			{
#				"default": 8,
#				"label": "A",
#				"longdesc": "The input channel to be assigned to the Alpha channel",
#				"name": "out_a",
#				"shortdesc": "Alpha",
#				"type": "enum",
#				"values": [
#					{
#						"name": "0",
#						"value": "0.0"
#					},
#					{
#						"name": "1",
#						"value": "1.0"
#					},
#					{
#						"name": "R",
#						"value": "$in($uv).r"
#					},
#					{
#						"name": "-R",
#						"value": "1.0-$in($uv).r"
#					},
#					{
#						"name": "G",
#						"value": "$in($uv).g"
#					},
#					{
#						"name": "-G",
#						"value": "1.0-$in($uv).g"
#					},
#					{
#						"name": "B",
#						"value": "$in($uv).b"
#					},
#					{
#						"name": "-B",
#						"value": "1.0-$in($uv).b"
#					},
#					{
#						"name": "A",
#						"value": "$in($uv).a"
#					},
#					{
#						"name": "-A",
#						"value": "1.0-$in($uv).a"
#					}
#				]
#			}
#		],

#----------------------
#math_v3.mmg
#Performs a math operation using its inputs or parameter values

#		"code": "vec3 $(name_uv)_clamp_false = $op;\nvec3 $(name_uv)_clamp_true = clamp($(name_uv)_clamp_false, vec3(0.0), vec3(1.0));\n",
#		"inputs": [
#			{
#				"default": "vec3($d_in1_x, $d_in1_y, $d_in1_z)",
#				"label": "2:A",
#				"longdesc": "The A operand",
#				"name": "in1",
#				"shortdesc": "A",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3($d_in2_x, $d_in2_y, $d_in2_z)",
#				"label": "B",
#				"longdesc": "The B operand",
#				"name": "in2",
#				"shortdesc": "B",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows a greyscale image of the result",
#				"rgb": "$(name_uv)_clamp_$clamp",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"default": 19,
#				"label": "",
#				"longdesc": "The operation to be performed",
#				"name": "op",
#				"shortdesc": "Operation",
#				"type": "enum",
#				"values": [
#					{
#						"name": "A+B",
#						"value": "$in1($uv)+$in2($uv)"
#					},
#					{
#						"name": "A-B",
#						"value": "$in1($uv)-$in2($uv)"
#					},
#					{
#						"name": "A*B",
#						"value": "$in1($uv)*$in2($uv)"
#					},
#					{
#						"name": "A/B",
#						"value": "$in1($uv)/$in2($uv)"
#					},
#					{
#						"name": "log(A)",
#						"value": "log($in1($uv))"
#					},
#					{
#						"name": "log2(A)",
#						"value": "log2($in1($uv))"
#					},
#					{
#						"name": "pow(A, B)",
#						"value": "pow($in1($uv),$in2($uv))"
#					},
#					{
#						"name": "abs(A)",
#						"value": "abs($in1($uv))"
#					},
#					{
#						"name": "round(A)",
#						"value": "round($in1($uv))"
#					},
#					{
#						"name": "floor(A)",
#						"value": "floor($in1($uv))"
#					},
#					{
#						"name": "ceil(A)",
#						"value": "ceil($in1($uv))"
#					},
#					{
#						"name": "trunc(A)",
#						"value": "trunc($in1($uv))"
#					},
#					{
#						"name": "fract(A)",
#						"value": "fract($in1($uv))"
#					},
#					{
#						"name": "min(A, B)",
#						"value": "min($in1($uv),$in2($uv))"
#					},
#					{
#						"name": "max(A, B)",
#						"value": "max($in1($uv),$in2($uv))"
#					},
#					{
#						"name": "A<B",
#						"value": "step($in1($uv),$in2($uv))"
#					},
#					{
#						"name": "cos(A*B)",
#						"value": "cos($in1($uv)*$in2($uv))"
#					},
#					{
#						"name": "sin(A*B)",
#						"value": "sin($in1($uv)*$in2($uv))"
#					},
#					{
#						"name": "tan(A*B)",
#						"value": "tan($in1($uv)*$in2($uv))"
#					},
#					{
#						"name": "sqrt(1-A²)",
#						"value": "sqrt(vec3(1.0)-$in1($uv)*$in1($uv))"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The default value for A, used if the corresponding input is not connected",
#				"max": 1,
#				"min": 0,
#				"name": "d_in1_x",
#				"shortdesc": "Default A",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "2:",
#				"longdesc": "The default value for B, used if the corresponding input is not connected",
#				"max": 1,
#				"min": 0,
#				"name": "d_in1_y",
#				"shortdesc": "Default B",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "2:",
#				"max": 1,
#				"min": 0,
#				"name": "d_in1_z",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"max": 1,
#				"min": 0,
#				"name": "d_in2_x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "3:",
#				"max": 1,
#				"min": 0,
#				"name": "d_in2_y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "3:",
#				"max": 1,
#				"min": 0,
#				"name": "d_in2_z",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Clamp result",
#				"longdesc": "The result is clamped to [0, 1] if this option is checked",
#				"name": "clamp",
#				"shortdesc": "Clamp",
#				"type": "boolean"
#			}
#		],

#vec3 rgb_to_hsv(vec3 c) {
#	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
#	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
#	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
#
#	float d = q.x - min(q.w, q.y);
#	float e = 1.0e-10;
#	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
#}


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

#vec3 hsv_to_rgb(vec3 c) {
#	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
#	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
#	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
#}

static func hsv_to_rgb(c : Vector3) -> Vector3:
	var K : Color = Color(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	
	var p : Vector3 = absv3(fractv3(Vector3(c.x, c.x, c.x) + Vector3(K.r, K.g, K.b)) * 6.0 - Vector3(K.a, K.a, K.a));
	
	return c.z * lerp(Vector3(K.r, K.r, K.r), clampv3(p - Vector3(K.r, K.r, K.r), Vector3(), Vector3(1, 1, 1)), c.y);

#adjust_hsv.mmg

#vec4 $(name_uv)_rbga = $in($(uv));
#vec3 $(name_uv)_hsv = rgb_to_hsv($(name_uv)_rbga.rgb);
#$(name_uv)_hsv.x += $(hue);
#$(name_uv)_hsv.y = clamp($(name_uv)_hsv.y*$(saturation), 0.0, 1.0);
#$(name_uv)_hsv.z = clamp($(name_uv)_hsv.z*$(value), 0.0, 1.0);

#hue, min: -0.5, max: 0.5, step: 0, default: 0
#saturation, min: 0, max: 2, step: 0, default: 1
#value, min: 0, max: 2, step: 0, default: 1

#output: vec4(hsv_to_rgb($(name_uv)_hsv), $(name_uv)_rbga.a)

static func adjust_hsv(color : Color, hue : float, saturation : float, value : float) -> Color:
	var hsv : Vector3 = rgb_to_hsv(Vector3(color.r, color.g, color.b));
	
	hsv.x += hue
	hsv.y = clamp(hsv.y * saturation, 0.0, 1.0)
	hsv.z = clamp(hsv.z * value, 0.0, 1.0)
	
	var h : Vector3 = hsv_to_rgb(hsv)

	return Color(h.x, h.y, h.z, color.a);

#brightness, min: -1, max: 1, step: 0.01, default: 0
#contrast, min: -1, max: 1, step: 0.01, default: 1

#input: default: vec4(0.5 ,0.5, 0.5, 1.0) -> img

#output: vec4(clamp($in($uv).rgb*$contrast+vec3($brightness)+0.5-$contrast*0.5, vec3(0.0), vec3(1.0)), $in($uv).a)

static func brightness_contrast(color : Color, brightness : float, contrast : float) -> Color:
	#output: vec4(clamp( $in($uv).rgb*$contrast + vec3($brightness) + 0.5 - $contrast*0.5, vec3(0.0), vec3(1.0)), $in($uv).a)
	
	var cvv : Vector3 = Vector3(color.r, color.g, color.b) * contrast
	
	var cv : Vector3 = cvv + Vector3(brightness, brightness, brightness) + Vector3(0.5, 0.5, 0.5) - Vector3(contrast, contrast, contrast) * 0.5
	
	var v : Vector3 = clampv3(cv, Vector3(), Vector3(1, 1, 1))
	
	return Color(v.x, v.y, v.z, color.a);

#greyscale

#input: default: vec3(0.0). (Image)
#output: gs_$mode($in($uv))
#mode: enum: Lightness, Average, Luminosity, Min, Max. default: 4

#float gs_min(vec3 c) {
#	return min(c.r, min(c.g, c.b));
#}

static func grayscale_min(c : Vector3) -> float:
	return min(c.x, min(c.y, c.z));

#float gs_max(vec3 c) {
#	return max(c.r, max(c.g, c.b));
#}

static func grayscale_max(c : Vector3) -> float:
	return max(c.x, max(c.y, c.z));

#float gs_lightness(vec3 c) {
#	return 0.5*(max(c.r, max(c.g, c.b)) + min(c.r, min(c.g, c.b)));
#}

static func grayscale_lightness(c : Vector3) -> float:
	return 0.5*(max(c.x, max(c.y, c.z)) + min(c.x, min(c.y, c.z)));

#float gs_average(vec3 c) {
#	return 0.333333333333*(c.r + c.g + c.b);
#}

static func grayscale_average(c : Vector3) -> float:
	return 0.333333333333*(c.x + c.y + c.z);

#float gs_luminosity(vec3 c) {
#	return 0.21 * c.r + 0.72 * c.g + 0.07 * c.b;
#}

static func grayscale_luminosity(c : Vector3) -> float:
	return 0.21 * c.x + 0.72 * c.y + 0.07 * c.z;

static func invert(color : Color) -> Color:
	return Color(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);

#vec3 blend_normal(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*c1 + (1.0-opacity)*c2;\n
#}

static func blend_normal(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * c1 + (1.0 - opacity) * c2

#vec3 blend_dissolve(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	if (rand(uv) < opacity) {\n\t\t
#		return c1;\n\t
#	} else {\n\t\t
#		return c2;\n\t
#	}\n
#}

static func blend_dissolve(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	if (rand2(uv) < Vector2(opacity, opacity)):
		return c1
	else:
		return c2
	
#vec3 blend_multiply(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*c1*c2 + (1.0-opacity)*c2;\n
#}

static func blend_multiply(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * c1 * c2 + (1.0 - opacity) * c2

#vec3 blend_screen(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*(1.0-(1.0-c1)*(1.0-c2)) + (1.0-opacity)*c2;\n
#}

static func blend_screen(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * (Vector3(1, 1, 1) - (Vector3(1, 1, 1) - c1) * (Vector3(1, 1, 1) - c2)) + (1.0 - opacity) * c2

#float blend_overlay_f(float c1, float c2) {\n\t
#	return (c1 < 0.5) ? (2.0*c1*c2) : (1.0-2.0*(1.0-c1)*(1.0-c2));\n
#}

static func blend_overlay_f(c1 : float, c2 : float) -> float:
	if (c1 < 0.5):
		return (2.0 * c1 * c2)
	else:
		return (1.0 - 2.0 * (1.0 - c1) * (1.0 - c2))

#vec3 blend_overlay(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend_overlay_f(c1.x, c2.x), blend_overlay_f(c1.y, c2.y), blend_overlay_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}
	
static func blend_overlay(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * Vector3(blend_overlay_f(c1.x, c2.x), blend_overlay_f(c1.y, c2.y), blend_overlay_f(c1.z, c2.z)) + (1.0 - opacity) * c2

#vec3 blend_hard_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*0.5*(c1*c2+blend_overlay(uv, c1, c2, 1.0)) + (1.0-opacity)*c2;\n
#}

static func blend_hard_light(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * 0.5 * (c1 * c2 + blend_overlay(uv, c1, c2, 1.0)) + (1.0 - opacity) * c2

#float blend_soft_light_f(float c1, float c2) {\n\t
#	return (c2 < 0.5) ? (2.0*c1*c2+c1*c1*(1.0-2.0*c2)) : 2.0*c1*(1.0-c2)+sqrt(c1)*(2.0*c2-1.0);\n
#}

static func blend_soft_light_f(c1 : float, c2 : float) -> float:
	if (c2 < 0.5):
		return (2.0 * c1 * c2 + c1 * c1 * (1.0 - 2.0 * c2))
	else:
		return 2.0 * c1 * (1.0 - c2) + sqrt(c1) * (2.0 * c2 - 1.0)

#vec3 blend_soft_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend_soft_light_f(c1.x, c2.x), blend_soft_light_f(c1.y, c2.y), blend_soft_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}

static func blend_soft_light(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * Vector3(blend_soft_light_f(c1.x, c2.x), blend_soft_light_f(c1.y, c2.y), blend_soft_light_f(c1.z, c2.z)) + (1.0 - opacity) * c2

#float blend_burn_f(float c1, float c2) {\n\t
#	return (c1==0.0)?c1:max((1.0-((1.0-c2)/c1)),0.0);\n
#}

static func blend_burn_f(c1 : float, c2 : float) -> float:
	if (c1 == 0.0):
		return c1
	else:
		return max((1.0 - ((1.0 - c2) / c1)), 0.0)

#vec3 blend_burn(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend_burn_f(c1.x, c2.x), blend_burn_f(c1.y, c2.y), blend_burn_f(c1.z, c2.z)) + (1.0-opacity)*c2;
#}

static func blend_burn(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * Vector3(blend_burn_f(c1.x, c2.x), blend_burn_f(c1.y, c2.y), blend_burn_f(c1.z, c2.z)) + (1.0 - opacity) * c2

#float blend_dodge_f(float c1, float c2) {\n\t
#	return (c1==1.0)?c1:min(c2/(1.0-c1),1.0);\n
#}

static func blend_dodge_f(c1 : float, c2 : float) -> float:
	if (c1==1.0):
		return c1
	else:
		return min(c2 / (1.0 - c1), 1.0)

#vec3 blend_dodge(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend_dodge_f(c1.x, c2.x), blend_dodge_f(c1.y, c2.y), blend_dodge_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}

static func blend_dodge(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * Vector3(blend_dodge_f(c1.x, c2.x), blend_dodge_f(c1.y, c2.y), blend_dodge_f(c1.z, c2.z)) + (1.0 - opacity) * c2

#vec3 blend_lighten(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*max(c1, c2) + (1.0-opacity)*c2;\n
#}

static func blend_lighten(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * maxv3(c1, c2) + (1.0 - opacity) * c2

#vec3 blend_darken(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*min(c1, c2) + (1.0-opacity)*c2;\n
#}

static func blend_darken(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * minv3(c1, c2) + (1.0 - opacity) * c2

#vec3 blend_difference(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;\n
#}

static func blend_difference(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * clampv3(c2 - c1, Vector3(), Vector3(1, 1, 1)) + (1.0 - opacity) * c2

#vec4 adjust_levels(vec4 input, vec4 in_min, vec4 in_mid, vec4 in_max, vec4 out_min, vec4 out_max) {\n\t
#	input = clamp((input-in_min)/(in_max-in_min), 0.0, 1.0);\n\t
#	in_mid = (in_mid-in_min)/(in_max-in_min);\n\t
#	vec4 dark = step(in_mid, input);\n\t
#
#	input = 0.5*mix(input/(in_mid), 1.0+(input-in_mid)/(1.0-in_mid), dark);\n\t
#	return out_min+input*(out_max-out_min);\n
#}

# === GRADIENTS.GD =====


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
	return gradient_type_1(fractf(repeat * 1.41421356237* (fractv2(uv) - Vector2(0.5, 0.5)).length()), data)

static func radial_gradient_type_2(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_2(fractf(repeat * 1.41421356237* (fractv2(uv) - Vector2(0.5, 0.5)).length()), data)
	
static func radial_gradient_type_3(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_3(fractf(repeat * 1.41421356237* (fractv2(uv) - Vector2(0.5, 0.5)).length()), data)
	
static func radial_gradient_type_4(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_4(fractf(repeat * 1.41421356237* (fractv2(uv) - Vector2(0.5, 0.5)).length()), data)



static func normal_gradient_type_1(uv : Vector2, repeat : float, rotate : float, data : PoolRealArray) -> Color:
	var rr : float = 0.5+(cos(rotate*0.01745329251)*(uv.x-0.5)+sin(rotate*0.01745329251)*(uv.y-0.5))/(cos(abs(modf(rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
	return gradient_type_1(fractf(rr * repeat), data)

static func normal_gradient_type_2(uv : Vector2, repeat : float, rotate : float, data : PoolRealArray) -> Color:
	var rr : float = 0.5+(cos(rotate*0.01745329251)*(uv.x-0.5)+sin(rotate*0.01745329251)*(uv.y-0.5))/(cos(abs(modf(rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
	return gradient_type_2(fractf(rr * repeat), data)
	
static func normal_gradient_type_3(uv : Vector2, repeat : float, rotate : float, data : PoolRealArray) -> Color:
	var rr : float = 0.5+(cos(rotate*0.01745329251)*(uv.x-0.5)+sin(rotate*0.01745329251)*(uv.y-0.5))/(cos(abs(modf(rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
	return gradient_type_3(fractf(rr * repeat), data)
	
static func normal_gradient_type_4(uv : Vector2, repeat : float, rotate : float, data : PoolRealArray) -> Color:
	var rr : float = 0.5+(cos(rotate*0.01745329251)*(uv.x-0.5)+sin(rotate*0.01745329251)*(uv.y-0.5))/(cos(abs(modf(rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
	return gradient_type_4(fractf(rr * repeat), data)



static func circular_gradient_type_1(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_1(fractf(repeat * 0.15915494309 * atan2((uv.y - 0.5), uv.x - 0.5)), data)

static func circular_gradient_type_2(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_2(fractf(repeat * 0.15915494309 * atan2((uv.y - 0.5), uv.x - 0.5)), data)
	
static func circular_gradient_type_3(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_3(fractf(repeat * 0.15915494309 * atan2((uv.y - 0.5), uv.x - 0.5)), data)
	
static func circular_gradient_type_4(uv : Vector2, repeat : float, data : PoolRealArray) -> Color:
	return gradient_type_4(fractf(repeat * 0.15915494309 * atan2((uv.y - 0.5), uv.x - 0.5)), data)


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

# ==== MWF.GD========


#----------------------
#mwf_create_map.mmg
#Creates a workflow map using a heightmap and an optional seed map. The workflow map contains height information as well as orientation and a seed for random offset for the material it will be applied to.

#		"inputs": [
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "The input height map",
#				"name": "h",
#				"shortdesc": "Height",
#				"type": "f"
#			},
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The input offset seed map",
#				"name": "o",
#				"shortdesc": "Offset",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated workflow map, to be connected to a MixMap or an ApplyMap node",
#				"rgb": "vec3($height*$h($uv), $angle*0.00277777777+0.5, rand(vec2(float($seed)+$o($uv))))",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Height",
#				"longdesc": "The maximum height of the workflow map, used as multiplier for the input height map",
#				"max": 1,
#				"min": 0,
#				"name": "height",
#				"shortdesc": "Height",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Angle",
#				"longdesc": "The angle stored in the workflow map",
#				"max": 180,
#				"min": -180,
#				"name": "angle",
#				"shortdesc": "Angle",
#				"step": 0.1,
#				"type": "float"
#			}
#		],

#----------------------
#mwf_mix_maps.mmg
#Mixes up to 4 workflow maps, to be used with the same base material

#		"inputs": [
#			{
#				"default": "vec3(0.0)",
#				"label": "",
#				"longdesc": "The first workflow map",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "",
#				"longdesc": "The second workflow map",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "",
#				"longdesc": "The third input map",
#				"name": "in3",
#				"shortdesc": "Input3",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "",
#				"longdesc": "The fourth input map",
#				"name": "in4",
#				"shortdesc": "Input4",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Generates a merged workflow map",
#				"rgb": "matmap_mix(matmap_mix($in1($uv), $in2($uv)), matmap_mix($in3($uv), $in4($uv)))",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],

#----------------------
#mwf_map.mmg
#"Applies a workflow map to a base material, and generates height information as well as PBR channels for the result.\nThe height input must be connected to a Create Map or Mix Maps node. The other inputs must be connected to a base material.\nThe outputs must be connected to the Mix or the Output node, or a workflow filter node.

#		"code": "float $(name_uv)_angle = 6.28318530718*($map($uv).y-0.5);\nvec2 $(name_uv)_uv = matmap_uv($uv, $(name_uv)_angle, $map($uv).z);\n",
#		"inputs": [
#			{
#				"default": "vec3(1.0, 0.5, 0.0)",
#				"label": "Map",
#				"longdesc": "The input workflow map",
#				"name": "map",
#				"shortdesc": "Map",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"group_size": 4,
#				"label": "Albedo",
#				"longdesc": "The Albedo channel of the input base material",
#				"name": "mat1",
#				"shortdesc": "Albedo",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "ORM",
#				"longdesc": "The ambient occlusion, roughness and metallic channels of the input material",
#				"name": "mat2",
#				"shortdesc": "ORM",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "Emission",
#				"longdesc": "The emission channel of the input material",
#				"name": "mat3",
#				"shortdesc": "Emission",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.5, 0.5, 1.0)",
#				"label": "Normal",
#				"longdesc": "The normal map of the input material",
#				"name": "mat4",
#				"shortdesc": "Normal",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$map($uv).x",
#				"group_size": 5,
#				"longdesc": "The height map of the result",
#				"shortdesc": "Height",
#				"type": "f"
#			},
#			{
#				"longdesc": "The albedo channel of the result",
#				"rgb": "$mat1($(name_uv)_uv)",
#				"shortdesc": "Albedo",
#				"type": "rgb"
#			},
#			{
#				"longdesc": "The ambient occlusion, roughness and metallic channels of the result",
#				"rgb": "$mat2($(name_uv)_uv)",
#				"shortdesc": "ORM",
#				"type": "rgb"
#			},
#			{
#				"longdesc": "The emission channel of the result",
#				"rgb": "$mat3($(name_uv)_uv)",
#				"shortdesc": "Emission",
#				"type": "rgb"
#			},
#			{
#				"longdesc": "The normal map of the result",
#				"rgb": "matmap_rotate_nm($mat4($(name_uv)_uv), -$(name_uv)_angle)",
#				"shortdesc": "Normal",
#				"type": "rgb"
#			}
#		],

#----------------------
#mwf_mix.mmg
#Combines the outputs of 2 mapped base materials (keeping the \"highest\" material).

#		"code": "float $(name_uv)_a1 = step($h1($uv), $h2($uv));",
#		"inputs": [
#			{
#				"default": "0.0",
#				"group_size": 5,
#				"label": "Height 1",
#				"longdesc": "The height map of the first input",
#				"name": "h1",
#				"shortdesc": "Height1",
#				"type": "f"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "Albedo 1",
#				"longdesc": "The albedo channel of the first input",
#				"name": "c1",
#				"shortdesc": "Albedo1",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "ORM 1",
#				"longdesc": "The ambient occlusion, roughness and metallic channels of the first input",
#				"name": "orm1",
#				"shortdesc": "ORM1",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "Emission 1",
#				"longdesc": "The emission channel of the first input",
#				"name": "em1",
#				"shortdesc": "Emission1",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.5, 0.5, 1.0)",
#				"label": "Normal 1",
#				"longdesc": "The normal map of the first input",
#				"name": "nm1",
#				"shortdesc": "Normal1",
#				"type": "rgb"
#			},
#			{
#				"default": "0.0",
#				"group_size": 5,
#				"label": "Height 2",
#				"longdesc": "The height map of the second input",
#				"name": "h2",
#				"shortdesc": "Height2",
#				"type": "f"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "Albedo 2",
#				"longdesc": "The albedo channel of the second input",
#				"name": "c2",
#				"shortdesc": "Albedo2",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "ORM 2",
#				"longdesc": "The ambient occlusion, roughness and metallic channels of the second input",
#				"name": "orm2",
#				"shortdesc": "ORM2",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "Emission 2",
#				"longdesc": "The emission channel of the second input",
#				"name": "em2",
#				"shortdesc": "Emission2",
#				"type": "rgb"
#			},
#			{
#				"default": "vec3(0.5, 0.5, 1.0)",
#				"label": "Normal 2",
#				"longdesc": "The normal map of the second input",
#				"name": "nm2",
#				"shortdesc": "Normal2",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"f": "max($h1($uv), $h2($uv))",
#				"group_size": 5,
#				"longdesc": "Generates the height of the result",
#				"shortdesc": "Height",
#				"type": "f"
#			},
#			{
#				"longdesc": "Shows the output albedo channel",
#				"rgb": "mix($c1($uv), $c2($uv), $(name_uv)_a1)",
#				"shortdesc": "Albedo",
#				"type": "rgb"
#			},
#			{
#				"longdesc": "Shows the output ambient occlusion, roughness and metallic channels",
#				"rgb": "mix($orm1($uv), $orm2($uv), $(name_uv)_a1)",
#				"shortdesc": "ORM",
#				"type": "rgb"
#			},
#			{
#				"longdesc": "Shows the output emission channel",
#				"rgb": "mix($em1($uv), $em2($uv), $(name_uv)_a1)",
#				"shortdesc": "Emission",
#				"type": "rgb"
#			},
#			{
#				"longdesc": "Shows the output normal map",
#				"rgb": "mix($nm1($uv), $nm2($uv), $(name_uv)_a1)",
#				"shortdesc": "Normal",
#				"type": "rgb"
#			}
#		],


#----------------------
#mwf_output.mmg

#{
#	"connections": [
#		{
#			"from": "colorize_3",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 6
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "colorize_3",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "occlusion",
#			"to_port": 0
#		},
#		{
#			"from": "occlusion",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 5
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 2,
#			"to": "decompose",
#			"to_port": 0
#		},
#		{
#			"from": "decompose",
#			"from_port": 1,
#			"to": "gen_outputs",
#			"to_port": 2
#		},
#		{
#			"from": "decompose",
#			"from_port": 2,
#			"to": "gen_outputs",
#			"to_port": 1
#		},
#		{
#			"from": "blend_2",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 4
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 1,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 3,
#			"to": "gen_outputs",
#			"to_port": 3
#		},
#		{
#			"from": "brightness_contrast",
#			"from_port": 0,
#			"to": "blend_2",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 4,
#			"to": "brightness_contrast",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "normal_map_2",
#			"to_port": 0
#		},
#		{
#			"from": "normal_map_2",
#			"from_port": 0,
#			"to": "blend_2",
#			"to_port": 1
#		}
#	],
#	"label": "Output",
#	"longdesc": "Converts a workflow mapped material (from an Apply Map or a Mix node) for a Material node",
#	"name": "mwf_output",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "colorize_3",
#			"node_position": {
#				"x": -939.637451,
#				"y": 871.842407
#			},
#			"parameters": {
#				"gradient": {
#					"interpolation": 1,
#					"points": [
#						{
#							"a": 1,
#							"b": 1,
#							"g": 1,
#							"pos": 0,
#							"r": 1
#						},
#						{
#							"a": 1,
#							"b": 0,
#							"g": 0,
#							"pos": 1,
#							"r": 0
#						}
#					],
#					"type": "Gradient"
#				}
#			},
#			"type": "colorize"
#		},
#		{
#			"name": "occlusion",
#			"node_position": {
#				"x": -994.845825,
#				"y": 786.968262
#			},
#			"parameters": {
#				"param0": 10,
#				"param2": 1
#			},
#			"type": "occlusion"
#		},
#		{
#			"name": "decompose",
#			"node_position": {
#				"x": -924.371338,
#				"y": 570.25
#			},
#			"parameters": {
#
#			},
#			"type": "decompose"
#		},
#		{
#			"name": "blend_2",
#			"node_position": {
#				"x": -931.305542,
#				"y": 677.328491
#			},
#			"parameters": {
#				"amount": 1,
#				"blend_type": 4
#			},
#			"type": "blend"
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -1626.805542,
#				"y": 608.758606
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 5,
#					"name": "Height",
#					"type": "f"
#				},
#				{
#					"group_size": 0,
#					"name": "Albedo",
#					"type": "rgb"
#				},
#				{
#					"group_size": 0,
#					"name": "ORM",
#					"type": "rgb"
#				},
#				{
#					"group_size": 0,
#					"name": "Emission",
#					"type": "rgb"
#				},
#				{
#					"group_size": 0,
#					"name": "Normal",
#					"type": "rgb"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": -635.305542,
#				"y": 597.758606
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 7,
#					"longdesc": "",
#					"name": "Albedo",
#					"shortdesc": "Albedo",
#					"type": "rgb"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "",
#					"name": "Metallic",
#					"shortdesc": "Metallic",
#					"type": "f"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "",
#					"name": "Roughness",
#					"shortdesc": "Roughness",
#					"type": "f"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "",
#					"name": "Emission",
#					"shortdesc": "Emission",
#					"type": "rgb"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "",
#					"name": "Normal",
#					"shortdesc": "Normal",
#					"type": "rgb"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "",
#					"name": "Occlusion",
#					"shortdesc": "Occlusion",
#					"type": "f"
#				},
#				{
#					"group_size": 0,
#					"longdesc": "",
#					"name": "Depth",
#					"shortdesc": "Depth",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -1104.881836,
#				"y": 425.25
#			},
#			"parameters": {
#				"param0": 1,
#				"param2": 1
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Occlusion",
#					"linked_widgets": [
#						{
#							"node": "occlusion",
#							"widget": "param2"
#						}
#					],
#					"longdesc": "The strength of the calculated occlusion effect",
#					"name": "param2",
#					"shortdesc": "Occlusion",
#					"type": "linked_control"
#				},
#				{
#					"label": "Mat Normal",
#					"linked_widgets": [
#						{
#							"node": "blend_2",
#							"widget": "amount"
#						}
#					],
#					"longdesc": "The strength of  normals from the base materials (compared to the normal generated from height information))",
#					"name": "param0",
#					"shortdesc": "MatNormal",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "brightness_contrast",
#			"node_position": {
#				"x": -1177.223877,
#				"y": 677.062317
#			},
#			"parameters": {
#				"brightness": 0,
#				"contrast": 1
#			},
#			"type": "brightness_contrast"
#		},
#		{
#			"name": "normal_map_2",
#			"node_position": {
#				"x": -1152.5,
#				"y": 544.75
#			},
#			"parameters": {
#				"param0": 10,
#				"param1": 1.02,
#				"param2": 0,
#				"param4": 1
#			},
#			"type": "normal_map"
#		}
#	],
#	"parameters": {
#		"param0": 1,
#		"param2": 1
#	},
#	"shortdesc": "Output",
#	"type": "graph"
#}

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg

#----------------------
#edge_detect.mmg


#vec3 matmap_mix(vec3 in1, vec3 in2) {\n\t
#	float is_in1 = step(in2.x, in1.x);\n\t
#	//return vec3(max(in1.x, in2.x), in1.yz*is_in1+in2.yz*(1.0-is_in1));\n\t
#	return vec3(max(in1.x, in2.x), mix(in2.yz, in1.yz, is_in1));\n
#}
		
#vec2 matmap_uv(vec2 uv, float angle, float seed) {\n\t
#	uv -= vec2(0.5);\n\tvec2 rv;\n\t
#	rv.x = uv.x*cos(angle)+uv.y*sin(angle);\n\t
#	rv.y = -uv.x*sin(angle)+uv.y*cos(angle);\n\t
#	return fract(rv + rand2(vec2(seed)));\n
#}
	
#vec3 matmap_rotate_nm(vec3 input, float angle) {\n\t
#	vec2 uv = input.xy - vec2(0.5);\n\t
#	vec2 rv;\n\t
#	rv.x = uv.x*cos(angle)+uv.y*sin(angle);\n\t
#	rv.y = -uv.x*sin(angle)+uv.y*cos(angle);\n\t
#	return vec3(rv + vec2(0.5), input.z);\n
#}
		
# ======= NOISES.GD ====


#----------------------
#color_noise.mmg

#Outputs:

#Output - (rgb) - Shows the noise pattern
#color_dots($(uv), 1.0/$(size), $(seed))

#Inputs:
#size, float, default: 8, min: 2, max: 12, step: 1

#----------------------
#noise.mmg

#Outputs:

#float $(name)_f(vec2 uv) {
#	return dots(uv, 1.0/$(size), $(density), $(seed));
#}

#Output - (float) - Shows the noise pattern
#$(name)_f($(uv))

#Inputs:
#grid_size, float, default: 4, min: 2, max: 12, step: 1
#density, float, default: 0.5, min: 0, max: 1, step: 0.01

#----------------------
#noise_anisotropic.mmg
#Generates x-axis interpolated value noise

#Output:
#Output (float) - Shows a greyscale value noise
#anisotropic($(uv), vec2($(scale_x), $(scale_y)), $(seed), $(smoothness), $(interpolation))

#Input:
#scale, Vector2, min: 1, 1, max: 32, 1024, step: 1, 1, default 4, 256
#smoothness, float, min: 0, max: 1, step: 0,01, default: 1
#Interpolation, float, min: 0, max: 1, step: 0,01, default: 1

#float dots(vec2 uv, float size, float density, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
#	uv /= size;
#	vec2 point_pos = floor(uv)+vec2(0.5);
#	float color = step(rand(seed2+point_pos), density);    
#	return color;
#}

static func dots(uv : Vector2, size : float, density : float, pseed : float) -> float:
	var seed2 : Vector2 = rand2(Vector2(pseed, 1.0 - pseed))
	uv /= size
	var point_pos : Vector2 = floorv2(uv) + Vector2(0.5, 0.5)
	var color : float = step(rand2(seed2 + point_pos).x, density);   
	return color

static func anisotropicc(uv : Vector2, size : Vector2, pseed : float, smoothness : float, interpolation : float) -> Color:
	var v : float = anisotropic(uv, size, pseed, smoothness, interpolation)

	return Color(v, v, v, 1)

#float anisotropic(vec2 uv, vec2 size, float seed, float smoothness, float interpolation) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
#	vec2 xy = floor(uv*size);
#	vec2 offset = vec2(rand(seed2 + xy.y), 0.0);
#	vec2 xy_offset = floor(uv * size + offset );    
#
#	float f0 = rand(seed2+mod(xy_offset, size));    
#	float f1 = rand(seed2+mod(xy_offset+vec2(1.0, 0.0), size));
#	float mixer = clamp( (fract(uv.x*size.x+offset.x) -.5) / smoothness + 0.5, 0.0, 1.0 );    
#	float smooth_mix = smoothstep(0.0, 1.0, mixer);
#	float linear = mix(f0, f1, mixer);
#	float smoothed = mix(f0, f1, smooth_mix);
#
#	return mix(linear, smoothed, interpolation);
#}

static func anisotropic(uv : Vector2, size : Vector2, pseed : float, smoothness : float, interpolation : float) -> float:
	var seed2 : Vector2 = rand2(Vector2(pseed, 1.0 - pseed))
	
	var xy : Vector2 = floorv2(uv * size)
	var s2xy : Vector2 = seed2
	s2xy.x += xy.y
	s2xy.y += xy.y
	
	var offset : Vector2 =  Vector2(rand(s2xy), 0.0)
	var xy_offset : Vector2 = floorv2(uv * size + offset)

	var f0 : float = rand(seed2 + modv2(xy_offset, size));    
	var f1 : float = rand(seed2 + modv2(xy_offset + Vector2(1.0, 0.0), size))
	var mixer : float = clamp((fract(uv.x * size.x + offset.x) - 0.5) / smoothness + 0.5, 0.0, 1.0)    
	var smooth_mix : float = smoothstep(0.0, 1.0, mixer)
	var linear : float = lerp(f0, f1, mixer)
	var smoothed : float = lerp(f0, f1, smooth_mix)

	return lerp(linear, smoothed, interpolation)

#vec3 color_dots(vec2 uv, float size, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
#	uv /= size;
#	vec2 point_pos = floor(uv)+vec2(0.5);
#	return rand3(seed2+point_pos);
#}

static func color_dots(uv : Vector2, size : float, pseed : float) -> Vector3:
	var seed2 : Vector2 = rand2(Vector2(pseed, 1.0 - pseed))
	
	uv /= size
	
	var point_pos : Vector2 = floorv2(uv) + Vector2(0.5, 0.5)
	
	return rand3(seed2 + point_pos)

static func noise_color(uv : Vector2, size : float, pseed : float) -> Color:
	var v : Vector3 = color_dots(uv, 1.0 / size, pseed)

	return Color(v.x, v.y, v.z, 1)

# ====== NOISE_FBM.GD ======


#fbm2.mmg (and fbm.mmg)

#Output:
#$(name)_fbm($(uv), vec2($(scale_x), $(scale_y)), int($(folds)), int($(iterations)), $(persistence), float($(seed)))

#Instance:
#float $(name)_fbm(vec2 coord, vec2 size, int folds, int octaves, float persistence, float seed) {
#	float normalize_factor = 0.0;
#	float value = 0.0;
#	float scale = 1.0;
#
#	for (int i = 0; i < octaves; i++) {
#		float noise = fbm_$noise(coord*size, size, seed);
#
#		for (int f = 0; f < folds; ++f) {
#			noise = abs(2.0*noise-1.0);
#		}
#
#		value += noise * scale;
#		normalize_factor += scale;
#		size *= 2.0;
#		scale *= persistence;
#	}
#
#	return value / normalize_factor;
#}

#Inputs:
#noise, enum, default: 2, values: Value, Perlin, Simplex, Cellular, Cellular2, Cellular3, Cellular4, Cellular5, Cellular6
#scale, vector2, default: 4, min: 1, max: 32, step: 1
#folds, float, default: 0, min: 0, max: 5, step: 1
#iterations (octaves), float, default: 3, min: 1, max: 10, step: 1
#persistence, float, default: 0.5, min: 0, max: 1, step: 0.01

static func fbmval(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = fbmf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)

static func perlin(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = perlinf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func perlinabs(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = perlinf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func simplex(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = fbm_simplexf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellularf(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular2(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular2f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular3(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular3f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular4(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular4f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular5(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular5f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)
	
static func cellular6(uv : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> Color:
	var f : float = cellular6f(uv, size, folds, octaves, persistence, pseed)

	return Color(f, f, f, 1)


static func fbmf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_value(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func perlinf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_perlin(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func perlinabsf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_perlinabs(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;

static func fbm_simplexf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_simplex(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;

static func cellularf(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellular2f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular2(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;

static func cellular3f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular3(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellular4f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular4(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellular5f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular5(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;
	
static func cellular6f(coord : Vector2, size : Vector2, folds : int, octaves : int, persistence : float, pseed : float) -> float:
	var normalize_factor : float = 0.0;
	var value : float = 0.0;
	var scale : float = 1.0;
	
	for i in range(octaves):# (int i = 0; i < octaves; i++) {
		var noise : float = fbm_cellular6(coord*size, size, pseed)
		
		for j in range(folds):# (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		
		value += noise * scale
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	
	return value / normalize_factor;


#float fbm_value(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#
#	float p00 = rand(mod(o, size));
#	float p01 = rand(mod(o + vec2(0.0, 1.0), size));
#	float p10 = rand(mod(o + vec2(1.0, 0.0), size));
#	float p11 = rand(mod(o + vec2(1.0, 1.0), size));
#
#	vec2 t = f * f * (3.0 - 2.0 * f);
#
#	return mix(mix(p00, p10, t.x), mix(p01, p11, t.x), t.y);
#}

static func fbm_value(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	var p00 : float = rand(modv2(o, size));
	var p01 : float = rand(modv2(o + Vector2(0.0, 1.0), size));
	var p10 : float = rand(modv2(o + Vector2(1.0, 0.0), size));
	var p11 : float = rand(modv2(o + Vector2(1.0, 1.0), size));
	
	var t : Vector2 = f * f * (Vector2(3, 3) - 2.0 * f);
	return lerp(lerp(p00, p10, t.x), lerp(p01, p11, t.x), t.y);


#float fbm_perlin(vec2 coord, vec2 size, float seed) {
#	tvec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#
#	float a00 = rand(mod(o, size)) * 6.28318530718;
#	float a01 = rand(mod(o + vec2(0.0, 1.0), size)) * 6.28318530718;
#	float a10 = rand(mod(o + vec2(1.0, 0.0), size)) * 6.28318530718;
#	float a11 = rand(mod(o + vec2(1.0, 1.0), size)) * 6.28318530718;
#
#	vec2 v00 = vec2(cos(a00), sin(a00));
#	vec2 v01 = vec2(cos(a01), sin(a01));
#	vec2 v10 = vec2(cos(a10), sin(a10));
#	vec2 v11 = vec2(cos(a11), sin(a11));
#
#	float p00 = dot(v00, f);
#	float p01 = dot(v01, f - vec2(0.0, 1.0));
#	float p10 = dot(v10, f - vec2(1.0, 0.0));
#	float p11 = dot(v11, f - vec2(1.0, 1.0));
#
#	vec2 t = f * f * (3.0 - 2.0 * f);
#
#	return 0.5 + mix(mix(p00, p10, t.x), mix(p01, p11, t.x), t.y);
#}

static func fbm_perlin(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	var a00 : float = rand(modv2(o, size)) * 6.28318530718;
	var a01 : float = rand(modv2(o + Vector2(0.0, 1.0), size)) * 6.28318530718;
	var a10 : float = rand(modv2(o + Vector2(1.0, 0.0), size)) * 6.28318530718;
	var a11 : float = rand(modv2(o + Vector2(1.0, 1.0), size)) * 6.28318530718;
	var v00 : Vector2 = Vector2(cos(a00), sin(a00));
	var v01 : Vector2 = Vector2(cos(a01), sin(a01));
	var v10 : Vector2 = Vector2(cos(a10), sin(a10));
	var v11 : Vector2 = Vector2(cos(a11), sin(a11));
	var p00 : float = v00.dot(f);
	var p01 : float = v01.dot(f - Vector2(0.0, 1.0));
	var p10 : float = v10.dot(f - Vector2(1.0, 0.0));
	var p11 : float = v11.dot(f - Vector2(1.0, 1.0));
	
	var t : Vector2 = f * f * (Vector2(3, 3) - 2.0 * f);
	
	return 0.5 + lerp(lerp(p00, p10, t.x), lerp(p01, p11, t.x), t.y);

#float fbm_perlinabs(vec2 coord, vec2 size, float seed) {
#	return abs(2.0*fbm_perlin(coord, size, seed)-1.0);
#}

static func fbm_perlinabs(coord : Vector2, size : Vector2, pseed : float) -> float:
	return abs(2.0*fbm_perlin(coord, size, pseed)-1.0)

#vec2 rgrad2(vec2 p, float rot, float seed) {
#	float u = rand(p + vec2(seed, 1.0-seed));
#	u = fract(u) * 6.28318530718; // 2*pi
#	return vec2(cos(u), sin(u));
#}

static func rgrad2(p : Vector2, rot : float, pseed : float) -> Vector2:
	var u : float = rand(p + Vector2(pseed, 1.0-pseed));
	u = fract(u) * 6.28318530718; # 2*pi
	return Vector2(cos(u), sin(u))

#float fbm_simplex(vec2 coord, vec2 size, float seed) {
#	coord *= 2.0; // needed for it to tile
#	coord += rand2(vec2(seed, 1.0-seed)) + size;
#	size *= 2.0; // needed for it to tile
#	coord.y += 0.001;    
#
#	vec2 uv = vec2(coord.x + coord.y*0.5, coord.y);    
#	vec2 i0 = floor(uv);    vec2 f0 = fract(uv);    
#	vec2 i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);    
#	vec2 p0 = vec2(i0.x - i0.y * 0.5, i0.y);    
#	vec2 p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);    
#	vec2 p2 = vec2(p0.x + 0.5, p0.y + 1.0);    
#
#	i1 = i0 + i1;    
#
#	vec2 i2 = i0 + vec2(1.0, 1.0);    
#	vec2 d0 = coord - p0;
#	vec2 d1 = coord - p1;
#	vec2 d2 = coord - p2;
#
#	vec3 xw = mod(vec3(p0.x, p1.x, p2.x), size.x);    
#	vec3 yw = mod(vec3(p0.y, p1.y, p2.y), size.y);    
#
#	vec3 iuw = xw + 0.5 * yw;    
#	vec3 ivw = yw;    
#
#	vec2 g0 = rgrad2(vec2(iuw.x, ivw.x), 0.0, seed);    
#	vec2 g1 = rgrad2(vec2(iuw.y, ivw.y), 0.0, seed);    
#	vec2 g2 = rgrad2(vec2(iuw.z, ivw.z), 0.0, seed);    
#
#	vec3 w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));    
#	vec3 t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));    
#
#	t = max(t, vec3(0.0));
#	vec3 t2 = t * t;    
#	vec3 t4 = t2 * t2;    
#	float n = dot(t4, w);
#
#	return 0.5 + 5.5 * n;
#}

static func fbm_simplex(coord : Vector2, size : Vector2, pseed : float) -> float:
	coord *= 2.0; # needed for it to tile
	coord += rand2(Vector2(pseed, 1.0-pseed)) + size;
	size *= 2.0; # needed for it to tile
	coord.y += 0.001;    

	var uv : Vector2 = Vector2(coord.x + coord.y*0.5, coord.y);    
	var i0 : Vector2 = floorv2(uv);
	var f0 : Vector2 = fractv2(uv);    
	var i1 : Vector2
	
	if (f0.x > f0.y):
		i1 = Vector2(1.0, 0.0)
	else: 
		i1 = Vector2(0.0, 1.0);    
		
	var p0 : Vector2 = Vector2(i0.x - i0.y * 0.5, i0.y);    
	var p1 : Vector2 = Vector2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);    
	var p2 : Vector2 = Vector2(p0.x + 0.5, p0.y + 1.0);    

	i1 = i0 + i1;    

	var i2 : Vector2 = i0 + Vector2(1.0, 1.0);    
	var d0 : Vector2 = coord - p0;
	var d1 : Vector2 = coord - p1;
	var d2 : Vector2 = coord - p2;

	var xw : Vector3 = modv3(Vector3(p0.x, p1.x, p2.x), Vector3(size.x, size.x, size.x));    
	var yw : Vector3 = modv3(Vector3(p0.y, p1.y, p2.y), Vector3(size.y, size.y, size.y));    

	var iuw : Vector3 = xw + 0.5 * yw;    
	var ivw : Vector3 = yw;    

	var g0 : Vector2 = rgrad2(Vector2(iuw.x, ivw.x), 0.0, pseed);    
	var g1 : Vector2 = rgrad2(Vector2(iuw.y, ivw.y), 0.0, pseed);    
	var g2 : Vector2 = rgrad2(Vector2(iuw.z, ivw.z), 0.0, pseed);    

	var w : Vector3 = Vector3(g0.dot(d0), g1.dot(d1), g2.dot(d2));    
	var t : Vector3 = Vector3(0.8, 0.8, 0.8) - Vector3(d0.dot(d0), d1.dot(d1), d2.dot(d2));    

	t = maxv3(t, Vector3());
	var t2 : Vector3 = t * t;    
	var t4 : Vector3 = t2 * t2;    
	var n : float = t4.dot(w);

	return 0.5 + 5.5 * n;
	
#float fbm_cellular(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
#			min_dist = min(min_dist, dist);
#		}
#	}
#
#	return min_dist;
#}

static func fbm_cellular(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			min_dist = min(min_dist, dist);

	return min_dist;

#float fbm_cellular2(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist1 = 2.0;
#	float min_dist2 = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
#			if (min_dist1 > dist) {
#				min_dist2 = min_dist1;
#				min_dist1 = dist;
#			} else if (min_dist2 > dist) {
#				min_dist2 = dist;
#			}
#		}
#	}
#
#	return min_dist2-min_dist1;
#}

static func fbm_cellular2(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			
			var dist : float = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y);
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;
	
	return min_dist2-min_dist1;

#float fbm_cellular3(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size))*0.5 + vec2(x, y);
#			float dist = abs((f - node).x) + abs((f - node).y);
#			min_dist = min(min_dist, dist);
#		}
#	}
#
#	return min_dist;
#}

static func fbm_cellular3(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size))*0.5 + Vector2(x, y);
			
			var dist : float = abs((f - node).x) + abs((f - node).y);
			
			min_dist = min(min_dist, dist);

	return min_dist;

#float fbm_cellular4(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist1 = 2.0;
#	float min_dist2 = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size))*0.5 + vec2(x, y);
#			float dist = abs((f - node).x) + abs((f - node).y);
#
#			if (min_dist1 > dist) {
#				min_dist2 = min_dist1;
#				min_dist1 = dist;
#			} else if (min_dist2 > dist) {
#				min_dist2 = dist;
#			}
#		}
#	}
#
#	return min_dist2-min_dist1;
#}

static func fbm_cellular4(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size))*0.5 + Vector2(x, y);
			
			var dist : float = abs((f - node).x) + abs((f - node).y);
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;

	return min_dist2 - min_dist1;

#float fbm_cellular5(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = max(abs((f - node).x), abs((f - node).y));
#			min_dist = min(min_dist, dist);
#		}
#	}
#
#	return min_dist;
#}

static func fbm_cellular5(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = max(abs((f - node).x), abs((f - node).y));
			min_dist = min(min_dist, dist);

	return min_dist;

#float fbm_cellular6(vec2 coord, vec2 size, float seed) {
#	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
#	vec2 f = fract(coord);
#	float min_dist1 = 2.0;
#	float min_dist2 = 2.0;
#
#	for(float x = -1.0; x <= 1.0; x++) {
#		for(float y = -1.0; y <= 1.0; y++) {
#			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
#			float dist = max(abs((f - node).x), abs((f - node).y));
#
#			if (min_dist1 > dist) {
#				min_dist2 = min_dist1;
#				min_dist1 = dist;
#			} else if (min_dist2 > dist) {
#				min_dist2 = dist;
#			}
#		}
#	}
#
#	return min_dist2-min_dist1;
#}

static func fbm_cellular6(coord : Vector2, size : Vector2, pseed : float) -> float:
	var o : Vector2 = floorv2(coord) + rand2(Vector2(float(pseed), 1.0 - float(pseed))) + size;
	var f : Vector2 = fractv2(coord);
	
	var min_dist1 : float = 2.0;
	var min_dist2 : float = 2.0;
	
	for xx in range(-1, 2): #(float x = -1.0; x <= 1.0; x++) {
		var x : float = xx
		
		for yy in range(-1, 2):#(float y = -1.0; y <= 1.0; y++) {
			var y : float = yy
			
			var node : Vector2 = rand2(modv2(o + Vector2(x, y), size)) + Vector2(x, y);
			var dist : float = max(abs((f - node).x), abs((f - node).y));
			
			if (min_dist1 > dist):
				min_dist2 = min_dist1;
				min_dist1 = dist;
			elif (min_dist2 > dist):
				min_dist2 = dist;

	return min_dist2 - min_dist1;

# ===== NOISE_PERLIN.GD ========


#----------------------
#perlin.mmg

#Outputs:

#Output - (float) - Shows a greyscale value noise
#perlin($(uv), vec2($(scale_x), $(scale_y)), int($(iterations)), $(persistence), $(seed))

#Inputs:
#scale, vector2, default: 4, min: 1, max: 32, step: 1
#iterations, float, min: 0, max: 10, default: 3, step:1
#persistence, float, min: 0, max: 1, default: 0.5, step:0.05

#----------------------
#perlin_color.mmg

#Outputs:

#Output - (rgb) - Shows a color value noise
#perlin_color($(uv), vec2($(scale_x), $(scale_y)), int($(iterations)), $(persistence), $(seed))

#Inputs:
#scale, vector2, default: 4, min: 1, max: 32, step: 1
#iterations, float, min: 0, max: 10, default: 3, step:1
#persistence, float, min: 0, max: 1, default: 0.5, step:0.05

static func perlinc(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Color:
	var f : float = perlin2c(uv, size, iterations, persistence, pseed)
	
	return Color(f, f, f, 1)


#float perlin(vec2 uv, vec2 size, int iterations, float persistence, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));    
#	float rv = 0.0;    
#	float coef = 1.0;    
#	float acc = 0.0;    
#
#	for (int i = 0; i < iterations; ++i) {    
#		vec2 step = vec2(1.0)/size;
#		vec2 xy = floor(uv*size);        
#
#		float f0 = rand(seed2+mod(xy, size));        
#		float f1 = rand(seed2+mod(xy+vec2(1.0, 0.0), size));        
#		float f2 = rand(seed2+mod(xy+vec2(0.0, 1.0), size));        
#		float f3 = rand(seed2+mod(xy+vec2(1.0, 1.0), size));        
#
#		vec2 mixval = smoothstep(0.0, 1.0, fract(uv*size));        
#		rv += coef * mix(mix(f0, f1, mixval.x), mix(f2, f3, mixval.x), mixval.y);        
#		acc += coef;
#		size *= 2.0;
#		coef *= persistence;    
#	}        
#
#	return rv / acc;
#}

static func perlin2c(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> float:
	var seed2 : Vector2 = rand2(Vector2(float(pseed), 1.0-float(pseed)));
	var rv : float = 0.0;
	var coef : float = 1.0;
	var acc : float = 0.0;
	
	for i in range(iterations):
		var step : Vector2 = Vector2(1, 1) / size;
		var xy : Vector2 = floorv2(uv * size);
		var f0 : float = rand(seed2 + modv2(xy, size));
		var f1 : float = rand(seed2 + modv2(xy + Vector2(1.0, 0.0), size));
		var f2 : float = rand(seed2 + modv2(xy + Vector2(0.0, 1.0), size));
		var f3 : float = rand(seed2 + modv2(xy + Vector2(1.0, 1.0), size));

		var mixval : Vector2 = smoothstepv2(0.0, 1.0, fractv2(uv * size));
		
		rv += coef * lerp(lerp(f0, f1, mixval.x), lerp(f2, f3, mixval.x), mixval.y);
		acc += coef;
		size *= 2.0;
		coef *= persistence;

	return rv / acc;

#vec3 perlin_color(vec2 uv, vec2 size, int iterations, float persistence, float seed) {
#	vec2 seed2 = rand2(vec2(seed, 1.0-seed));    
#	vec3 rv = vec3(0.0);    
#	float coef = 1.0;    
#	float acc = 0.0;    
#
#	for (int i = 0; i < iterations; ++i) {    
#		vec2 step = vec2(1.0)/size;
#		vec2 xy = floor(uv*size);        
#		vec3 f0 = rand3(seed2+mod(xy, size));        
#		vec3 f1 = rand3(seed2+mod(xy+vec2(1.0, 0.0), size));        
#		vec3 f2 = rand3(seed2+mod(xy+vec2(0.0, 1.0), size));        
#		vec3 f3 = rand3(seed2+mod(xy+vec2(1.0, 1.0), size));        
#		vec2 mixval = smoothstep(0.0, 1.0, fract(uv*size));        
#
#		rv += coef * mix(mix(f0, f1, mixval.x), mix(f2, f3, mixval.x), mixval.y);        
#		acc += coef;        
#		size *= 2.0;        
#		coef *= persistence;    
#	}        
#
#	return rv / acc;
#}

static func perlin_color(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Vector3:
	var seed2 : Vector2 = rand2(Vector2(float(pseed), 1.0-float(pseed)));
	var rv : Vector3 = Vector3();
	var coef : float = 1.0;
	var acc : float = 0.0;
	
	for i in range(iterations):
		var step : Vector2 = Vector2(1, 1) / size;
		var xy : Vector2 = floorv2(uv * size);
		var f0 : Vector3 = rand3(seed2 + modv2(xy, size));
		var f1 : Vector3 = rand3(seed2 + modv2(xy + Vector2(1.0, 0.0), size));
		var f2 : Vector3 = rand3(seed2 + modv2(xy + Vector2(0.0, 1.0), size));
		var f3 : Vector3 = rand3(seed2 + modv2(xy + Vector2(1.0, 1.0), size));

		var mixval : Vector2 = smoothstepv2(0.0, 1.0, fractv2(uv * size));
		
		rv += coef * lerp(lerp(f0, f1, mixval.x), lerp(f2, f3, mixval.x), mixval.y)
		acc += coef;
		size *= 2.0;
		coef *= persistence;

	return rv / acc;

static func perlin_colorc(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int) -> Color:
	var f : Vector3 = perlin_color(uv, size, iterations, persistence, pseed)
	
	return Color(f.x, f.y, f.z, 1)

static func perlin_warp_1(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int, translate : Vector2, rotate : float, size2 : Vector2) -> Color:
	var f : float = perlin2c(uv, size2, iterations, persistence, pseed)
	var vt : Vector2 = transform(uv, Vector2(translate.x*(2.0*f-1.0), translate.y*(2.0*f-1.0)), rotate*0.01745329251*(2.0*1.0-1.0), Vector2(size.x*(2.0*1.0-1.0), size.y*(2.0*1.0-1.0)), true)
	var ff : float = perlin2c(vt, size2, iterations, persistence, pseed)

	return Color(ff, ff, ff, 1)

static func perlin_warp_2(uv : Vector2, size : Vector2, iterations : int, persistence : float, pseed : int, translate : Vector2, rotate : float, size2 : Vector2) -> Color:
	var f = perlin2c(uv, size2, iterations, persistence, pseed)
	var vt : Vector2 = transform(uv, Vector2(translate.x*(2.0*f-1.0), translate.y*(2.0*f-1.0)), rotate*0.01745329251*(2.0*1.0-1.0), Vector2(size.x*(2.0*1.0-1.0), size.y*(2.0*1.0-1.0)), true)
	var ff : float = perlin2c(vt, size2, iterations, persistence, pseed)
	
	var rgba : Vector3 = Vector3(ff, ff, ff)
	
	var tf : Vector2 = transform(uv, Vector2(translate.x * (2.0 * (rgba.dot(Vector3(1, 1, 1) / 3.0) - 1.0)), translate.y*(2.0*(rgba.dot(Vector3(1, 1, 1) /3.0)-1.0))), rotate*0.01745329251*(2.0*1.0-1.0), Vector2(size.x*(2.0*1.0-1.0), size.y*(2.0*1.0-1.0)), true)

	var fff : float = perlin2c(tf, size2, iterations, persistence, pseed);

	return Color(fff, fff, fff, 1)

# ========= NOIDE_VORONOI.GD =========

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
	var seed2 : Vector2 = rand2(Vector2(float(pseed), 1.0-float(pseed)));
	uv *= size;
	var best_distance0 : float = 1.0;
	var best_distance1 : float = 1.0;
	var point0 : Vector2;
	var point1 : Vector2;
	var p0 : Vector2 = floorv2(uv);
	
	for dx in range(-1, 2):# (int dx = -1; dx < 2; ++dx) {
		for dy in range(-1, 2):# (int dy = -1; dy < 2; ++dy) {
			var d : Vector2 = Vector2(float(dx), float(dy));
			var p : Vector2 = p0+d;
			
			p += randomness * rand2(seed2 + modv2(p, size));
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
	
	var v : Vector3 = rand3(fractv2(vv));
	
	return Color(v.x, v.y, v.z, 1)

#vec4(fract(($(name_uv)_xyzw.xy-1.0)/vec2($scale_x, $scale_y)), vec2(2.0)/vec2($scale_x, $scale_y))

#voronoi_4 todo


# =================  PATTERNS.GD =======================



#----------------------
#beehive.mmg
#Outputs: (beehive_1c, beehive_2c, beehive_3c  TODO make common code parameters)
#Common
#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);

#Output (float) - Shows the greyscale pattern
#1.0-2.0*beehive_dist($(name_uv)_center.xy)

#Random color (rgb) - Shows a random color for each hexagonal tile
#rand3(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed)))

#UV map (rgb) - Shows an UV map to be connected to the UV map port of the Custom UV node
#vec3(vec2(0.5)+$(name_uv)_center.xy, rand(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed))))

#Inputs:
#size, vector2, default: 2, min: 1, max: 64, step: 1

#----------------------
#pattern.mmg
#Outputs: $(name)_fct($(uv))

#Combiner, enum, default: 0, values (CombinerType): Multiply, Add, Max, Min, Xor, Pow
#Pattern_x_type, enum, default: 5, values (CombinerAxisType): Sine, Triangle, Square, Sawtooth, Constant, Bounce
#Pattern_y_type, enum, default: 5, values (CombinerAxisType): Sine, Triangle, Square, Sawtooth, Constant, Bounce
#Pattern_Repeat, vector2, min: 0, max: 32, default:4, step: 1

#----------------------
#bricks.mmg

#Outputs:

#Common
#vec4 $(name_uv)_rect = bricks_$pattern($uv, vec2($columns, $rows), $repeat, $row_offset);
#vec4 $(name_uv) = brick($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $round*$round_map($uv), max(0.001, $bevel*$bevel_map($uv)));

#Bricks pattern (float) - A greyscale image that shows the bricks pattern
#$(name_uv).x

#Random color (rgb) - A random color for each brick
#brick_random_color($(name_uv)_rect.xy, $(name_uv)_rect.zw, float($seed))

#Position.x (float) - The position of each brick along the X axis",
#$(name_uv).y

#Position.y (float) - The position of each brick along the Y axis
#$(name_uv).z

#Brick UV (rgb) - An UV map output for each brick, to be connected to the Map input of a CustomUV node
#brick_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, float($seed))

#Corner UV (rgb) - An UV map output for each brick corner, to be connected to the Map input of a CustomUV node
#brick_corner_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $corner, float($seed))

#Direction (float) - The direction of each brick (white: horizontal, black: vertical)
#0.5*(sign($(name_uv)_rect.z-$(name_uv)_rect.x-$(name_uv)_rect.w+$(name_uv)_rect.y)+1.0)

#Inputs:
#type / Pattern, enum, default: 0, values: Running Bond,Running Bond (2),HerringBone,Basket Weave,Spanish Bond
#repeat, int, min: 1, max: 8, default: 1, step:1
#rows, int, min: 1, max: 64, default: 6, step:1
#columns, int, min: 1, max: 64, default: 6, step:1
#offset, float, min: 0, max: 1, default: 0.5, step:0.01
#mortar, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#bevel, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#round, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#corner, float, min: 0, max: 0.5, default: 0.1, step:0.01

#----------------------
#bricks_uneven.mmg

#Outputs:

#Common
#vec4 $(name_uv)_rect = bricks_uneven($uv, int($iterations), $min_size, $randomness, float($seed));
#vec4 $(name_uv) = brick2($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $round*$round_map($uv), max(0.00001, $bevel*$bevel_map($uv)));

#Bricks pattern (float) - A greyscale image that shows the bricks pattern
#$(name_uv).x

#Random color (rgb) - A random color for each brick
#rand3(fract($(name_uv)_rect.xy)+rand2(vec2(float($seed))))

#Position.x (float) - The position of each brick along the X axis",
#$(name_uv).y

#Position.y (float) - The position of each brick along the Y axis
#$(name_uv).z

#Brick UV (rgb) - An UV map output for each brick, to be connected to the Map input of a CustomUV node
#brick_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, float($seed))

#Corner UV (rgb) - An UV map output for each brick corner, to be connected to the Map input of a CustomUV node
#brick_corner_uv($uv, $(name_uv)_rect.xy, $(name_uv)_rect.zw, $mortar*$mortar_map($uv), $corner, float($seed))

#Direction (float) - The direction of each brick (white: horizontal, black: vertical)
#0.5*(sign($(name_uv)_rect.z-$(name_uv)_rect.x-$(name_uv)_rect.w+$(name_uv)_rect.y)+1.0)

#Inputs:
#iterations, int, min: 1, max: 16, default:8, step:1
#min_size, float, min: 0, max: 0.5, default: 0.3, step:0.01
#randomness, float, min: 0, max: 1, default: 0.5, step:0.01
#mortar, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#bevel, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#round, float, min: 0, max: 0.5, default: 0.1, step:0.01 (universal input)
#corner, float, min: 0, max: 0.5, default: 0.1, step:0.01

#----------------------
#runes.mmg (includes sdline.mmg)
#Generates a grid filled with random runes

#Outputs:

#Output (float) - A greyscale image showing random runes.
#Rune(vec2($columns, $rows)*$uv, float($seed))

#Inputs:
#size, vector2, default: 4, min: 2, max: 32, step: 1

#----------------------
#scratches.mmg
#Draws white scratches on a black background

#Outputs:

#Output (float) - Shows white scratches on a black background
#scratches($uv, int($layers), vec2($length, $width), $waviness, $angle, $randomness, vec2(float($seed), 0.0))

#Inputs:

#scratch_size (l, w), vector2, min: 0.1, max: 1, default: (0.25, 0.5), step:0.01
#layers, float, min: 1, max: 10, default: 4, step:1
#waviness, float, min: 0, max: 1, default: 0.5, step:0.01
#angle, float, min: -180, max: 180, default: 0, step:1
#randomness, float, min: 0, max: 1, default: 0.5, step:0.01

#----------------------
#iching.mmg
#This node generates a grid of random I Ching hexagrams.

#Outputs:

#Output (float) - A greyscale image showing random I Ching hexagrams.
#IChing(vec2($columns, $rows)*$uv, float($seed))

#Inputs:
#size, vector2, default: 2, min: 2, max: 32, step: 1

#----------------------
#weave.mmg

#Outputs:

#Output (float) - Shows the generated greyscale weave pattern.
#weave($uv, vec2($columns, $rows), $width*$width_map($uv))

#Inputs:
#size, vector2, default: 4, min: 2, max: 32, step: 1
#width, float, min: 0, max: 1, default: 0.8, step:0.05 (universal input)

#----------------------
#weave2.mmg

#code
#vec3 $(name_uv) = weave2($uv, vec2($columns, $rows), $stitch, $width_x*$width_map($uv), $width_y*$width_map($uv));

#Outputs:

#Output (float) - Shows the generated greyscale weave pattern.
#$(name_uv).x

#Horizontal mask (float) - Horizontal mask
#$(name_uv).y

#Vertical mask (float) - Mask for vertical stripes
#$(name_uv).z

#Inputs:
#size, vector2, default: 4, min: 2, max: 32, step: 1
#width, vector2, default: 0.8, min: 0, max: 1, step: 0.05
#stitch, float, min: 0, max: 10, default: 1, step:1
#width_map, float, default: 1, (does not need input val (label)) (universal input)

#----------------------
#truchet.mmg

#Outputs:

#line: $shape = 1
#circle: $shape = 2

#Output (float) - Shows a greyscale image of the truchet pattern.
#truchet$shape($uv*$size, vec2(float($seed)))

#Inputs:
#shape, enum, default: 0, values: line, circle
#size, float, default: 4, min: 2, max: 64, step: 1

#----------------------
#truchet_generic.mmg

#Outputs:

#Output (color)
#$in(truchet_generic_uv($uv*$size, vec2(float($seed))))

#Inputs:
#in, color, default: color(1.0)
#size, float, default: 4, min: 2, max: 64, step: 1

#----------------------
#arc_pavement.mmg
#Draws a white shape on a black background

#		"code": "vec2 $(name_uv)_uv = fract($uv)*vec2($repeat, -1.0);\nvec2 $(name_uv)_seed;\nvec4 $(name_uv)_ap = arc_pavement($(name_uv)_uv, $rows, $bricks, $(name_uv)_seed);\n",
#		"outputs": [
#			{
#				"f": "pavement($(name_uv)_ap.zw, $bevel, 2.0*$mortar)",
#				"longdesc": "A greyscale image that shows the bricks pattern",
#				"shortdesc": "Bricks pattern",
#				"type": "f"
#			},
#			{
#				"longdesc": "A random color for each brick",
#				"rgb": "rand3($(name_uv)_seed)",
#				"shortdesc": "Random color",
#				"type": "rgb"
#			},
#			{
#				"longdesc": "An UV map output for each brick, to be connected to the Map input of a CustomUV node",
#				"rgb": "vec3($(name_uv)_ap.zw, 0.0)",
#				"shortdesc": "Brick UV",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 2,
#				"label": "Repeat:",
#				"longdesc": "The number of repetitions of the whole pattern",
#				"max": 4,
#				"min": 1,
#				"name": "repeat",
#				"shortdesc": "Repeat",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 8,
#				"label": "Rows:",
#				"longdesc": "The number of rows",
#				"max": 16,
#				"min": 4,
#				"name": "rows",
#				"shortdesc": "Rows",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 8,
#				"label": "Bricks:",
#				"longdesc": "The number of bricks per row",
#				"max": 16,
#				"min": 4,
#				"name": "bricks",
#				"shortdesc": "Bricks",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Mortar:",
#				"longdesc": "The width of the space between bricks",
#				"max": 0.5,
#				"min": 0,
#				"name": "mortar",
#				"shortdesc": "Mortar",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Bevel:",
#				"longdesc": "The width of the edge of each brick",
#				"max": 0.5,
#				"min": 0,
#				"name": "bevel",
#				"shortdesc": "Bevel",
#				"step": 0.01,
#				"type": "float"
#			}
#		]

#----------------------
#sine_wave.mmg
#Draws a greyscale sine wave pattern

#Outputs:
#Output, float, Shows a greyscale image of a sine wave
#1.0-abs(2.0*($uv.y-0.5)-$amplitude*sin(($frequency*$uv.x+$phase)*6.28318530718))

#Inputs:
#amplitude, float, min: 0, max: 1, step: 0.01, default: 0.5
#frequency, float, min: 0, max: 16, default: 1
#phase, float, min: 0, max: 1, step: 0.01, default: 0.5

enum CombinerAxisType {
	SINE,
	TRIANGLE,
	SQUARE,
	SAWTOOTH,
	CONSTANT,
	BOUNCE
}

enum CombinerType {
	MULTIPLY,
	ADD,
	MAX,
	MIN,
	XOR,
	POW
}

#"Sine,Triangle,Square,Sawtooth,Constant,Bounce"
#"Multiply,Add,Max,Min,Xor,Pow"

#float $(name)_fct(vec2 uv) {
#	return mix_$(mix)(wave_$(x_wave)($(x_scale)*uv.x), wave_$(y_wave)($(y_scale)*uv.y));
#}

static func pattern(uv : Vector2, x_scale : float, y_scale : float, ct : int, catx : int, caty : int) -> float:
	var x : float = 0
	var y : float = 0
	
	if catx == CombinerAxisType.SINE:
		x = wave_sine(x_scale * uv.x)
	elif catx == CombinerAxisType.TRIANGLE:
		x = wave_triangle(x_scale * uv.x)
	elif catx == CombinerAxisType.SQUARE:
		x = wave_square(x_scale * uv.x)
	elif catx == CombinerAxisType.SAWTOOTH:
		x = wave_sawtooth(x_scale * uv.x)
	elif catx == CombinerAxisType.CONSTANT:
		x = wave_constant(x_scale * uv.x)
	elif catx == CombinerAxisType.BOUNCE:
		x = wave_bounce(x_scale * uv.x)
		
	if caty == CombinerAxisType.SINE:
		y = wave_sine(y_scale * uv.y)
	elif caty == CombinerAxisType.TRIANGLE:
		y = wave_triangle(y_scale * uv.y)
	elif caty == CombinerAxisType.SQUARE:
		y = wave_square(y_scale * uv.y)
	elif caty == CombinerAxisType.SAWTOOTH:
		y = wave_sawtooth(y_scale * uv.y)
	elif caty == CombinerAxisType.CONSTANT:
		y = wave_constant(y_scale * uv.y)
	elif caty == CombinerAxisType.BOUNCE:
		y = wave_bounce(y_scale * uv.y)
	
	if ct == CombinerType.MULTIPLY:
		return mix_mul(x, y)
	elif ct == CombinerType.ADD:
		return mix_add(x, y);
	elif ct == CombinerType.MAX:
		return mix_max(x, y);
	elif ct == CombinerType.MIN:
		return mix_min(x, y);
	elif ct == CombinerType.XOR:
		return mix_xor(x, y);
	elif ct == CombinerType.POW:
		return mix_pow(x, y);
		
	return 0.0
	

#"Line,Circle"

static func truchet1c(uv : Vector2, size : float, pseed : float) -> Color:
	var f : float = truchet1(uv * size, Vector2(pseed, pseed))
	return Color(f, f, f, 1);

#float truchet1(vec2 uv, vec2 seed) {
#	vec2 i = floor(uv);
#	vec2 f = fract(uv)-vec2(0.5);
#
#	return 1.0-abs(abs((2.0*step(rand(i+seed), 0.5)-1.0)*f.x+f.y)-0.5);
#}

static func truchet1(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = floorv2(uv);
	var f : Vector2 = fractv2(uv) - Vector2(0.5, 0.5);
	
	return 1.0 - abs(abs((2.0 * step(rand(i + pseed), 0.5) - 1.0) * f.x + f.y) - 0.5);

static func truchet2c(uv : Vector2, size : float, pseed : float) -> Color:
	var f : float = truchet2(uv * size, Vector2(pseed, pseed))
	return Color(f, f, f, 1);

#float truchet2(vec2 uv, vec2 seed) {
#	vec2 i = floor(uv);
#	vec2 f = fract(uv);
#	float random = step(rand(i+seed), 0.5);
#
#	f.x *= 2.0*random-1.0;
#	f.x += 1.0-random;
#
#	return 1.0-min(abs(length(f)-0.5), abs(length(1.0-f)-0.5));
#}

static func truchet2(uv : Vector2, pseed : Vector2) -> float:
	var i : Vector2 = floorv2(uv);
	var f : Vector2 = fractv2(uv);
	var random : float = step(rand(i + pseed), 0.5);
	
	f.x *= 2.0 * random - 1.0;
	f.x += 1.0 - random;
	
	return 1.0 - min(abs(f.length() - 0.5), abs((Vector2(1, 1) - f).length() - 0.5));

static func weavec(uv : Vector2, count : Vector2, width : float) -> Color:
	var f : float = weave(uv, count, width);

	return Color(f, f, f, 1)

#float weave(vec2 uv, vec2 count, float width) {    
#	uv *= count;
#	float c = (sin(3.1415926*(uv.x+floor(uv.y)))*0.5+0.5)*step(abs(fract(uv.y)-0.5), width*0.5);
#	c = max(c, (sin(3.1415926*(1.0+uv.y+floor(uv.x)))*0.5+0.5)*step(abs(fract(uv.x)-0.5), width*0.5));
#	return c;
#}

static func weave(uv : Vector2, count : Vector2, width : float) -> float:
	uv *= count;
	var c : float = (sin(3.1415926* (uv.x + floor(uv.y)))*0.5+0.5)*step(abs(fract(uv.y)-0.5), width*0.5);
	c = max(c, (sin(3.1415926*(1.0+uv.y+floor(uv.x)))*0.5+0.5)*step(abs(fract(uv.x)-0.5), width*0.5));
	return c;
	
#vec3 weave2(vec2 uv, vec2 count, float stitch, float width_x, float width_y) {    
#	uv *= stitch;
#	uv *= count;
#	float c1 = (sin(3.1415926 / stitch * (uv.x + floor(uv.y) - (stitch - 1.0))) * 0.25 + 0.75 ) *step(abs(fract(uv.y)-0.5), width_x*0.5);
#	float c2 = (sin(3.1415926 / stitch * (1.0+uv.y+floor(uv.x) ))* 0.25 + 0.75 )*step(abs(fract(uv.x)-0.5), width_y*0.5);
#	return vec3(max(c1, c2), 1.0-step(c1, c2), 1.0-step(c2, c1));
#}

static func weave2(uv : Vector2, count : Vector2, stitch : float, width_x : float, width_y : float) -> Vector3:
	uv.x *= stitch
	uv.y *= stitch
	uv *= count
	
	var c1 : float = (sin(3.1415926 / stitch * (uv.x + floor(uv.y) - (stitch - 1.0))) * 0.25 + 0.75 ) * step(abs(fract(uv.y) - 0.5), width_x * 0.5);
	var c2 : float = (sin(3.1415926 / stitch * (1.0 + uv.y + floor(uv.x) ))* 0.25 + 0.75 ) * step(abs(fract(uv.x)-0.5), width_y * 0.5);
	
	return Vector3(max(c1, c2), 1.0 - step(c1, c2), 1.0 - step(c2, c1));

static func sinewavec(uv : Vector2, amplitude : float, frequency : float, phase : float) -> Color:
	var f : float = 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
	return Color(f, f, f, 1)
	
static func sinewavef(uv : Vector2, amplitude : float, frequency : float, phase : float) -> float:
	return 1.0- abs(2.0 * (uv.y-0.5) - amplitude * sin((frequency* uv.x + phase) * 6.28318530718));
	
#float scratch(vec2 uv, vec2 size, float waviness, float angle, float randomness, vec2 seed) {
#	float subdivide = floor(1.0/size.x);
#	float cut = size.x*subdivide;
#
#	uv *= subdivide;
#
#	vec2 r1 = rand2(floor(uv)+seed);
#	vec2 r2 = rand2(r1);
#
#	uv = fract(uv);
#	vec2 border = 10.0*min(fract(uv), 1.0-fract(uv));
#	uv = 2.0*uv-vec2(1.0);
#
#	float a = 6.28318530718*(angle+(r1.x-0.5)*randomness);
#	float c = cos(a);
#	float s = sin(a);
#
#	uv = vec2(c*uv.x+s*uv.y, s*uv.x-c*uv.y);
#	uv.y += 2.0*r1.y-1.0;
#	uv.y += 0.5*waviness*cos(2.0*uv.x+6.28318530718*r2.y);
#	uv.x /= cut;
#	uv.y /= subdivide*size.y;
#
#	return min(border.x, border.y)*(1.0-uv.x*uv.x)*max(0.0, 1.0-1000.0*uv.y*uv.y);
#}
	
static func scratch(uv : Vector2, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var subdivide : float = floor(1.0/size.x);
	var cut : float = size.x*subdivide;
	uv *= subdivide;
	var r1 : Vector2 = rand2(floorv2(uv) + pseed);
	var r2 : Vector2 = rand2(r1);
	uv = fractv2(uv);
	uv = 2.0 * uv - Vector2(1, 1);
	
	var a : float = 6.28*(angle+(r1.x-0.5)*randomness);
	var c : float = cos(a);
	var s : float = sin(a);
	
	uv = Vector2(c*uv.x+s*uv.y, s*uv.x-c*uv.y);
	uv.y += 2.0*r1.y-1.0;
	uv.y += 0.5*waviness*cos(2.0*uv.x+6.28*r2.y);
	uv.x /= cut;
	uv.y /= subdivide*size.y;
	
	return (1.0-uv.x*uv.x)*max(0.0, 1.0-1000.0*uv.y*uv.y);

#float scratches(vec2 uv, int layers, vec2 size, float waviness, float angle, float randomness, vec2 seed) {
#	float v = 0.0;
#
#	for (int i = 0; i < layers; ++i) {
#		seed = rand2(seed);
#		v = max(v, scratch(fract(uv+seed), size, waviness, angle/360.0, randomness, seed));
#	}
#
#	return v;
#}

static func scratches(uv : Vector2, layers : int, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> float:
	var v : float = 0.0;
	
	for i in range(layers):# (int i = 0; i < layers; ++i) {
		pseed = rand2(pseed);
		v = max(v, scratch(fractv2(uv + pseed), size, waviness, angle/360.0, randomness, pseed));

	return v;

static func scratchesc(uv : Vector2, layers : int, size : Vector2, waviness : float, angle : float, randomness : float, pseed : Vector2) -> Color:
	var f : float = scratches(uv, layers, size, waviness, angle, randomness, pseed)
	
	return Color(f, f, f, 1)

static func runesc(uv : Vector2, col_row : Vector2, pseed : float) -> Color:
	var f : float = rune(col_row * uv, pseed);

	return Color(f, f, f, 1)

static func runesf(uv : Vector2, col_row : Vector2, pseed : float) -> float:
	return rune(col_row * uv, pseed);

#sdline.mmg
#vec2 sdLine(vec2 p, vec2 a, vec2 b) {
#	vec2 pa = p-a, ba = b-a;
#	float h = clamp(dot(pa,ba)/dot(ba,ba), 0.0, 1.0);
#
#	return vec2(length(pa-ba*h), h);
#}

#float ThickLine(vec2 uv, vec2 posA, vec2 posB, float radiusInv){
#	return clamp(1.1-20.0*sdLine(uv, posA, posB).x, 0.0, 1.0);
#}

#// makes a rune in the 0..1 uv space. Seed is which rune to draw.
#// passes back gray in x and derivates for lighting in yz
#float Rune(vec2 uv, float s) {
#	float finalLine = 0.0;
#	vec2 seed = floor(uv)-rand2(vec2(s));
#	uv = fract(uv);
#
#	for (int i = 0; i < 4; i++)	// number of strokes
#	{
#		vec2 posA = rand2(floor(seed+0.5));
#		vec2 posB = rand2(floor(seed+1.5));
#		seed += 2.0;
#		// expand the range and mod it to get a nicely distributed random number - hopefully. :)
#		posA = fract(posA * 128.0);
#		posB = fract(posB * 128.0);
#		// each rune touches the edge of its box on all 4 sides
#
#		if (i == 0) posA.y = 0.0;
#		if (i == 1) posA.x = 0.999;
#		if (i == 2) posA.x = 0.0;
#		if (i == 3) posA.y = 0.999;
#
#		// snap the random line endpoints to a grid 2x3
#		vec2 snaps = vec2(2.0, 3.0);
#		posA = (floor(posA * snaps) + 0.5) / snaps; // + 0.5 to center it in a grid cell
#		posB = (floor(posB * snaps) + 0.5) / snaps;
#
#		//if (distance(posA, posB) < 0.0001) continue;
#		// eliminate dots.
#		// Dots (degenerate lines) are not cross-GPU safe without adding 0.001 - divide by 0 error.
#		finalLine = max(finalLine, ThickLine(uv, posA, posB + 0.001, 20.0));
#	}
#
#	return finalLine;
#}

# makes a rune in the 0..1 uv space. Seed is which rune to draw.
# passes back gray in x and derivates for lighting in yz
static func rune(uv : Vector2, pseed : float) -> float:
	var finalLine : float = 0.0;
	var sseed : Vector2 = floorv2(uv) - Vector2(pseed, pseed);
	
	uv = fractv2(uv);
	
	for i in range(4):# (int i = 0; i < 4; i++):  #	// number of strokes
		var posA : Vector2 = rand2(floorv2(sseed + Vector2(0.5, 0.5)));
		var posB : Vector2 = rand2(floorv2(sseed + Vector2(1.5, 1.5)));
		sseed.x += 2.0;
		sseed.y += 2.0;
		
		# expand the range and mod it to get a nicely distributed random number - hopefully. :)
		
		posA = fractv2(posA * 128.0);
		posB = fractv2(posB * 128.0);
		
		# each rune touches the edge of its box on all 4 sides
		if (i == 0):
			posA.y = 0.0;
			
		if (i == 1):
			posA.x = 0.999;
			
		if (i == 2):
			posA.x = 0.0;
			
		if (i == 3):
			posA.y = 0.999;
		
		# snap the random line endpoints to a grid 2x3
		
		var snaps : Vector2 = Vector2(2.0, 3.0);
		
		posA = (floorv2(posA * snaps) + Vector2(0.5, 0.5)) / snaps; # + 0.5 to center it in a grid cell
		posB = (floorv2(posB * snaps) + Vector2(0.5, 0.5)) / snaps;
		
		#if (distance(posA, posB) < 0.0001) continue;	// eliminate dots.
		# Dots (degenerate lines) are not cross-GPU safe without adding 0.001 - divide by 0 error.
		
		finalLine = max(finalLine, ThickLine(uv, posA, posB + Vector2(0.001, 0.001), 20.0));
	
	return finalLine;

static func IChingc(uv : Vector2, row_col : Vector2, pseed : int) -> Color:
	var f : float =  IChing(row_col * uv, float(pseed));

	return Color(f, f, f, 1)

#float IChing(vec2 uv, float seed) {
#	int value = int(32.0*rand(floor(uv)+vec2(seed)));
#	float base = step(0.5, fract(fract(uv.y)*6.5))*step(0.04, fract(uv.y+0.02))*step(0.2, fract(uv.x+0.1));
#	int bit = int(fract(uv.y)*6.5);
#
#	return base*step(0.1*step(float(bit & value), 0.5), fract(uv.x+0.55));
#}

static func IChing(uv : Vector2, pseed : float) -> float:
	var value : int = int(32.0 * rand(floorv2(uv) + Vector2(pseed, pseed)));
	var base : float = step(0.5, fract(fract(uv.y)*6.5))*step(0.04, fract(uv.y+0.02)) * step(0.2, fract(uv.x+0.1));
	var bit : int = int(fract(uv.y)*6.5);
	
	return base * step(0.1*step(float(bit & value), 0.5), fract(uv.x+0.55));

#Beehive output 1
#Shows the greyscale pattern
#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);
#1.0-2.0*beehive_dist($(name_uv)_center.xy) 

static func beehive_1c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	return Color(f, f, f, 1)

#Beehive output 2
#Shows a random color for each hexagonal tile
#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);
#rand3(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed)))

static func beehive_2c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	var v : Vector3 = rand3(fractv2(Vector2(center.b, center.a) / Vector2(size.x, size.y)) + Vector2(float(pseed),float(pseed)));
	
	return Color(v.x, v.y, v.z, 1)

#Beehive output 3
#Shows an UV map to be connected to the UV map port of the Custom UV node
#vec3(vec2(0.5)+$(name_uv)_center.xy, rand(fract($(name_uv)_center.zw/vec2($sx, $sy))+vec2(float($seed)))) 
#vec2 $(name_uv)_uv = $uv*vec2($sx, $sy*1.73205080757);
#vec4 $(name_uv)_center = beehive_center($(name_uv)_uv);

static func beehive_3c(uv : Vector2, size : Vector2, pseed : int) -> Color:
	var o80035_0_uv : Vector2 = uv * Vector2(size.x, size.y * 1.73205080757);
	var center : Color = beehive_center(o80035_0_uv);
	
	#var f : float = 1.0 - 2.0 * beehive_dist(Vector2(center.r, center.g));
	
	var v1 : Vector2 = Vector2(0.5, 0.5) + Vector2(center.r, center.g)
	var ff : float = rand(fractv2(Vector2(center.b, center.a) / Vector2(size.x, size.y)) + Vector2(float(pseed), float(pseed)))
	
	var c : Color = Color(v1.x, v1.y, ff, ff);
	
	return c

#float beehive_dist(vec2 p){
#	ec2 s = vec2(1.0, 1.73205080757);    
#	p = abs(p);    
#	return max(dot(p, s*.5), p.x);
#}

static func beehive_dist(p : Vector2) -> float:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	p = absv2(p);
	
	return max(p.dot(s*.5), p.x);

#vec4 beehive_center(vec2 p) {
#	vec2 s = vec2(1.0, 1.73205080757);    
#	vec4 hC = floor(vec4(p, p - vec2(.5, 1)) / vec4(s,s)) + .5;    
#	vec4 h = vec4(p - hC.xy*s, p - (hC.zw + .5)*s);  
#	return dot(h.xy, h.xy)<dot(h.zw, h.zw) ? vec4(h.xy, hC.xy) : vec4(h.zw, hC.zw + 9.73);
#}

static func beehive_center(p : Vector2) -> Color:
	var s : Vector2 = Vector2(1.0, 1.73205080757);
	
	var hC : Color = Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y);
	
	hC = floorc(Color(p.x, p.y, p.x - 0.5, p.y - 1) / Color(s.x, s.y, s.x, s.y)) + Color(0.5, 0.5, 0.5, 0.5);
	
	var v1 : Vector2 = Vector2(p.x - hC.r * s.x, p.y - hC.g * s.y)
	var v2 : Vector2 = Vector2(p.x - (hC.b + 0.5) * s.x, p.y - (hC.a + 0.5) * s.y)
	
	var h : Color = Color(v1.x, v1.y, v2.x, v2.y);
	
	if Vector2(h.r, h.g).dot(Vector2(h.r, h.g)) < Vector2(h.b, h.a).dot(Vector2(h.b, h.a)):
		return Color(h.r, h.g, hC.r, hC.g) 
	else:
		return Color(h.b, h.a, hC.b + 9.73, hC.a + 9.73)
	
	#return dot(h.xy, h.xy) < dot(h.zw, h.zw) ? Color(h.xy, hC.xy) : Color(h.zw, hC.zw + 9.73);

#vec3 brick_corner_uv(vec2 uv, vec2 bmin, vec2 bmax, float mortar, float corner, float seed) {
#	vec2 center = 0.5*(bmin + bmax);
#	vec2 size = bmax - bmin;
#
#	float max_size = max(size.x, size.y);
#	float min_size = min(size.x, size.y);
#
#	mortar *= min_size;
#	corner *= min_size;
#
#	return vec3(clamp((0.5*size-vec2(mortar)-abs(uv-center))/corner, vec2(0.0), vec2(1.0)), rand(fract(center)+vec2(seed)+ceil(vec2(uv-center))));
#}

static func brick_corner_uv(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, corner : float, pseed : float) -> Vector3:
	var center : Vector2 = 0.5 * (bmin + bmax)
	var size : Vector2 = bmax - bmin
	var max_size : float = max(size.x, size.y)
	var min_size : float = min(size.x, size.y)
	mortar *= min_size
	corner *= min_size
	
	var r : Vector3 = Vector3()
	
	r.x = clamp(((0.5 * size.x - mortar) - abs(uv.x - center.x)) / corner, 0, 1)
	r.y = clamp(((0.5 * size.y - mortar) - abs(uv.y - center.y)) / corner, 0, 1)
	r.z = rand(fractv2(center) + Vector2(pseed, pseed))

	return r
	
#	return vec3(clamp((0.5*size-vec2(mortar)-abs(uv-center))/corner, vec2(0.0), vec2(1.0)), rand(fract(center)+vec2(seed)));

#vec4 brick(vec2 uv, vec2 bmin, vec2 bmax, float mortar, float round, float bevel) {
#	float color;
#	vec2 size = bmax - bmin;
#	float min_size = min(size.x, size.y);
#
#	mortar *= min_size;
#	bevel *= min_size;
#	round *= min_size;
#	vec2 center = 0.5*(bmin+bmax);    
#	vec2 d = abs(uv-center)-0.5*(size)+vec2(round+mortar);    
#
#	color = length(max(d,vec2(0))) + min(max(d.x,d.y),0.0)-round;
#	color = clamp(-color/bevel, 0.0, 1.0);
#	vec2 tiled_brick_pos = mod(bmin, vec2(1.0, 1.0));
#
#	return vec4(color, center, tiled_brick_pos.x+7.0*tiled_brick_pos.y);
#}

static func brick(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, pround : float, bevel : float) -> Color:
	var color : float
	var size : Vector2 = bmax - bmin

	var min_size : float = min(size.x, size.y)
	mortar *= min_size
	bevel *= min_size
	pround *= min_size

	var center : Vector2 = 0.5 * (bmin + bmax)
	var d : Vector2 = Vector2()
	
	d.x = abs(uv.x - center.x) - 0.5 * (size.x) + (pround + mortar)
	d.y = abs(uv.y - center.y) - 0.5 * (size.y) + (pround + mortar)
	
	color = Vector2(max(d.x, 0), max(d.y, 0)).length() + min(max(d.x, d.y), 0.0) - pround
	
	color = clamp(-color / bevel, 0.0, 1.0)

#	var tiled_brick_pos : Vector2 = Vector2(bmin.x - 1.0 * floor(bmin.x / 1.0), bmin.y - 1.0 * floor(bmin.y / 1.0))

	var tiled_brick_pos_x : float = bmin.x - 1.0 * floor(bmin.x / 1.0)
	var tiled_brick_pos_y : float = bmin.y - 1.0 * floor(bmin.y / 1.0)
	
	#vec2 tiled_brick_pos = mod(bmin, vec2(1.0, 1.0));
	
	return Color(color, center.x, center.y, tiled_brick_pos_x + 7.0 * tiled_brick_pos_y)

#vec3 brick_random_color(vec2 bmin, vec2 bmax, float seed) {
#	vec2 center = 0.5*(bmin + bmax);
#	return rand3(fract(center + vec2(seed)));
#}

static func brick_random_color(bmin : Vector2, bmax : Vector2, pseed : float) -> Vector3:
	var center : Vector2 = (bmin + bmax)
	center.x *= 0.5
	center.y *= 0.5
	
	return rand3(fractv2(center + Vector2(pseed, pseed)));

#vec3 brick_uv(vec2 uv, vec2 bmin, vec2 bmax, float seed) {
#	vec2 center = 0.5*(bmin + bmax);
#	vec2 size = bmax - bmin;
#
#	float max_size = max(size.x, size.y);
#
#	return vec3(0.5+(uv-center)/max_size, rand(fract(center)+vec2(seed)));
#}

static func brick_uv(uv : Vector2, bmin : Vector2, bmax : Vector2, pseed : float) -> Vector3:
	var center : Vector2 = 0.5 * (bmin + bmax)
	var size : Vector2 = bmax - bmin
	var max_size : float = max(size.x, size.y)
	
	var x : float = 0.5+ (uv.x - center.x) / max_size
	var y : float = 0.5+ (uv.y - center.y) /max_size
	
	return Vector3(x, y, rand(fractv2(center) + Vector2(pseed, pseed)))

#vec4 bricks_rb(vec2 uv, vec2 count, float repeat, float offset) {
#	count *= repeat;float x_offset = offset*step(0.5, fract(uv.y*count.y*0.5));
#
#	vec2 bmin = floor(vec2(uv.x*count.x-x_offset, uv.y*count.y));
#
#	bmin.x += x_offset;
#	bmin /= count;
#
#	return vec4(bmin, bmin+vec2(1.0)/count);
#}

static func bricks_rb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat
	
	var x_offset : float = offset * step(0.5, fractf(uv.y * count.y * 0.5))
	
	var bmin : Vector2
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)
	
	bmin.x += x_offset;
	bmin /= count
	var bmc : Vector2 = bmin + Vector2(1.0, 1.0) /  count

	return Color(bmin.x, bmin.y, bmc.x, bmc.y)

#vec4 bricks_rb2(vec2 uv, vec2 count, float repeat, float offset) {
#	count *= repeat;
#
#	float x_offset = offset*step(0.5, fract(uv.y*count.y*0.5));
#	count.x = count.x*(1.0+step(0.5, fract(uv.y*count.y*0.5)));
#
#	vec2 bmin = floor(vec2(uv.x*count.x-x_offset, uv.y*count.y));
#
#	bmin.x += x_offset;
#	bmin /= count;
#
#	return vec4(bmin, bmin+vec2(1.0)/count);
#}

static func bricks_rb2(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	count *= repeat

	var x_offset : float = offset * step(0.5, fractf(uv.y * count.y * 0.5))
	count.x = count.x * (1.0+step(0.5, fractf(uv.y * count.y * 0.5)))
	var bmin : Vector2 = Vector2()
	
	bmin.x = floor(uv.x * count.x - x_offset)
	bmin.y = floor(uv.y * count.y)

	bmin.x += x_offset
	bmin /= count
	
	var b : Vector2 = bmin + Vector2(1, 1) / count
	
	return Color(bmin.x, bmin.y, b.x, b.y)

#vec4 bricks_hb(vec2 uv, vec2 count, float repeat, float offset) {
#	float pc = count.x+count.y;
#	float c = pc*repeat;
#	vec2 corner = floor(uv*c);
#	float cdiff = mod(corner.x-corner.y, pc);
#
#	if (cdiff < count.x) {
#		return vec4((corner-vec2(cdiff, 0.0))/c, (corner-vec2(cdiff, 0.0)+vec2(count.x, 1.0))/c);
#	} else {
#		return vec4((corner-vec2(0.0, pc-cdiff-1.0))/c, (corner-vec2(0.0, pc-cdiff-1.0)+vec2(1.0, count.y))/c);
#	}
#}

static func bricks_hb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var pc : float = count.x + count.y
	var c : float = pc * repeat
	
	var corner : Vector2 = Vector2(floor(uv.x * c), floor(uv.y * c))
	var cdiff : float = modf(corner.x - corner.y, pc)

	if (cdiff < count.x):
		var col : Color = Color()
		
		col.r = (corner.x - cdiff) / c
		col.g = corner.y / c
		
		col.b = (corner.x - cdiff + count.x) / c
		col.a = (corner.y + 1.0) / c
		
		return col
	else:
		var col : Color = Color()
		
		col.r = corner.x / c
		col.g = (corner.y - (pc - cdiff - 1.0)) / c
		
		col.b = (corner.x + 1.0) / c
		col.a = (corner.y - (pc - cdiff - 1.0) + count.y) / c
		
		return col

#vec4 bricks_bw(vec2 uv, vec2 count, float repeat, float offset) {
#	vec2 c = 2.0*count*repeat;
#	float mc = max(c.x, c.y);
#	vec2 corner1 = floor(uv*c);
#	vec2 corner2 = count*floor(repeat*2.0*uv);
#	float cdiff = mod(dot(floor(repeat*2.0*uv), vec2(1.0)), 2.0);
#	vec2 corner;
#	vec2 size;
#
#	if (cdiff == 0.0) {
#		orner = vec2(corner1.x, corner2.y);
#		size = vec2(1.0, count.y);
#	} else {
#		corner = vec2(corner2.x, corner1.y);
#		size = vec2(count.x, 1.0);
#	}
#
#	return vec4(corner/c, (corner+size)/c);
#}

static func bricks_bw(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var c : Vector2 = 2.0 * count * repeat
	var mc : float = max(c.x, c.y)
	var corner1 : Vector2 = Vector2(floor(uv.x * c.x), floor(uv.y * c.y))
	var corner2 : Vector2 = Vector2(count.x * floor(repeat* 2.0 * uv.x), count.y * floor(repeat * 2.0 * uv.y))
	
	var tmp : Vector2 = Vector2(floor(repeat * 2.0 * uv.x), floor(repeat * 2.0 * uv.y))
	var cdiff : float = modf(tmp.dot(Vector2(1, 1)), 2.0)
	
	var corner : Vector2
	var size : Vector2

	if cdiff == 0:
		corner = Vector2(corner1.x, corner2.y)
		size = Vector2(1.0, count.y)
	else:
		corner = Vector2(corner2.x, corner1.y)
		size = Vector2(count.x, 1.0)

	return Color(corner.x / c.x, corner.y / c.y, (corner.x + size.x) / c.x, (corner.y + size.y) / c.y)

#vec4 bricks_sb(vec2 uv, vec2 count, float repeat, float offset) {
#	vec2 c = (count+vec2(1.0))*repeat;
#	float mc = max(c.x, c.y);
#	vec2 corner1 = floor(uv*c);
#	vec2 corner2 = (count+vec2(1.0))*floor(repeat*uv);
#	vec2 rcorner = corner1 - corner2;
#	vec2 corner;
#	vec2 size;
#
#	if (rcorner.x == 0.0 && rcorner.y < count.y) {
#		corner = corner2;
#		size = vec2(1.0, count.y);
#	} else if (rcorner.y == 0.0) {
#		corner = corner2+vec2(1.0, 0.0);
#		size = vec2(count.x, 1.0);
#	} else if (rcorner.x == count.x) {
#		corner = corner2+vec2(count.x, 1.0);
#		size = vec2(1.0, count.y);
#	} else if (rcorner.y == count.y) {
#		corner = corner2+vec2(0.0, count.y);
#		size = vec2(count.x, 1.0);
#	} else {
#		corner = corner2+vec2(1.0);
#		size = vec2(count.x-1.0, count.y-1.0);
#	}
#
#	return vec4(corner/c, (corner+size)/c);
#}

static func bricks_sb(uv : Vector2, count : Vector2, repeat : float, offset : float) -> Color:
	var c : Vector2 = (count + Vector2(1, 1)) * repeat
	var mc : float = max(c.x, c.y)
	var corner1 : Vector2 = Vector2(floor(uv.x * c.x), floor(uv.y * c.y))
	var corner2 : Vector2 = (count + Vector2(1, 1)) * Vector2(floor(repeat * uv.x), floor(repeat * uv.y))
	var rcorner : Vector2 = corner1 - corner2

	var corner : Vector2
	var size : Vector2

	if (rcorner.x == 0.0 && rcorner.y < count.y):
		corner = corner2
		size = Vector2(1.0, count.y)
	elif (rcorner.y == 0.0):
		corner = corner2 + Vector2(1.0, 0.0)
		size = Vector2(count.x, 1.0)
	elif (rcorner.x == count.x):
		corner = corner2 + Vector2(count.x, 1.0)
		size = Vector2(1.0, count.y)
	elif (rcorner.y == count.y):
		corner = corner2 + Vector2(0.0, count.y)
		size = Vector2(count.x, 1.0)
	else:
		corner = corner2 + Vector2(1, 1)
		size = Vector2(count.x-1.0, count.y-1.0)

	return Color(corner.x / c.x, corner.y / c.y, (corner.x + size.x) / c.x, (corner.y + size.y) / c.y)

#vec4 brick2(vec2 uv, vec2 bmin, vec2 bmax, float mortar, float round, float bevel) {
#	float color;
#	vec2 size = bmax - bmin;
#	vec2 center = 0.5*(bmin+bmax);    
#	vec2 d = abs(uv-center)-0.5*(size)+vec2(round+mortar);    
#
#	color = length(max(d,vec2(0))) + min(max(d.x,d.y),0.0)-round;
#	color = clamp(-color/bevel, 0.0, 1.0);
#
#	vec2 tiled_brick_pos = mod(bmin, vec2(1.0, 1.0));
#
#	return vec4(color, center, tiled_brick_pos.x+7.0*tiled_brick_pos.y);
#}

static func brick2(uv : Vector2, bmin : Vector2, bmax : Vector2, mortar : float, pround : float, bevel : float) -> Color:
	return Color()

#vec4 bricks_uneven(vec2 uv, int iterations, float min_size, float randomness, float seed) {
#	vec2 a = vec2(0.0);
#	vec2 b = vec2(1.0);
#	for (int i = 0; i < iterations; ++i) {
#		vec2 size = b-a;
#		if (max(size.x, size.y) < min_size) {
#			break;
#		}
#
#		float x = rand(rand2(vec2(rand(a+b), seed)))*randomness+(1.0-randomness)*0.5;
#
#		if (size.x > size.y) {
#			x *= size.x;
#
#			if (uv.x > a.x+x) {
#				a.x += x;
#			} else {
#				b.x = a.x + x;
#			}
#		} else {
#			x *= size.y;
#
#			if (uv.y > a.y+x) {
#				a.y += x;
#			} else {
#				b.y = a.y + x;
#			}
#		}
#	}
#
#	return vec4(a, b);
#}

static func bricks_uneven(uv : Vector2, iterations : int, min_size : float, randomness : float, pseed : float) -> Color:
	return Color()


#vec2 truchet_generic_uv(vec2 uv, vec2 seed) {
#	vec2 i = floor(uv);
#	vec2 f = fract(uv);
#	vec2 invert = step(rand2(seed+i), vec2(0.5));
#
#	return f*(vec2(1.0)-invert)+(vec2(1.0)-f)*invert;
#}

static func truchet_generic_uv(uv : Vector2, pseed : float) -> Vector2:
	return Vector2()


#float pavement(vec2 uv, float bevel, float mortar) {\n\t
#	uv = abs(uv-vec2(0.5));\n\t
#
#	return clamp((0.5*(1.0-mortar)-max(uv.x, uv.y))/max(0.0001, bevel), 0.0, 1.0);
#}

#vec4 arc_pavement(vec2 uv, float acount, float lcount, out vec2 seed) {\n\t
#	float PI = 3.141592654;\n\t
#	float radius = (0.5/sqrt(2.0));\n    
#	float uvx = uv.x;\n    
#	uv.x = 0.5*fract(uv.x+0.5)+0.25;\n    
#	float center = (uv.x-0.5)/radius;\n    
#	center *= center;\n    
#	center = floor(acount*(uv.y-radius*sqrt(1.0-center))+0.5)/acount;\n    
#
#	vec2 v = uv-vec2(0.5, center);\n    
#	float cornerangle = 0.85/acount+0.25*PI;\n    
#	float acountangle = (PI-2.0*cornerangle)/(lcount+floor(mod(center*acount, 2.0)));\n    
#	float angle = mod(atan(v.y, v.x), 2.0*PI);\n\t
#
#	float base_angle;\n\t
#	float local_uvy = 0.5+acount*(length(v)-radius)*(1.54-0.71*cos(1.44*(angle-PI*0.5)));\n\t
#	vec2 local_uv;\n    
#
#	if (angle < cornerangle) {\n        
#		base_angle = 0.25*PI;\n\t\t
#		local_uv = vec2((angle-0.25*PI)/cornerangle*0.38*acount+0.5, 1.0-local_uvy);\n\t\t
#		seed = vec2(fract(center), 0.0);\n    
#	} else if (angle > PI-cornerangle) {\n        
#		base_angle = 0.75*PI;\n\t\t
#		local_uv = vec2(local_uvy, 0.5-(0.75*PI-angle)/cornerangle*0.38*acount);\n\t\t
#		seed = vec2(fract(center), 0.0);\n    
#	} else {\n        
#		base_angle = cornerangle+(floor((angle-cornerangle)/acountangle)+0.5)*acountangle;\n\t\t
#		local_uv = vec2((angle-base_angle)/acountangle+0.5, 1.0-local_uvy);\n\t\t
#		seed = vec2(fract(center), base_angle);\n    
#	}\n    
#
#	vec2 brick_center = vec2(0.5, center)+radius*vec2(cos(base_angle), sin(base_angle));\n    
#
#	return vec4(brick_center.x+uvx-uv.x, brick_center.y, local_uv);\n
#}


# ====================== SDF2D.GD ========================


#----------------------
#sdarc.mmg
#An arc as a signed distance function

#"outputs": [
#{
#	"longdesc": "The arc as a signed distance function",
#	"sdf2d": "sdArc($uv-vec2(0.5), mod($a1, 360.0)*0.01745329251, mod($a2, 360.0)*0.01745329251, $r1, $r2)",
#	"shortdesc": "Output",
#	"type": "sdf2d"
#}
#],
#"parameters": [
#{
#	"control": "Angle1.a",
#	"default": 0,
#	"label": "Angle 1",
#	"longdesc": "The first angle of the arc",
#	"max": 180,
#	"min": -180,
#	"name": "a1",
#	"shortdesc": "Angle1",
#	"step": 1,
#	"type": "float"
#},
#{
#	"control": "Angle2.a",
#	"default": 0,
#	"label": "Angle 2",
#	"longdesc": "The second angle of the arc",
#	"max": 180,
#	"min": -180,
#	"name": "a2",
#	"shortdesc": "Angle2",
#	"step": 1,
#	"type": "float"
#},
#{
#	"control": "Radius1.r",
#	"default": 0.5,
#	"label": "Radius",
#	"longdesc": "The radius of the arc",
#	"max": 1,
#	"min": 0,
#	"name": "r1",
#	"shortdesc": "Radius",
#	"step": 0.01,
#	"type": "float"
#},
#{
#	"control": "Radius11.r",
#	"default": 0.1,
#	"label": "Width",
#	"longdesc": "The width of the shape around the arc",
#	"max": 1,
#	"min": 0,
#	"name": "r2",
#	"shortdesc": "Width",
#	"step": 0.01,
#	"type": "float"
#}
#]

#----------------------
#sdboolean.mmg
#Performs a boolean operation (union, intersection or difference) between two shapes

#"inputs": [
#{
#	"default": "0.0",
#	"label": "",
#	"longdesc": "The first shape, defined as a signed distance function",
#	"name": "in1",
#	"shortdesc": "Input1",
#	"type": "sdf2d"
#},
#{
#	"default": "0.0",
#	"label": "",
#	"longdesc": "The second shape, defined as a signed distance function",
#	"name": "in2",
#	"shortdesc": "Input2",
#	"type": "sdf2d"
#}
#],
#"outputs": [
#{
#	"longdesc": "The shape generated by the boolean operation",
#	"sdf2d": "$op $in1($uv), $in2($uv))",
#	"shortdesc": "Output",
#	"type": "sdf2d"
#}
#],
#"parameters": [
#{
#	"default": 2,
#	"label": "",
#	"longdesc": "The operation performed by this node",
#	"name": "op",
#	"shortdesc": "Operation",
#	"type": "enum",
#	"values": [
#		{
#		"name": "Union",
#		"value": "min("
#		},
#		{
#		"name": "Subtraction",
#		"value": "max(-"
#		},
#		{
#		"name": "Intersection",
#		"value": "max("
#		}
#	]
#}
#],

#----------------------
#sdbox.mmg
#A rectangle described as a signed distance function

#		"code": "vec2 $(name_uv)_d = abs($uv-vec2($cx+0.5, $cy+0.5))-vec2($w, $h);",
#		"outputs": [
#			{
#				"longdesc": "The generated signed distance function",
#				"sdf2d": "length(max($(name_uv)_d,vec2(0)))+min(max($(name_uv)_d.x,$(name_uv)_d.y),0.0)",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "Rect1.x",
#				"default": 0.5,
#				"label": "Width",
#				"longdesc": "The width of the box",
#				"max": 1,
#				"min": 0,
#				"name": "w",
#				"shortdesc": "Width",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "Rect1.y",
#				"default": 1,
#				"label": "Height",
#				"longdesc": "The height of the box",
#				"max": 1,
#				"min": 0,
#				"name": "h",
#				"shortdesc": "Height",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "Center X",
#				"longdesc": "The position of the center of the box on the X axis",
#				"max": 1,
#				"min": -1,
#				"name": "cx",
#				"shortdesc": "Center.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Center Y",
#				"longdesc": "The position of the center of the box on the Y axis",
#				"max": 1,
#				"min": -1,
#				"name": "cy",
#				"shortdesc": "Center.y",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#sdcircle.mmg
#A circle described as a signed distance function

#		"outputs": [
#			{
#				"longdesc": "The generated signed distance function",
#				"sdf2d": "length($uv-vec2($cx+0.5, $cy+0.5))-$r",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "Radius1.r",
#				"default": 0.5,
#				"label": "Radius",
#				"longdesc": "The radius of the circle",
#				"max": 1,
#				"min": 0,
#				"name": "r",
#				"shortdesc": "Radius",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "Center X",
#				"longdesc": "The position of the center on the X axis",
#				"max": 1,
#				"min": -1,
#				"name": "cx",
#				"shortdesc": "Center.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Center Y",
#				"longdesc": "The position of the center on the Y axis",
#				"max": 1,
#				"min": -1,
#				"name": "cy",
#				"shortdesc": "Center.y",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#sdcirclerepeat.mmg
#Repeats its input shape around a circle

#Output:
#Out, sdf2d (float) (property)
#$in(circle_repeat_transform_2d($uv-vec2(0.5), $c)+vec2(0.5))

#Input:
#in, float (sdf2d), default : 0
#count, int, min: 1, max: 32, default: 6

#----------------------
#sdelongation.mmg

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "",
#				"name": "in",
#				"type": "sdf2d"
#			}
#		],
#		"outputs": [
#			{
#				"sdf2d": "$in($uv-clamp($uv-vec2(0.5), -vec2($x, $y), vec2($x, $y)))",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "Rect1.x",
#				"default": 0,
#				"label": "X",
#				"max": 1,
#				"min": 0,
#				"name": "x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "Rect1.y",
#				"default": 0,
#				"label": "Y",
#				"max": 1,
#				"min": 0,
#				"name": "y",
#				"step": 0.01,
#				"type": "float"
#			}
#		]

#----------------------
#sdline.mmg
#A line or a capsule shape described as a signed distance function

#vec2 $(name_uv)_sdl = sdLine($uv, vec2($ax+0.5, $ay+0.5), vec2($bx+0.5, $by+0.5));

#Outputs
#output, sdf2d (float), (output property)
#$(name_uv)_sdl.x-$r*$profile($(name_uv)_sdl.y)

#Inputs
#A, Vector2, min: -1, max: 1, step: 0.01, default: (-0.3, -0.3)
#B, Vector2, min: -1, max: 1, step: 0.01, default: (0.3, 0.3)
#width, float, min: 0, max: 1, step: 0.01, default: 0.1
#points (curve), default: 0, 0, 0, 1,  0, 0, 1, 1

#----------------------
#sdmorph.mmg
#Morphs between 2 input shapes

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The first shape, defined as a signed distance function",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "sdf2d"
#			},
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The second shape, defined as a signed distance function",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "sdf2d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated hybrid shape",
#				"sdf2d": "mix($in1($uv), $in2($uv), $amount)",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "",
#				"longdesc": "The amount of the second input in the result",
#				"max": 1,
#				"min": 0,
#				"name": "amount",
#				"shortdesc": "Amount",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#sdngon.mmg (inc sdrotate.mmg, sdcirclerepeat.mmg)
#An n-gon described as a signed distance function

#		"outputs": [
#			{
#				"longdesc": "The n-gon as a signed distance function",
#				"sdf2d": "sdNgon(sdf2d_rotate($uv-vec2($cx, $cy), $rot*0.01745329251-1.57079632679)-vec2(0.5), $r, $n)",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 3,
#				"label": "N",
#				"longdesc": "The number of sides of the n-gon",
#				"max": 12,
#				"min": 3,
#				"name": "n",
#				"shortdesc": "N",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "Radius1.r",
#				"default": 0.5,
#				"label": "Radius",
#				"longdesc": "The radius of the n-gon",
#				"max": 1,
#				"min": 0,
#				"name": "r",
#				"shortdesc": "Radius",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "Radius1.a",
#				"default": 0,
#				"label": "Rotation",
#				"longdesc": "The rotation of the n-gon",
#				"max": 180,
#				"min": -180,
#				"name": "rot",
#				"shortdesc": "Rotation",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "Center X",
#				"longdesc": "The position of the center on the X axis",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "cx",
#				"shortdesc": "Center.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Center Y",
#				"longdesc": "The position of the center on the Y axis",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "cy",
#				"shortdesc": "Center.y",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#sdpolygon.mmg
#A polygon as a signed distance function

#Output:
#Out, sdf2d (float) (property)
#sdPolygon_$(name)($uv)

#Input:
#polygon points, default: 0.2, 0.2,  0.4, 0.7,  0.7, 0.4

#----------------------
#sdrepeat.mmg
#Repeats its input shape on a grid.This node does not support overlapping between instances.

#Output:
#Out, sdf2d (float) (property)
#$in(repeat_2d($uv, vec2(1.0/$rx, 1.0/$ry), float($seed), $r))

#Input:
#in, float (sdf2d), default : 0
#x, int, min: 1, max: 32, default: 4
#y, int, min: 1, max: 32, default: 4
#random_rotation, min: 0, max: 1, step:0.01, default: 0.5

#----------------------
#sdrhombus.mmg
#A rhombus described as a signed distance function

#		"outputs": [
#			{
#				"longdesc": "The rhombus as a signed distance function",
#				"sdf2d": "sdRhombus($uv-vec2($cx+0.5, $cy+0.5), vec2($w, $h))",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "Rect1.x",
#				"default": 0.5,
#				"label": "Width",
#				"longdesc": "The width of the rhombus",
#				"max": 1,
#				"min": 0,
#				"name": "w",
#				"shortdesc": "Width",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "Rect1.y",
#				"default": 1,
#				"label": "Height",
#				"longdesc": "The height of the rhombus",
#				"max": 1,
#				"min": 0,
#				"name": "h",
#				"shortdesc": "Height",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "Center X",
#				"longdesc": "The position of the center on the X axis",
#				"max": 1,
#				"min": -1,
#				"name": "cx",
#				"shortdesc": "Center.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Center Y",
#				"longdesc": "The position of the center on the Y axis",
#				"max": 1,
#				"min": -1,
#				"name": "cy",
#				"shortdesc": "Center.y",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#sdrotate.mmg
#Rotates its input shape described as a signed distance function

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The input shape, defined as a signed distance function",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "sdf2d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The rotated shape",
#				"sdf2d": "$in(sdf2d_rotate($uv, $a*0.01745329251))",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "Radius1.a",
#				"default": 0,
#				"label": "",
#				"longdesc": "The rotation angle",
#				"max": 180,
#				"min": -180,
#				"name": "a",
#				"shortdesc": "Angle",
#				"step": 1,
#				"type": "float"
#			}
#		],

#----------------------
#sdroundedshape.mmg
#Dilates an input shape into a rounded shape

#Output:
#Out, sdf2d (float) (property)
#$in($uv)-$r

#Input:
#in, float (sdf2d), default : 0
#radius, min: 0, max: 1, step:0.01, default: 0

#----------------------
#sdscale.mmg
#Scales its input shape described as a signed distance function

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The input shape, defined as a signed distance function",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "sdf2d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated scaled shape",
#				"sdf2d": "$in(($uv-vec2(0.5))/$s+vec2(0.5))*$s",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "Scale1.x",
#				"default": 1,
#				"label": "",
#				"longdesc": "The scale of the transform",
#				"max": 5,
#				"min": 0,
#				"name": "s",
#				"shortdesc": "Scale",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#sdshow.mmg
#Creates a greyscale image from a shape described as a 2D Signed Distance Function

#Output

#Output float (color) - Shows the shape as a greyscale image
#clamp($base-$in($uv)/max($bevel, 0.00001), 0.0, 1.0)

#Input:
#Input (sdf - shape), default: 0 - sdf2d - universal input
#bevel, float, min 0, max 1, step 0.01, default 0
#base, float, min 0, max 1, step 0.01, default 0

#----------------------
#sdsmoothboolean.mmg
#Performs a smooth boolean operation (union, intersection or difference) between two shapes

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The first shape, defined as a signed distance function",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "sdf2d"
#			},
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The second shape, defined as a signed distance function",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "sdf2d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The shape generated by the boolean operation",
#				"sdf2d": "sdSmooth$op($in1($uv), $in2($uv), $k)",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "The operation performed by this node",
#				"name": "op",
#				"shortdesc": "Operation",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Union",
#						"value": "Union"
#					},
#					{
#						"name": "Subtraction",
#						"value": "Subtraction"
#					},
#					{
#						"name": "Intersection",
#						"value": "Intersection"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The smoothness of the boolean operation",
#				"max": 1,
#				"min": 0,
#				"name": "k",
#				"shortdesc": "Smoothness",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#sdtranslate.mmg
#Translates its input shape described as signed distance function

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The input shape, defined as a signed distance function",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "sdf2d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The translated shape",
#				"sdf2d": "$in($uv-vec2($x, $y))",
#				"shortdesc": "Output",
#				"type": "sdf2d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "X",
#				"longdesc": "The translation along the X axis",
#				"max": 1,
#				"min": -1,
#				"name": "x",
#				"shortdesc": "Translate.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Y",
#				"longdesc": "The translation along the Y axis",
#				"max": 1,
#				"min": -1,
#				"name": "y",
#				"shortdesc": "Translate.y",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#curve.mmg

#		"code": "vec2 $(name_uv)_bezier = sdBezier($uv, vec2($ax+0.5, $ay+0.5), vec2($bx+0.5, $by+0.5), vec2($cx+0.5, $cy+0.5));\nvec2 $(name_uv)_uv = vec2($(name_uv)_bezier.x, $(name_uv)_bezier.y/$width+0.5);\nvec2 $(name_uv)_uvtest = step(vec2(0.5), abs($(name_uv)_uv-vec2(0.5)));\n$(name_uv)_uv = mix(vec2(fract($repeat*$(name_uv)_uv.x), $(name_uv)_uv.y), vec2(0.0), max($(name_uv)_uvtest.x, $(name_uv)_uvtest.y));\n",
#		"inputs": [
#			{
#				"default": "vec4(vec3(step(abs($uv.y-0.5), 0.4999)), 1.0)",
#				"label": "",
#				"longdesc": "Input pattern to be drawn along the curve",
#				"name": "in",
#				"shortdesc": "Pattern",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "An image showing the specified curve",
#				"rgba": "$in($(name_uv)_uv)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "P1.x",
#				"default": -0.3,
#				"label": "AX",
#				"longdesc": "Position on X axis of the first control point",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "ax",
#				"shortdesc": "A.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": -0.1,
#				"label": "AY",
#				"longdesc": "Position on Y axis of the first control point",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "ay",
#				"shortdesc": "A.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P3.x",
#				"default": -0,
#				"label": "BX",
#				"longdesc": "Position on X axis of the second control point",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "bx",
#				"shortdesc": "B.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P3.y",
#				"default": 0.2,
#				"label": "BY",
#				"longdesc": "Position on Y axis of the second control point",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "by",
#				"shortdesc": "B.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P2.x",
#				"default": 0.3,
#				"label": "CX",
#				"longdesc": "Position on X axis of the third control point",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "cx",
#				"shortdesc": "C.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "P2.y",
#				"default": -0.1,
#				"label": "CY",
#				"longdesc": "Position on Y axis of the third control point",
#				"max": 0.5,
#				"min": -0.5,
#				"name": "cy",
#				"shortdesc": "C.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Width",
#				"longdesc": "Width of the curve pattern",
#				"max": 0.5,
#				"min": 0,
#				"name": "width",
#				"shortdesc": "Width",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Repeat",
#				"longdesc": "Number of repetitions of the input pattern",
#				"max": 16,
#				"min": 1,
#				"name": "repeat",
#				"shortdesc": "Repeat",
#				"step": 1,
#				"type": "float"
#			}
#		]

#----------------------
#sdannularshape.mmg
#Creates an annular shape from a shape described as a signed distance function

#Output

#Output float (color) - Shows the shape as a greyscale image
#sdRipples($in($uv), $r, int($ripples))

#Input:
#Input (sdf - shape), default: 0 - sdf2d - universal input
#width, float, min 0, max 1, step 0.01, default 0
#rippples, int, min 1, max 16, default 1

#----------------------
#sd_mask_to_sdf.mmg

#{
#	"connections": [
#		{
#			"from": "6520",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "edge_detect",
#			"from_port": 0,
#			"to": "1823",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer_2",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "6520",
#			"to_port": 1
#		},
#		{
#			"from": "buffer_2",
#			"from_port": 0,
#			"to": "tones_step",
#			"to_port": 0
#		},
#		{
#			"from": "tones_step",
#			"from_port": 0,
#			"to": "edge_detect",
#			"to_port": 0
#		},
#		{
#			"from": "1823",
#			"from_port": 0,
#			"to": "iterate_buffer",
#			"to_port": 0
#		},
#		{
#			"from": "2434_8",
#			"from_port": 0,
#			"to": "iterate_buffer",
#			"to_port": 1
#		},
#		{
#			"from": "iterate_buffer",
#			"from_port": 0,
#			"to": "6520",
#			"to_port": 0
#		},
#		{
#			"from": "24282_2",
#			"from_port": 0,
#			"to": "2434_8",
#			"to_port": 0
#		},
#		{
#			"from": "iterate_buffer",
#			"from_port": 1,
#			"to": "24282_2",
#			"to_port": 0
#		}
#	],
#	"label": "Mask to SDF",
#	"longdesc": "",
#	"name": "sd_mask_to_sdf",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "iterate_buffer",
#			"node_position": {
#				"x": 76.700005,
#				"y": -249.817047
#			},
#			"parameters": {
#				"filter": false,
#				"iterations": 30,
#				"mipmap": false,
#				"size": 10
#			},
#			"seed_value": 29168,
#			"type": "iterate_buffer"
#		},
#		{
#			"name": "2434_8",
#			"node_position": {
#				"x": 91.099991,
#				"y": -9.031479
#			},
#			"parameters": {
#				"distance": 0,
#				"size": 10
#			},
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec3(-1.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgb"
#					}
#				],
#				"instance": "vec3 $(name)_jump_flood(vec2 uv, float size) {\n\tivec2 int_uv = ivec2(uv * size);\n\tfloat best_distance = 9999.9;\n\tvec2 best_coord;\n\tfloat iter = $in(uv).b;\n\titer += 0.01;\n\tfloat step_width = size / 4.0 / (iter * 100.0);\n\t\n\tfor (int x = -1; x <= 1; x++) {\n\t\tfor (int y = -1; y <= 1; y++) {\n\t\t\tivec2 offsetUV = int_uv + ivec2(x, y) * int(step_width);\n\t\t\tvec2 float_uv = vec2(offsetUV) / size;\n\t\t\tvec2 offset_pos = $in(float_uv).rg;\n\t\t\t\n\t\t\tif (offset_pos.x != 0.0 && offset_pos.y != 0.0) {\n\t\t\t\tvec2 diff = offset_pos - uv;\n\t\t\t\t//float dist = dot(diff, diff);\n\t\t\t\t$distance\n\t\t\t\tif (dist < best_distance) {\n\t\t\t\t\tbest_distance = dist;\n\t\t\t\t\tbest_coord = offset_pos;\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n\t\n\treturn vec3(best_coord, iter);\n}",
#				"name": "Jump Flood",
#				"outputs": [
#					{
#						"rgb": "$(name)_jump_flood($uv, $size)",
#						"type": "rgb"
#					}
#				],
#				"parameters": [
#					{
#						"default": 10,
#						"first": 0,
#						"label": "",
#						"last": 13,
#						"name": "size",
#						"type": "size"
#					},
#					{
#						"default": 0,
#						"label": "",
#						"name": "distance",
#						"type": "enum",
#						"values": [
#							{
#								"name": "Euclidean",
#								"value": "float dist = dot(diff, diff);"
#							},
#							{
#								"name": "Manhattan",
#								"value": "float dist = abs(diff.x) + abs(diff.y);"
#							},
#							{
#								"name": "Chebyshev",
#								"value": "float dist = abs(diff.x) > abs(diff.y) ? abs(diff.x) : abs(diff.y);"
#							}
#						]
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "1823",
#			"node_position": {
#				"x": -269.899872,
#				"y": -18.741766
#			},
#			"parameters": {
#
#			},
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "1.0",
#						"label": "",
#						"name": "in",
#						"type": "f"
#					}
#				],
#				"instance": "",
#				"name": "Mask to UV Mask",
#				"outputs": [
#					{
#						"rgb": "$in($uv) < .5 ? vec3(0.0) : vec3($uv, 0.0)",
#						"type": "rgb"
#					}
#				],
#				"parameters": [
#
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "edge_detect",
#			"node_position": {
#				"x": -286.951447,
#				"y": -137.078964
#			},
#			"parameters": {
#				"size": 10,
#				"threshold": 0.4,
#				"width": 1
#			},
#			"type": "edge_detect"
#		},
#		{
#			"name": "6520",
#			"node_position": {
#				"x": 364.156525,
#				"y": -261.873169
#			},
#			"parameters": {
#				"distance": 0,
#				"tiled": false
#			},
#			"shader_model": {
#				"code": "",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec3(0.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgb"
#					},
#					{
#						"default": "0.0",
#						"function": true,
#						"label": "",
#						"name": "mask",
#						"type": "f"
#					}
#				],
#				"instance": "float $(name)_distance(vec2 uv, bool tiled) {\n\tif (tiled) {\n\t\tuv = fract(uv);\n\t}\n\tvec2 custom_uv = $in(uv).xy;\n\tvec2 diff = custom_uv != vec2(0.0) ? custom_uv - uv : vec2(1.0);\n\t$distance\n\tif (!tiled) {\n\t\tuv = clamp(uv, 0.0, 1.0);\n\t}\n\treturn $mask(uv) < 0.5 ? distance : -distance;\n}",
#				"name": "Calculate Distance",
#				"outputs": [
#					{
#						"sdf2d": "$(name)_distance($uv, $tiled)",
#						"type": "sdf2d"
#					}
#				],
#				"parameters": [
#					{
#						"default": false,
#						"label": "Tiled",
#						"name": "tiled",
#						"type": "boolean"
#					},
#					{
#						"default": 0,
#						"label": "",
#						"name": "distance",
#						"type": "enum",
#						"values": [
#							{
#								"name": "Euclidean",
#								"value": "float distance = length(diff);"
#							},
#							{
#								"name": "Manhattan",
#								"value": "float distance = abs(diff.x) + abs(diff.y);"
#							},
#							{
#								"name": "Chebyshev",
#								"value": "float distance = abs(diff.x) > abs(diff.y) ? abs(diff.x) : abs(diff.y);"
#							}
#						]
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -735.85144,
#				"y": -352.006775
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The greyscale mask to be converted",
#					"name": "mask",
#					"shortdesc": "Mask",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": 646.256348,
#				"y": -263.285461
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"longdesc": "The genrated distance field",
#					"name": "sdf",
#					"shortdesc": "Output",
#					"type": "sdf2d"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -47.67952,
#				"y": -541.979187
#			},
#			"parameters": {
#				"param0": 10,
#				"param1": 30,
#				"param2": false,
#				"param3": 0
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Size",
#					"linked_widgets": [
#						{
#							"node": "iterate_buffer",
#							"widget": "size"
#						},
#						{
#							"node": "2434_8",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_2",
#							"widget": "size"
#						},
#						{
#							"node": "edge_detect",
#							"widget": "size"
#						}
#					],
#					"longdesc": "The resolution used for the operation",
#					"name": "param0",
#					"shortdesc": "Size",
#					"type": "linked_control"
#				},
#				{
#					"label": "Iterations",
#					"linked_widgets": [
#						{
#							"node": "iterate_buffer",
#							"widget": "iterations"
#						}
#					],
#					"longdesc": "The number of iterations the jump flood algorithm performs to calculate the distances",
#					"name": "param1",
#					"shortdesc": "Iterations",
#					"type": "linked_control"
#				},
#				{
#					"label": "Tiled",
#					"linked_widgets": [
#						{
#							"node": "24282_2",
#							"widget": "tiled"
#						},
#						{
#							"node": "6520",
#							"widget": "tiled"
#						}
#					],
#					"longdesc": "Controls whether the resulting ditance field will be tiled. Useful for patterns that extend over the texture bounds",
#					"name": "param2",
#					"shortdesc": "Tiled",
#					"type": "linked_control"
#				},
#				{
#					"label": "Distance",
#					"linked_widgets": [
#						{
#							"node": "2434_8",
#							"widget": "distance"
#						},
#						{
#							"node": "6520",
#							"widget": "distance"
#						}
#					],
#					"name": "param3",
#					"shortdesc": "Distance function",
#					"type": "linked_control"
#				}
#			]
#		},
#		{
#			"name": "buffer_2",
#			"node_position": {
#				"x": -297.702789,
#				"y": -348.41391
#			},
#			"parameters": {
#				"size": 10
#			},
#			"type": "buffer",
#			"version": 1
#		},
#		{
#			"name": "tones_step",
#			"node_position": {
#				"x": -294.947968,
#				"y": -258.84549
#			},
#			"parameters": {
#				"invert": false,
#				"value": 0.5,
#				"width": 0
#			},
#			"type": "tones_step"
#		},
#		{
#			"name": "24282_2",
#			"node_position": {
#				"x": 114.391708,
#				"y": -90.765732
#			},
#			"parameters": {
#				"tiled": false
#			},
#			"shader_model": {
#				"code": "vec3 $(name_uv)_in = $in(fract($uv));\nvec3 $(name_uv)_tiled = $(name_uv)_in.xy != vec2(0.0) ? $(name_uv)_in + vec3(floor($uv), 0.0) : $(name_uv)_in;",
#				"global": "",
#				"inputs": [
#					{
#						"default": "vec3(1.0)",
#						"function": true,
#						"label": "",
#						"name": "in",
#						"type": "rgb"
#					}
#				],
#				"instance": "",
#				"name": "Tiling",
#				"outputs": [
#					{
#						"rgb": "$tiled ? $(name_uv)_tiled : $(name_uv)_in",
#						"type": "rgb"
#					}
#				],
#				"parameters": [
#					{
#						"default": false,
#						"label": "Tiled",
#						"name": "tiled",
#						"type": "boolean"
#					}
#				]
#			},
#			"type": "shader"
#		},
#		{
#			"connections": [
#				{
#					"from": "edge_detect",
#					"from_port": 0,
#					"to": "1823",
#					"to_port": 0
#				},
#				{
#					"from": "tones_step",
#					"from_port": 0,
#					"to": "edge_detect",
#					"to_port": 0
#				},
#				{
#					"from": "1823",
#					"from_port": 0,
#					"to": "iterate_buffer",
#					"to_port": 0
#				},
#				{
#					"from": "2434_8",
#					"from_port": 0,
#					"to": "iterate_buffer",
#					"to_port": 1
#				},
#				{
#					"from": "iterate_buffer",
#					"from_port": 0,
#					"to": "6520",
#					"to_port": 0
#				},
#				{
#					"from": "24282_2",
#					"from_port": 0,
#					"to": "2434_8",
#					"to_port": 0
#				},
#				{
#					"from": "iterate_buffer",
#					"from_port": 1,
#					"to": "24282_2",
#					"to_port": 0
#				},
#				{
#					"from": "iterate_buffer",
#					"from_port": 0,
#					"to": "2153",
#					"to_port": 1
#				},
#				{
#					"from": "buffer_2",
#					"from_port": 0,
#					"to": "tones_step",
#					"to_port": 0
#				},
#				{
#					"from": "gen_inputs",
#					"from_port": 1,
#					"to": "2153",
#					"to_port": 0
#				},
#				{
#					"from": "2153",
#					"from_port": 0,
#					"to": "11582",
#					"to_port": 1
#				},
#				{
#					"from": "gen_inputs",
#					"from_port": 1,
#					"to": "11582",
#					"to_port": 2
#				},
#				{
#					"from": "11582",
#					"from_port": 0,
#					"to": "gen_outputs",
#					"to_port": 0
#				},
#				{
#					"from": "8064",
#					"from_port": 0,
#					"to": "2153",
#					"to_port": 2
#				},
#				{
#					"from": "gen_inputs",
#					"from_port": 0,
#					"to": "8064",
#					"to_port": 0
#				},
#				{
#					"from": "8064",
#					"from_port": 0,
#					"to": "buffer_2",
#					"to_port": 0
#				},
#				{
#					"from": "buffer_2",
#					"from_port": 0,
#					"to": "6520",
#					"to_port": 1
#				},
#				{
#					"from": "6520",
#					"from_port": 0,
#					"to": "11582",
#					"to_port": 0
#				}
#			],
#			"label": "Dilate 2",
#			"longdesc": "",
#			"name": "graph_3",
#			"node_position": {
#				"x": 515.555786,
#				"y": -545.049744
#			},
#			"nodes": [
#				{
#					"name": "iterate_buffer",
#					"node_position": {
#						"x": 64.900002,
#						"y": -259.215881
#					},
#					"parameters": {
#						"filter": false,
#						"iterations": 30,
#						"mipmap": false,
#						"size": 9
#					},
#					"seed_value": 29168,
#					"type": "iterate_buffer"
#				},
#				{
#					"name": "2434_8",
#					"node_position": {
#						"x": 102.099998,
#						"y": 15.367363
#					},
#					"parameters": {
#						"distance": 0,
#						"size": 9
#					},
#					"shader_model": {
#						"code": "",
#						"global": "",
#						"inputs": [
#							{
#								"default": "vec3(-1.0)",
#								"function": true,
#								"label": "",
#								"name": "in",
#								"type": "rgb"
#							}
#						],
#						"instance": "vec3 $(name)_jump_flood(vec2 uv, float size) {\n\tivec2 int_uv = ivec2(uv * size);\n\tfloat best_distance = 9999.9;\n\tvec2 best_coord;\n\tfloat iter = $in(uv).b;\n\titer += 0.01;\n\tfloat step_width = size / 4.0 / (iter * 100.0);\n\t\n\tfor (int x = -1; x <= 1; x++) {\n\t\tfor (int y = -1; y <= 1; y++) {\n\t\t\tivec2 offsetUV = int_uv + ivec2(x, y) * int(step_width);\n\t\t\tvec2 float_uv = vec2(offsetUV) / size;\n\t\t\tvec2 offset_pos = $in(float_uv).rg;\n\t\t\t\n\t\t\tif (offset_pos.x != 0.0 && offset_pos.y != 0.0) {\n\t\t\t\tvec2 diff = offset_pos - uv;\n\t\t\t\t//float dist = dot(diff, diff);\n\t\t\t\t//float dist = abs(diff.x) + abs(diff.y);\n\t\t\t\t//float dist = abs(diff.x) > abs(diff.y) ? abs(diff.x) : abs(diff.y);\n\t\t\t\t$distance\n\t\t\t\tif (dist < best_distance) {\n\t\t\t\t\tbest_distance = dist;\n\t\t\t\t\tbest_coord = offset_pos;\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n\t\n\treturn vec3(best_coord, iter);\n}",
#						"name": "Jump Flood",
#						"outputs": [
#							{
#								"rgb": "$(name)_jump_flood($uv, $size)",
#								"type": "rgb"
#							}
#						],
#						"parameters": [
#							{
#								"default": 10,
#								"first": 0,
#								"label": "",
#								"last": 13,
#								"name": "size",
#								"type": "size"
#							},
#							{
#								"default": 2,
#								"label": "",
#								"name": "distance",
#								"type": "enum",
#								"values": [
#									{
#										"name": "Euclidean",
#										"value": "float dist = dot(diff, diff);"
#									},
#									{
#										"name": "Manhattan",
#										"value": "float dist = abs(diff.x) + abs(diff.y);"
#									},
#									{
#										"name": "Chebyshev",
#										"value": "float dist = abs(diff.x) > abs(diff.y) ? abs(diff.x) : abs(diff.y);"
#									}
#								]
#							}
#						]
#					},
#					"type": "shader"
#				},
#				{
#					"name": "1823",
#					"node_position": {
#						"x": -269.899872,
#						"y": -17.741766
#					},
#					"parameters": {
#
#					},
#					"shader_model": {
#						"code": "",
#						"global": "",
#						"inputs": [
#							{
#								"default": "1.0",
#								"label": "",
#								"name": "in",
#								"type": "f"
#							}
#						],
#						"instance": "",
#						"name": "Mask to UV Mask",
#						"outputs": [
#							{
#								"rgb": "$in($uv) < .5 ? vec3(0.0) : vec3($uv, 0.0)",
#								"type": "rgb"
#							}
#						],
#						"parameters": [
#
#						]
#					},
#					"type": "shader"
#				},
#				{
#					"name": "edge_detect",
#					"node_position": {
#						"x": -286.951447,
#						"y": -137.078964
#					},
#					"parameters": {
#						"size": 9,
#						"threshold": 0.4,
#						"width": 1
#					},
#					"type": "edge_detect"
#				},
#				{
#					"name": "6520",
#					"node_position": {
#						"x": 347.356567,
#						"y": -346.449127
#					},
#					"parameters": {
#						"distance": 0,
#						"length": 0.1
#					},
#					"shader_model": {
#						"code": "",
#						"global": "",
#						"inputs": [
#							{
#								"default": "vec3(0.0)",
#								"function": true,
#								"label": "",
#								"name": "in",
#								"type": "rgb"
#							},
#							{
#								"default": "0.0",
#								"function": true,
#								"label": "",
#								"name": "mask",
#								"type": "f"
#							}
#						],
#						"instance": "float $(name)_distance(vec2 uv, float length) {\n\tvec2 custom_uv = $in(fract(uv)).xy;\n\tvec2 diff = custom_uv != vec2(0.0) ? custom_uv - fract(uv) : vec2(1.0);\n\t//float distance = length(diff);\n\t//float distance = abs(diff.x) + abs(diff.y);\n\t//float distance = abs(diff.x) > abs(diff.y) ? abs(diff.x) : abs(diff.y);\n\t$distance\n\tif (length >= 0.0) {\n\t\treturn $mask(uv) < 0.5 ? clamp(1.0 - (distance / length), 0.0, 1.0) : 1.0;\n\t} else {\n\t\treturn $mask(uv) > 0.5 ? clamp((distance / -length), 0.0, 1.0) : 0.0;\n\t}\n}",
#						"name": "Calculate Distance",
#						"outputs": [
#							{
#								"f": "$(name)_distance($uv, $length)",
#								"type": "f"
#							}
#						],
#						"parameters": [
#							{
#								"control": "None",
#								"default": 0.1,
#								"label": "Length",
#								"max": 1,
#								"min": -1,
#								"name": "length",
#								"step": 0.01,
#								"type": "float"
#							},
#							{
#								"default": 2,
#								"label": "",
#								"name": "distance",
#								"type": "enum",
#								"values": [
#									{
#										"name": "Euclidean",
#										"value": "float distance = length(diff);"
#									},
#									{
#										"name": "Manhattan",
#										"value": "float distance = abs(diff.x) + abs(diff.y);"
#									},
#									{
#										"name": "Chebyshev",
#										"value": "float distance = abs(diff.x) > abs(diff.y) ? abs(diff.x) : abs(diff.y);"
#									}
#								]
#							}
#						]
#					},
#					"type": "shader"
#				},
#				{
#					"name": "gen_inputs",
#					"node_position": {
#						"x": -793.451477,
#						"y": -236.812195
#					},
#					"parameters": {
#
#					},
#					"ports": [
#						{
#							"group_size": 0,
#							"longdesc": "The greyscale mask to be converted",
#							"name": "mask",
#							"shortdesc": "Mask",
#							"type": "f"
#						},
#						{
#							"group_size": 0,
#							"longdesc": "",
#							"name": "source",
#							"shortdesc": "Source",
#							"type": "rgb"
#						}
#					],
#					"type": "ios"
#				},
#				{
#					"name": "gen_outputs",
#					"node_position": {
#						"x": 885.056335,
#						"y": -247.896317
#					},
#					"parameters": {
#
#					},
#					"ports": [
#						{
#							"group_size": 0,
#							"longdesc": "Shows the dilated image",
#							"name": "out",
#							"shortdesc": "Output",
#							"type": "rgb"
#						}
#					],
#					"type": "ios"
#				},
#				{
#					"name": "gen_parameters",
#					"node_position": {
#						"x": 61.520477,
#						"y": -639.339172
#					},
#					"parameters": {
#						"param0": 9,
#						"param1": 0.1,
#						"param2": 0,
#						"param3": 0,
#						"param4": 30
#					},
#					"type": "remote",
#					"widgets": [
#						{
#							"label": "",
#							"linked_widgets": [
#								{
#									"node": "iterate_buffer",
#									"widget": "size"
#								},
#								{
#									"node": "2434_8",
#									"widget": "size"
#								},
#								{
#									"node": "buffer_2",
#									"widget": "size"
#								},
#								{
#									"node": "edge_detect",
#									"widget": "size"
#								}
#							],
#							"longdesc": "The resolution of the input images",
#							"name": "param0",
#							"shortdesc": "Size",
#							"type": "linked_control"
#						},
#						{
#							"label": "",
#							"linked_widgets": [
#								{
#									"node": "6520",
#									"widget": "length"
#								}
#							],
#							"longdesc": "The length of the dilate effect",
#							"name": "param1",
#							"shortdesc": "Length",
#							"type": "linked_control"
#						},
#						{
#							"label": "",
#							"linked_widgets": [
#								{
#									"node": "11582",
#									"widget": "fill"
#								}
#							],
#							"longdesc": "0 to generate a gradient to black while dilating, 1 to fill with input color",
#							"name": "param2",
#							"shortdesc": "Fill",
#							"type": "linked_control"
#						},
#						{
#							"label": "",
#							"linked_widgets": [
#								{
#									"node": "2434_8",
#									"widget": "distance"
#								},
#								{
#									"node": "6520",
#									"widget": "distance"
#								}
#							],
#							"name": "param3",
#							"shortdesc": "Distance Function",
#							"type": "linked_control"
#						},
#						{
#							"label": "",
#							"linked_widgets": [
#								{
#									"node": "iterate_buffer",
#									"widget": "iterations"
#								}
#							],
#							"longdesc": "The number of iterations the jump flood algorithm performs to calculate the distances",
#							"name": "param4",
#							"shortdesc": "Iterations",
#							"type": "linked_control"
#						}
#					]
#				},
#				{
#					"name": "buffer_2",
#					"node_position": {
#						"x": -294.502808,
#						"y": -340.816589
#					},
#					"parameters": {
#						"size": 9
#					},
#					"type": "buffer",
#					"version": 1
#				},
#				{
#					"name": "tones_step",
#					"node_position": {
#						"x": -285.347992,
#						"y": -253.248215
#					},
#					"parameters": {
#						"invert": false,
#						"value": 0.5,
#						"width": 0
#					},
#					"type": "tones_step"
#				},
#				{
#					"name": "24282_2",
#					"node_position": {
#						"x": 109.591705,
#						"y": -88.567284
#					},
#					"parameters": {
#						"tiled": true
#					},
#					"shader_model": {
#						"code": "vec3 $(name_uv)_in = $in(fract($uv));\nvec3 $(name_uv)_tiled = $(name_uv)_in.xy != vec2(0.0) ? $(name_uv)_in + vec3(floor($uv), 0.0) : $(name_uv)_in;",
#						"global": "",
#						"inputs": [
#							{
#								"default": "vec3(1.0)",
#								"function": true,
#								"label": "",
#								"name": "in",
#								"type": "rgb"
#							}
#						],
#						"instance": "",
#						"name": "Tiling",
#						"outputs": [
#							{
#								"rgb": "$tiled ? $(name_uv)_tiled : $(name_uv)_in",
#								"type": "rgb"
#							}
#						],
#						"parameters": [
#							{
#								"default": false,
#								"label": "Tiled",
#								"name": "tiled",
#								"type": "boolean"
#							}
#						]
#					},
#					"type": "shader"
#				},
#				{
#					"name": "2153",
#					"node_position": {
#						"x": 368.85202,
#						"y": -157.100906
#					},
#					"parameters": {
#
#					},
#					"shader_model": {
#						"code": "",
#						"global": "",
#						"inputs": [
#							{
#								"default": "vec3(1.0)",
#								"label": "Source",
#								"name": "source",
#								"type": "rgb"
#							},
#							{
#								"default": "$uv",
#								"label": "Custom UV",
#								"name": "custom_uv",
#								"type": "rgb"
#							},
#							{
#								"default": "0.0",
#								"label": "Mask",
#								"name": "mask",
#								"type": "f"
#							}
#						],
#						"instance": "",
#						"name": "Dilate UV",
#						"outputs": [
#							{
#								"rgb": "$mask($uv) < 0.5 ? $source($custom_uv($uv).xy) : $source($uv)",
#								"type": "rgb"
#							}
#						],
#						"parameters": [
#
#						]
#					},
#					"type": "shader"
#				},
#				{
#					"name": "11582",
#					"node_position": {
#						"x": 609.343445,
#						"y": -239.746399
#					},
#					"parameters": {
#						"fill": 0
#					},
#					"shader_model": {
#						"code": "float $(name_uv)_dist = $distance($uv);\nvec3 $(name_uv)_color = mix($source(fract($uv)), $fill_raw(fract($uv)), float( $(name_uv)_dist != 0.0 ) );\nvec3 $(name_uv)_mix = mix($(name_uv)_color * $(name_uv)_dist, $(name_uv)_color, $fill);",
#						"global": "",
#						"inputs": [
#							{
#								"default": "0.0",
#								"function": true,
#								"label": "Distance",
#								"name": "distance",
#								"type": "f"
#							},
#							{
#								"default": "vec3(1.0)",
#								"function": true,
#								"label": "Fill Raw",
#								"name": "fill_raw",
#								"type": "rgb"
#							},
#							{
#								"default": "vec3(1.0)",
#								"function": true,
#								"label": "Source",
#								"name": "source",
#								"type": "rgb"
#							}
#						],
#						"instance": "",
#						"name": "Dilate Combine",
#						"outputs": [
#							{
#								"rgb": "$(name_uv)_mix",
#								"type": "rgb"
#							}
#						],
#						"parameters": [
#							{
#								"control": "None",
#								"default": 0,
#								"label": "Fill",
#								"max": 1,
#								"min": 0,
#								"name": "fill",
#								"step": 0.01,
#								"type": "float"
#							}
#						]
#					},
#					"type": "shader"
#				},
#				{
#					"name": "8064",
#					"node_position": {
#						"x": -282.533325,
#						"y": -433.011169
#					},
#					"parameters": {
#
#					},
#					"shader_model": {
#						"code": "",
#						"global": "",
#						"inputs": [
#							{
#								"default": "vec3(0.0)",
#								"label": "",
#								"name": "in",
#								"type": "rgb"
#							}
#						],
#						"instance": "",
#						"name": "Default Value",
#						"outputs": [
#							{
#								"rgb": "$in($uv)",
#								"type": "rgb"
#							}
#						],
#						"parameters": [
#
#						]
#					},
#					"type": "shader"
#				}
#			],
#			"parameters": {
#				"param0": 9,
#				"param1": 0.1,
#				"param2": 0,
#				"param3": 0,
#				"param4": 30
#			},
#			"shortdesc": "",
#			"type": "graph"
#		}
#	],
#	"parameters": {
#		"param0": 10,
#		"param1": 30,
#		"param2": false,
#		"param3": 0
#	},
#	"shortdesc": "",
#	"type": "graph"
#}

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
	
	var d : Vector2 = absv2(uv - c) - wh
	
	return maxv2(d, Vector2(0, 0)).length() + min(max(d.x, d.y), 0.0)

#vec2 $(name_uv)_sdl = sdLine($uv, vec2($ax+0.5, $ay+0.5), vec2($bx+0.5, $by+0.5));

static func sdf_line(uv : Vector2, a : Vector2, b : Vector2, r : float) -> Vector2:
	a.x += 0.5
	a.y += 0.5
	
	b.x += 0.5
	b.y += 0.5
	
	return sdLine(uv, a, b)


static func sdf_rhombus(uv : Vector2, c : Vector2, wh : Vector2) -> float:
	c.x += 0.5
	c.y += 0.5
	
	return sdRhombus(uv - c, wh);


static func sdf_arc(uv : Vector2, a : Vector2, r : Vector2) -> float:
	return sdArc(uv - Vector2(0.5, 0.5), modf(a.x, 360.0) * 0.01745329251, modf(a.y, 360.0)*0.01745329251, r.x, r.y)

#float sdr_ndot(vec2 a, vec2 b) { 
#	return a.x*b.x - a.y*b.y; 
#}

static func sdr_ndot(a : Vector2, b : Vector2) -> float:
	return a.x * b.x - a.y * b.y;

#float sdRhombus(in vec2 p, in vec2 b) {
#	vec2 q = abs(p);
#	float h = clamp((-2.0*sdr_ndot(q,b)+sdr_ndot(b,b))/dot(b,b),-1.0,1.0);
#	float d = length( q - 0.5*b*vec2(1.0-h,1.0+h) );
#	return d * sign( q.x*b.y + q.y*b.x - b.x*b.y );
#}

static func sdRhombus(p : Vector2, b : Vector2) -> float:
	var q : Vector2 = absv2(p);
	var h : float = clamp((-2.0 * sdr_ndot(q,b) + sdr_ndot(b,b)) / b.dot(b), -1.0, 1.0);
	var d : float = ( q - 0.5*b * Vector2(1.0-h, 1.0+h)).length()
	return d * sign(q.x*b.y + q.y*b.x - b.x*b.y)

#float sdArc(vec2 p, float a1, float a2, float ra, float rb) {
#	float amid = 0.5*(a1+a2)+1.6+3.14*step(a1, a2);
#	float alength = 0.5*(a1-a2)-1.6+3.14*step(a1, a2);
#
#	vec2 sca = vec2(cos(amid), sin(amid));
#	vec2 scb = vec2(cos(alength), sin(alength));    
#	p *= mat2(vec2(sca.x,sca.y),vec2(-sca.y,sca.x));    
#	p.x = abs(p.x);    
#
#	float k = (scb.y*p.x>scb.x*p.y) ? dot(p.xy,scb) : length(p.xy);    
#	return sqrt( dot(p,p) + ra*ra - 2.0*ra*k ) - rb;
#}

static func sdArc(p : Vector2, a1 : float, a2 : float, ra : float, rb : float) -> float:
	var amid : float = 0.5*(a1+a2)+1.6+3.14 * step(a1, a2);
	var alength : float = 0.5*(a1-a2)-1.6+3.14 * step(a1, a2);
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

#vec2 sdLine(vec2 p, vec2 a, vec2 b) {    
#	vec2 pa = p-a, ba = b-a;    
#	float h = clamp(dot(pa,ba)/dot(ba,ba), 0.0, 1.0);    
#	return vec2(length(pa-ba*h), h);
#}

static func sdLine(p : Vector2, a  : Vector2, b : Vector2) -> Vector2:
	var pa : Vector2 = p - a
	var ba : Vector2 = b - a
	
	var h : float = clamp(pa.dot(ba) / ba.dot(ba), 0.0, 1.0);
	
	return Vector2((pa - (ba * h)).length(), h)


#Needs thought
#func sdf_translate(a : float, x : float, y : float) -> float:
#	return lerp(a, b, amount)

#vec2 sdf2d_rotate(vec2 uv, float a) {
#	vec2 rv;
#	float c = cos(a);
#	float s = sin(a);
#	uv -= vec2(0.5);
#	rv.x = uv.x*c+uv.y*s;
#	rv.y = -uv.x*s+uv.y*c;
#	return rv+vec2(0.5);
#}

static func sdf2d_rotate(uv : Vector2, a : float) -> Vector2:
	var rv : Vector2;
	var c : float = cos(a);
	var s : float = sin(a);
	uv -= Vector2(0.5, 0.5);
	rv.x = uv.x*c+uv.y*s;
	rv.y = -uv.x*s+uv.y*c;
	return rv+Vector2(0.5, 0.5);

#float cross2( in vec2 a, in vec2 b ) { 
#	return a.x*b.y - a.y*b.x; 
#}

#// signed distance to a quadratic bezier\n
#vec2 sdBezier( in vec2 pos, in vec2 A, in vec2 B, in vec2 C ) {    \n    
#	vec2 a = B - A;\n    
#	vec2 b = A - 2.0*B + C;\n    
#	vec2 c = a * 2.0;\n    
#	vec2 d = A - pos;\n\n    
#	float kk = 1.0/dot(b,b);\n    
#	float kx = kk * dot(a,b);\n    
#	float ky = kk * (2.0*dot(a,a)+dot(d,b))/3.0;\n    
#	float kz = kk * dot(d,a);      \n\n    
#	float res = 0.0;\n    
#	float sgn = 0.0;\n\n    
#	float p = ky - kx*kx;\n    
#	float p3 = p*p*p;\n    
#	float q = kx*(2.0*kx*kx - 3.0*ky) + kz;\n    
#	float h = q*q + 4.0*p3;\n\t
#	float rvx;\n\n    
#
#	if( h>=0.0 ) { 
#		// 1 root\n        
#		h = sqrt(h);\n        
#		vec2 x = (vec2(h,-h)-q)/2.0;\n       
#		vec2 uv = sign(x)*pow(abs(x), vec2(1.0/3.0));
#		rvx = uv.x+uv.y-kx;\n        
#		float t = clamp(rvx, 0.0, 1.0);\n        
#		vec2 q2 = d+(c+b*t)*t;\n        
#		res = dot(q2, q2);\n    \t
#		sgn = cross2(c+2.0*b*t, q2);\n    
#	} else {   
#		// 3 roots\n        
#		float z = sqrt(-p);\n        
#		float v = acos(q/(p*z*2.0))/3.0;\n        
#		float m = cos(v);\n        
#		float n = sin(v)*1.732050808;\n        
#		vec3  t = clamp(vec3(m+m,-n-m,n-m)*z-kx, 0.0, 1.0);\n        
#		vec2  qx=d+(c+b*t.x)*t.x; 
#		float dx=dot(qx, qx), sx = cross2(c+2.0*b*t.x,qx);\n        
#		vec2  qy=d+(c+b*t.y)*t.y; 
#		float dy=dot(qy, qy), sy = cross2(c+2.0*b*t.y,qy);\n        
#
#		if( dx<dy ) { 
#			res=dx; sgn=sx; rvx = t.x; 
#		} else { 
#			res=dy; sgn=sy; rvx = t.y; 
#		}\n    
#	}\n    \n    
#
#	return vec2(rvx, sqrt(res)*sign(sgn));\n
#}

# signed distance to a quadratic bezier
static func sdBezier(pos : Vector2, A : Vector2, B : Vector2, C : Vector2) -> Vector2:   
	var a : Vector2 = B - A;
	var b : Vector2 = A - 2.0 * B + C;
	var c : Vector2 = a * 2.0;
	var d : Vector2 = A - pos;

	var kk : float = 1.0 / b.dot(b);
	var kx : float = kk * a.dot(b);
	var ky : float = kk * (2.0* a.dot(a) + d.dot(b)) / 3.0;
	var kz : float = kk * d.dot(a);      

	var res : float = 0.0;
	var sgn : float = 0.0;

	var p : float = ky - kx * kx;
	var p3 : float = p * p * p;
	var q : float = kx * (2.0 * kx * kx - 3.0 * ky) + kz;
	var h : float = q * q + 4.0 * p3;
	var rvx : float = 0
	
	if(h >= 0.0):
		# // 1 root
		h = sqrt(h);
		
		var x : Vector2 = (Vector2(h,-h) - Vector2(q, q)) / 2.0

		var uv : Vector2 = signv2(x) * powv2(absv2(x), Vector2(1.0/3.0, 1.0/3.0));
		
		rvx = uv.x + uv.y - kx;
		var t : float = clamp(rvx, 0.0, 1.0);
		var q2 : Vector2 = d + (c + b * t) * t;
		res = q2.dot(q2);
		
		sgn = (c + Vector2(2, 2) * b * t).cross(q2)

	else: #  // 3 roots
		var z : float = sqrt(-p);
		var v : float = acos(q / (p * z * 2.0)) / 3.0;
		var m : float = cos(v);
		var n : float = sin(v) * 1.732050808;
		
		var t : Vector3 = clampv3(Vector3(m+m, -n-m, n-m) * z - Vector3(kx, kx, kx), Vector3(), Vector3(1, 1, 1));

		var qx : Vector2 = d + (c + b * t.x) * t.x; 
		var dx : float = qx.dot(qx)
		var sx  : float = (c + Vector2(2, 2) * b * t.x).cross(qx)
		var qy : Vector2 = d + (c + b * t.y) * t.y
		var dy : float = qy.dot(qy)
		var sy : float = (c + Vector2(2, 2) * b * t.y).cross(qy)
		
		if dx<dy:
			res=dx
			sgn=sx
			rvx = t.x
		else:
			res=dy
			sgn=sy
			rvx = t.y

	return Vector2(rvx, sqrt(res) * sign(sgn))

#vec2 circle_repeat_transform_2d(vec2 p, float count) {
#	float r = 6.28/count;
#	float pa = atan(p.x, p.y);
#	float a = mod(pa+0.5*r, r)-0.5*r;
#
#	vec2 rv;
#
#	float c = cos(a-pa);
#	float s = sin(a-pa);
#
#	rv.x = p.x*c+p.y*s;
#	rv.y = -p.x*s+p.y*c;
#
#	return rv;
#}

static func circle_repeat_transform_2d(p : Vector2, count : float) -> Vector2:   
	var r : float = 6.28 / count
	var pa : float = atan2(p.x, p.y)
	var a : float = modf(pa + 0.5 * r, r)-0.5*r

	var rv : Vector2 = Vector2()

	var c : float = cos(a - pa);
	var s : float = sin(a - pa);

	rv.x = p.x * c + p.y * s
	rv.y = -p.x * s + p.y * c

	return rv;

#float sdNgon(vec2 p, float r, float n) {
#	float PI = 3.1415926535;
#	p = circle_repeat_transform_2d(p, n);
#	vec2 d = abs(p)-vec2(r*tan(3.14159265359/n), r);
#	return p.y < r ? p.y-r : length(max(d,vec2(0)))+min(max(d.x,d.y),0.0);
#}

static func sdNgon(pos : Vector2, r : float, n : float) -> Vector2:
	return Vector2()


#vec2 repeat_2d(vec2 p, vec2 r, float seed, float randomness) {
#	p -= vec2(0.5);
#	float a = (rand(floor(mod((p.xy+0.5*r.xy)/r.xy, 1.0/r.xy)+vec2(seed)))-0.5)*6.28*randomness;
#	p = mod(p+0.5*r,r)-0.5*r;
#	vec2 rv;
#	float c = cos(a);
#	float s = sin(a);
#	rv.x = p.x*c+p.y*s;
#	rv.y = -p.x*s+p.y*c;
#	return rv+vec2(0.5);
#}

static func repeat_2d(p : Vector2, r : Vector2, pseed : float, randomness : float) -> Vector2:
	p -= Vector2(0.5, 0.5);
	var v : Vector2 = Vector2(p.x, p.y) + Vector2(0.5, 0.5) + Vector2(r.x, r.y)
	var a : float = ((rand2(floorv2(modv2(v / Vector2(r.x, r.y), Vector2(1.0, 1.0) / Vector2(r.x, r.y)) + Vector2(pseed, pseed))) - Vector2(0.5, 0.5)) * 6.28 * randomness).x
	p = modv2(p + Vector2(0.5, 0.5) * r,r)- Vector2(0.5, 0.5) * r
	var rv : Vector2 = Vector2()
	var c : float = cos(a)
	var s : float = sin(a)
	rv.x = p.x * c + p.y * s
	rv.y = -p.x * s + p.y * c
	return rv + Vector2(0.5, 0.5);
	
#float sdSmoothUnion( float d1, float d2, float k ) {
#	float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
#	return mix( d2, d1, h ) - k*h*(1.0-h); 
#}

static func sdSmoothUnion(d1 : float, d2 : float, k : float) -> float:
	return 0.0

#float sdSmoothSubtraction( float d1, float d2, float k ) {
#	float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
#	return mix( d2, -d1, h ) + k*h*(1.0-h); 
#}

static func sdSmoothSubtraction(d1 : float, d2 : float, k : float) -> float:
	return 0.0

#float sdSmoothIntersection( float d1, float d2, float k ) {
#	float h = clamp( 0.5 - 0.5*(d2-d1)/k, 0.0, 1.0 );
#	return mix( d2, d1, h ) + k*h*(1.0-h); 
#}

static func sdSmoothIntersection(d1 : float, d2 : float, k : float) -> float:
	return 0.0
	
	
#float sdRipples(float d, float w, int r) {\n
#	for (int i = 0; i < r; ++i) {
#		d = abs(d)-w;
#	}
#
#	return d;
#}

static func sdRipples(d : float, w : float, r : int) -> float:
	for i in range(r):
		d = abs(d)-w;

	return d

#$polygon = { p1(vec2), p2(vec2), p3(vec2) ... }
#float sdPolygon_$(name)(vec2 p) {
#	vec2 v[] = $polygon;
#	int l = v.length();
#	float d = dot(p-v[0],p-v[0]);
#	float s = 1.0;
#	int j = l-1;
#
#	for(int i=0; i<l; i++) {        
#		vec2 e = v[j] - v[i];
#		vec2 w = p - v[i];
#		vec2 b = w - e*clamp( dot(w,e)/dot(e,e), 0.0, 1.0 );
#		d = min( d, dot(b,b) );
#		bvec3 c = bvec3(p.y>=v[i].y,p.y<v[j].y,e.x*w.y>e.y*w.x);
#
#		if(all(c) || all(not(c))) {
#			s *= -1.0;
#		}
#
#		j = i;    
#	}
#
#	return s*sqrt(d);
#}

static func sdPolygon(p : Vector2, v : PoolVector2Array) -> float:
	var l : int = v.size()
	var pmv0 : Vector2 = p - v[0]
	var d : float = pmv0.dot(pmv0)
	var s : float = 1.0
	var j : int = l - 1

	for i in range(l): #for(int i=0; i<l; i++)
		var e : Vector2 = v[j] - v[i]
		var w : Vector2 = p - v[i]
		var b : Vector2 = w - e * clamp(w.dot(e) / e.dot(e), 0.0, 1.0)
		d = min(d, b.dot(b))
		
		var b1 : bool = p.y >= v[i].y
		var b2 : bool = p.y < v[j].y
		var b3 : bool = e.x * w.y > e.y * w.x

		if((b1 && b2 && b3) || (!b1 && !b2 && !b3)):
			s *= -1.0

		j = i

	return s * sqrt(d)


# =================== SDF3D.GD ===========================



#----------------------
#sdf3d_box.mmg
#Generates a rounded box as a signed distance function

#Outputs:

#Common
#vec3 $(name_uv)_q = abs($uv) - vec3($sx, $sy, $sz);

#Output - (sdf3d) - Shows the rounded box
#length(max($(name_uv)_q,0.0))+min(max($(name_uv)_q.x,max($(name_uv)_q.y,$(name_uv)_q.z)),0.0)-$r

#Inputs:
#size, vector3, min: 0, max: 1, default:0.5, step:0.01
#size, float, min: 0, max: 1, default:0.5, step:0.01

#----------------------
#sdf3d_sphere.mmg
#Generates a sphere as a signed distance function

#Outputs:

#Output - (sdf3d) - Shows the sphere
#length($uv)-$r

#Inputs:
#radius, vector3, min: 0, max: 1, default:0.5, step:0.01

#----------------------
#sdf3d_capsule.mmg
#Generates a capsule as a signed distance function

#Outputs:

#Common
#vec3 $(name_uv)_p = $uv;
#$(name_uv)_p.$axis -= clamp($(name_uv)_p.$axis, -$l, $l);

#Output - (sdf3d) - Shows the capsule
#length($(name_uv)_p)-$r*$profile(clamp(0.5+0.5*($uv).$axis/$l, 0.0, 1.0))

#Inputs:
#axis, enum, default: 1, values: x, y, z
#length, float, min: 0, max: 1, default:0.25, step:0.01
#radius, float, min: 0, max: 1, default:0.2, step:0.01
#profile, curve, default: (ls, rs, x, z) 0, 0, 0, 1,  0, 0, 1, 1

#----------------------
#sdf3d_cone.mmg

#Outputs:

#+X: $axis = length($uv.yz),-$uv.x
#-X: $axis = length($uv.yz),$uv.x
#+Y: $axis = length($uv.xz),$uv.y
#-Y: $axis = length($uv.xz),-$uv.y
#+Z: $axis = length($uv.xy),-$uv.z
#-Z: $axis = length($uv.xy),$uv.z

#Output - (sdf3d)
#dot(vec2(cos($a*0.01745329251),sin($a*0.01745329251)),vec2($axis))

#Inputs:
#axis, enum, default:5, values: +X, -X, +Y, -Y, +Z, -Z
#angle, float, min: 0, max: 90, default:30, step:1

#----------------------
#sdf3d_repeat.mmg

#Outputs:

#Output (sdf3d)
#Output - (sdf3dc) - The shape generated by the repeat operation
#$in(repeat($uv, vec3(1.0/$rx, 1.0/$ry, 0.0), float($seed), $r))

#Inputs:
#in, vec2, default:vec2(100, 0.0), (sdf3d input)

#X, int, min: 1, max: 32, default:4, step:1
#Y, int, min: 1, max: 32, default:4, step:1
#R, float, min: 0, max: 1, default:0.5, step:0.01

#----------------------
#sdf3d_rotate.mmg

#Outputs:

#Output - (sdf3dc) - The rotated object
#$in(rotate3d($uv, -vec3($ax, $ay, $az)*0.01745329251))

#Inputs:
#in, vec2, default:vec2(100, 0.0), (sdf3d input)
#rotation, vector3, min: -180, max: 180, default:0, step:1

#----------------------
#sdf3d_cylinder.mmg

#Outputs:

#Output - (sdf3dc) - Shows the cylinder
#min(max($(name_uv)_d.x,$(name_uv)_d.y),0.0) + length(max($(name_uv)_d,0.0))

#Inputs:
#axis, enum, default: 1, values: X, Y, Z
#length, float, min: 0, max: 1, default:0.5, step:0.01
#radius, float, min: 0, max: 1, default:0.2, step:0.01

#----------------------
#sdf3d_plane.mmg
#Generates a plane that can be used to cut other shapes

#Outputs:

#X: $axis = x
#Y: $axis = y
#Z: $axis = z

#Output - (sdf3dc) - Shows the plane
#$uv.$axis

#Inputs:
#axis, enum, default: 1, values: X, Y, Z

#----------------------
#sdf3d_torus.mmg
#Generates a torus as a signed distance function

#Outputs:

#X: $axis = length($uv.yz)-$R,$uv.x
#Y: $axis = length($uv.zx)-$R,$uv.y
#Z: $axis = length($uv.xy)-$R,$uv.z
#vec2 $(name_uv)_q = vec2($axis);

#Output - (sdf3dc) - Shows the torus
#length($(name_uv)_q)-$r

#Inputs:
#axis, enum, default: 1, values: X, Y, Z
#R, float, min: 0, max: 1, default:0.5, step:0.01
#r, float, min: 0, max: 1, default:0.1, step:0.01

#----------------------
#sdf3d_boolean.mmg

#Outputs:

#Union: $op = sdf3dc_union
#Subtraction $op = sdf3dc_sub
#Intersection $op = sdf3dc_inter

#Output - (sdf3dc) - The shape generated by the boolean operation
#$op($in1($uv), $in2($uv))

#Inputs:
#axis, enum, default: 2, values: Union, Subtraction, Intersection
#in1, vec2, default:vec2(100, 0.0), (sdf3d input)
#in2, vec2, default:vec2(100, 0.0), (sdf3d input)

#----------------------
#sdf3d_circle_repeat.mmg

#Outputs:

#Output (sdf3dc) - The shape generated by the boolean operation
#$in(circle_repeat_transform($uv, $c))

#Inputs:
#count, float, min: 1, max: 32, default:5, step:1

#----------------------
#sdf3d_angle.mmg (includes sdf3d_rotate.mmg)

#Outputs:

#Shows the angleThe shape generated by the boolean operation
#$(name_uv)_d

#X: $axis = xyz
#Y: $axis = yzx
#Z: $axis = zxy

#vec3 $(name_uv)_uv = $uv.$axis;
#float $(name_uv)_rotated = rotate3d($(name_uv)_uv, vec3(($angle-180.0)*0.01745329251, 0.0, 0.0)).y;
#float $(name_uv)_d1 = max($(name_uv)_uv.y, $(name_uv)_rotated);
#float $(name_uv)_d2 = min($(name_uv)_uv.y, $(name_uv)_rotated);
#float $(name_uv)_d = (mod($angle, 360.0) < 180.0) ? $(name_uv)_d1 : $(name_uv)_d2;

#Inputs:
#axis, enum, default: 0, values: X, Y, Z
#angle, float, min: 0, max: 360, default:180, step:0.1

#----------------------
#sdf3d_color.mmg

#Outputs:

#Output - sdf3dc - The colored 3D object
#vec2($in($uv), $c)

#Inputs:
#color_index, float, min: 0, max: 1, default:0, step:0.01
#in, vec2, default:vec2(100, 0.0), (sdf3d input)

#----------------------
#sdf3d_translate.mmg

#Outputs:

#Output - sdf3dc
#$in($uv-vec3($x, $y, $z))

#Inputs:
#translation, vector3, min: -1, max: 1, default:0, step:0.01
#in, vec2, default:vec2(100, 0.0), (sdf3dc input)

#----------------------
#sdf3d_scale.mmg

#Outputs:

#vec2 $(name_uv)_in = $in(($uv)/$s);

#Output - sdf3dc
#vec2($(name_uv)_in.x*$s, $(name_uv)_in.y)

#Inputs:
#scale_factor, float, min: 0, max: 5, default:1, step:0.01
#in, vec2, default:vec2(100, 0.0), (sdf3dc input)

#----------------------
#sdf3d_rounded.mmg

#Outputs:

#vec2 $(name_uv)_v = $in($uv);

#Output - sdf3dc
#vec2($(name_uv)_v.x-$r, $(name_uv)_v.y)

#Inputs:
#radius, float, min: 0, max: 1, default:0, step:0.01
#in, vec2, default:vec2(100, 0.0), (sdf3dc input)

#----------------------
#sdf3d_revolution.mmg

#Outputs:

#vec2 $(name_uv)_q = vec2(length($uv.xy)-$d+0.5, $uv.z+0.5);

#Output - sdf3dc
#$in($(name_uv)_q)

#Inputs:
#d, float, min: 0, max: 1, default:0.25, step:0.01
#input, float, default:10.0, (sdf2d input)

#----------------------
#sdf3d_smoothboolean.mmg
#Performs a smooth boolean operation (union, intersection or difference) between two shapes

#Outputs:

#Union: $op = union
#Subtraction: $op = subtraction
#Intersection: $op = intersection

#Output - sdf3dc
#sdf3d_smooth_$op($in1($uv), $in2($uv), $k)

#Inputs:
#in1, vec2, default:vec2(100, 0.0), (sdf3d input)
#in2, vec2, default:vec2(100, 0.0), (sdf3d input)
#operation, enum, default: 1, values: Union, Subtraction, Intersection
#smoothness, float, min: 0, max: 1, default:0, step:0.01

#----------------------
#sdf3d_elongation.mmg

#Outputs:

#Output - sdf3dc
#$in($uv-clamp($uv, -abs(vec3($x, $y, $z)), abs(vec3($x, $y, $z))))

#Inputs:
#in, vec2, default:vec2(100, 0.0), (sdf3dc input)
#elongation, vector3, min: 0, max: 1, default:0, step:0.01

#----------------------
#sdf3d_extrusion.mmg

#Outputs:

#vec2 $(name_uv)_w = vec2($in($uv.xz+vec2(0.5)),abs($uv.y)-$d);

#Output - sdf3dc
#min(max($(name_uv)_w.x,$(name_uv)_w.y),0.0)+length(max($(name_uv)_w,0.0))

#Inputs:
#in, sdf2d, default:100, (input)
#length, float, min: 0, max: 1, default:0.25, step:0.01

#----------------------
#sdf3d_morph.mmg

#Outputs:

#Output - sdf3d
#mix($in1($uv), $in2($uv), $amount)

#Inputs:
#in1, vec2, default:vec2(100, 0.0), (sdf3d input)
#in2, vec2, default:vec2(100, 0.0), (sdf3d input)
#amount, float, min: 0, max: 1, default:0.5, step:0.01

#----------------------
#raymarching.mmg (raymarching_preview.mmg)
#Raymarches a 3D object (described as signed distance function with optional color index) 
#to render a heightmap, a normal map and a color index map.

#raymarch_$name = sdf3d_raymarch
#vec2 $(name_uv)_d = raymarch_$name($uv);

#Outputs:

#HeightMap - float - The generated height map
#1.0-$(name_uv)_d.x

#NormalMap - rgb - The generated normal map
#vec3(0.5)+0.5*normal_$name(vec3($uv-vec2(0.5), 1.0-$(name_uv)_d.x))

#ColorMap - float - The generated color index map
#$(name_uv)_d.y

#Inputs:
#input, vec2, default:vec2(100, 0.0), (sdf3dc input)

#----------------------
#raymarching_preview.mmg

#Outputs:

#Output (rgb)
#render_$name($uv-vec2(0.5))

#Inputs:
#input, vec2, default:vec2(100, 0.0), (sdf3dc input)

static func raymarch(uv : Vector2) -> Color:
	var d : Vector2 = sdf3d_raymarch(uv);
	
	var f : float = 1.0 - d.x;
	
	return Color(f, f, f, 1)

static func raymarch2(uv : Vector2) -> Color:
	var d : Vector2 = sdf3d_raymarch(uv);
	
	var v : Vector3 = Vector3(0.5, 0.5, 0.5) + 0.5 * sdf3d_normal(Vector3(uv.x - 0.5, uv.y - 0.5, 1.0 - d.x));
	
	return Color(v.x, v.y, v.z, 1)

static func raymarch3(uv : Vector2) -> Color:
	var v : Vector2 = sdf3d_raymarch(uv);
	
	return Color(v.y, v.y, v.y, 1)

#length($uv)-$r

static func sdf3d_sphere(p : Vector3, r : float) -> Vector2:
	var s : float = p.length() - r;

	return Vector2(s, 0.0);

#vec3 $(name_uv)_q = abs($uv) - vec3($sx, $sy, $sz);
#length(max($(name_uv)_q,0.0))+min(max($(name_uv)_q.x,max($(name_uv)_q.y,$(name_uv)_q.z)),0.0)-$r

static func sdf3d_box(p : Vector3, sx : float, sy : float, sz : float, r : float) -> Vector2:
	var v : Vector3 = absv3((p)) - Vector3(sx, sy, sz);
	var f : float = (maxv3(v,Vector3())).length() + min(max(v.x,max(v.y, v.z)),0.0) - r;

	return Vector2(f, 0.0);

#Y: $axis = length($uv.xz),$uv.y
#vec2 $(name_uv)_d = abs(vec2($axis)) - vec2($r,$l);

static func sdf3d_cylinder_y(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector2 = absv2(Vector2(Vector2(p.x, p.z).length(),(p).y)) - Vector2(r,l);
	var f : float = min(max(v.x, v.y),0.0) + maxv2(v, Vector2()).length();

	return Vector2(f, 0.0);

#X: $axis = length($uv.yz),$uv.x
#vec2 $(name_uv)_d = abs(vec2($axis)) - vec2($r,$l);

static func sdf3d_cylinder_x(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector2 = absv2(Vector2(Vector2(p.y, p.z).length(),(p).x)) - Vector2(r, l);
	var f : float = min(max(v.x, v.y),0.0) + maxv2(v, Vector2()).length();

	return Vector2(f, 0.0);

#Z: $axis = length($uv.xy),$uv.z
#vec2 $(name_uv)_d = abs(vec2($axis)) - vec2($r,$l);

static func sdf3d_cylinder_z(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector2 = absv2(Vector2(Vector2(p.x, p.y).length(),(p).z)) - Vector2(r, l);
	var f : float = min(max(v.x, v.y),0.0) + maxv2(v, Vector2()).length();

	return Vector2(f, 0.0);

#vec3 $(name_uv)_p = $uv;
#$(name_uv)_p.$axis -= clamp($(name_uv)_p.$axis, -$l, $l);
#return length($(name_uv)_p)-$r*$profile(clamp(0.5+0.5*($uv).$axis/$l, 0.0, 1.0))

static func sdf3d_capsule_y(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector3 = p;
	v.y -= clamp(v.y, -l, l);
	var f : float = v.length() - r;

	return Vector2(f, 0.0);

static func sdf3d_capsule_x(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector3 = p;
	v.x -= clamp(v.x, -l, l);
	var f : float = v.length() - r;

	return Vector2(f, 0.0);

static func sdf3d_capsule_z(p : Vector3, r : float, l : float) -> Vector2:
	var v : Vector3 = p;
	v.z -= clamp(v.z, -l, l);
	var f : float = v.length() - r;

	return Vector2(f, 0.0);

#+X: $axis = length($uv.yz),-$uv.x
#dot(vec2(cos($a*0.01745329251),sin($a*0.01745329251)),vec2($axis))

static func sdf3d_cone_px(p : Vector3, a : float) -> Vector2:
	var  f : float = Vector2(cos(a*0.01745329251),sin(a*0.01745329251)).dot(Vector2(Vector2(p.y, p.z).length(), - (p).x));

	return Vector2(f, 0.0);

#-X: $axis = length($uv.yz),$uv.x
#dot(vec2(cos($a*0.01745329251),sin($a*0.01745329251)),vec2($axis))

static func sdf3d_cone_nx(p : Vector3, a : float) -> Vector2:
	var  f : float = Vector2(cos(a*0.01745329251),sin(a*0.01745329251)).dot(Vector2(Vector2(p.y, p.z).length(),(p).x));

	return Vector2(f, 0.0);

#+Y: $axis = length($uv.xz),$uv.y
#dot(vec2(cos($a*0.01745329251),sin($a*0.01745329251)),vec2($axis))

static func sdf3d_cone_py(p : Vector3, a : float) -> Vector2:
	var  f : float = Vector2(cos(a*0.01745329251),sin(a*0.01745329251)).dot(Vector2(Vector2(p.x, p.z).length(),(p).y));

	return Vector2(f, 0.0);

#-Y: $axis = length($uv.xz),-$uv.y
#dot(vec2(cos($a*0.01745329251),sin($a*0.01745329251)),vec2($axis))

static func sdf3d_cone_ny(p : Vector3, a : float) -> Vector2:
	var  f : float = Vector2(cos(a*0.01745329251),sin(a*0.01745329251)).dot(Vector2(Vector2(p.x, p.z).length(),-(p).y));

	return Vector2(f, 0.0);

#+Z: $axis = length($uv.xy),-$uv.z
#dot(vec2(cos($a*0.01745329251),sin($a*0.01745329251)),vec2($axis))

static func sdf3d_cone_pz(p : Vector3, a : float) -> Vector2:
	var  f : float = Vector2(cos(a*0.01745329251),sin(a*0.01745329251)).dot(Vector2(Vector2(p.x, p.y).length(),-(p).z));

	return Vector2(f, 0.0);


#-Z: $axis = length($uv.xy),$uv.z
#dot(vec2(cos($a*0.01745329251),sin($a*0.01745329251)),vec2($axis))

static func sdf3d_cone_nz(p : Vector3, a : float) -> Vector2:
	var f : float = Vector2(cos(a*0.01745329251),sin(a*0.01745329251)).dot(Vector2(Vector2(p.x, p.y).length(),(p).z));

	return Vector2(f, 0.0);

static func sdf3d_torus_x(p : Vector3, R : float, r : float) -> Vector2:
	var q : Vector2 = Vector2(Vector2(p.y, p.z).length() - R,(p).x);
	var f : float = q.length() - r;

	return Vector2(f, 0.0);
	
static func sdf3d_torus_y(p : Vector3, R : float, r : float) -> Vector2:
	var q : Vector2 = Vector2(Vector2(p.z, p.x).length() - R,(p).y);
	var f : float = q.length() - r;

	return Vector2(f, 0.0);

static func sdf3d_torus_z(p : Vector3, R : float, r : float) -> Vector2:
	var q : Vector2 = Vector2(Vector2(p.x, p.y).length() - R,(p).z);
	var f : float = q.length() - r;

	return Vector2(f, 0.0);


#vec2 raymarch_$name(vec2 uv) {
#	vec3 ro = vec3(uv-vec2(0.5), 1.0);
#	vec3 rd = vec3(0.0, 0.0, -1.0);
#	float dO = 0.0;
#	float c = 0.0;    
#
#	for (int i=0; i < 100; i++) {    
#		vec3 p = ro + rd*dO;        
#		vec2 dS = $sdf(p);        
#		dO += dS.x;        
#
#		if (dO >= 1.0) {
#			break;
#		} else if (dS.x < 0.0001) {
#			c = dS.y;
#			break;
#		}    
#	}        
#
#	return vec2(dO, c);
#}

static func sdf3d_raymarch(uv : Vector2) -> Vector2:
	var ro : Vector3 = Vector3(uv.x - 0.5, uv.y - 0.5, 1.0);
	var rd : Vector3 = Vector3(0.0, 0.0, -1.0);
	var dO : float = 0.0;
	var c : float = 0.0;
	
	for i in range(100):
		var p : Vector3 = ro + rd * dO;
		var dS : Vector2 = sdf3d_input(p);
		
		dO += dS.x;

		if (dO >= 1.0):
			break;
		elif (dS.x < 0.0001):
			c = dS.y;
			break;
	
	return Vector2(dO, c);

#vec3 normal_$name(vec3 p) {
#	if (p.z <= 0.0) {
#		return vec3(0.0, 0.0, 1.0);
#	}
#
#	float d = $sdf(p).x;
#	float e = .001;        
#	vec3 n = d - vec3(        
#		$sdf(p-vec3(e, 0.0, 0.0)).x,        
#		$sdf(p-vec3(0.0, e, 0.0)).x,        
#		$sdf(p-vec3(0.0, 0.0, e)).x);        
#
#	return vec3(-1.0, -1.0, -1.0)*normalize(n);
#}

static func sdf3d_normal(p : Vector3) -> Vector3:
	if (p.z <= 0.0):
		return Vector3(0.0, 0.0, 1.0);

	var d : float = sdf3d_input(p).x;
	var e : float = .001;
	
	var n : Vector3 = Vector3(
		d - sdf3d_input(p - Vector3(e, 0.0, 0.0)).x,
		d - sdf3d_input(p - Vector3(0.0, e, 0.0)).x,
		d - sdf3d_input(p - Vector3(0.0, 0.0, e)).x);
	
	return Vector3(-1.0, -1.0, -1.0) * n.normalized();
	
#vec2 sdf3dc_union(vec2 a, vec2 b) {
#	return vec2(min(a.x, b.x), mix(b.y, a.y, step(a.x, b.x)));
#}

static func sdf3dc_union(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(min(a.x, b.x), lerp(b.y, a.y, step(a.x, b.x)));

#vec2 sdf3dc_sub(vec2 a, vec2 b) {
#	return vec2(max(-a.x, b.x), a.y);
#}

static func sdf3dc_sub(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(max(-a.x, b.x), a.y);

#vec2 sdf3dc_inter(vec2 a, vec2 b) {
#	return vec2(max(a.x, b.x), mix(a.y, b.y, step(a.x, b.x)));
#}

static func sdf3dc_inter(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(max(a.x, b.x), lerp(a.y, b.y, step(a.x, b.x)));

#vec2 sdf3d_smooth_union(vec2 d1, vec2 d2, float k) {    
#	float h = clamp(0.5+0.5*(d2.x-d1.x)/k, 0.0, 1.0);    
#	return vec2(mix(d2.x, d1.x, h)-k*h*(1.0-h), mix(d2.y, d1.y, step(d1.x, d2.x)));
#}

static func sdf3d_smooth_union(d1 : Vector2, d2 : Vector2, k : float) -> Vector2:
	var h : float = clamp(0.5 + 0.5 * (d2.x - d1.x) / k, 0.0, 1.0);
	return Vector2(lerp(d2.x, d1.x, h)-k*h*(1.0 - h), lerp(d2.y, d1.y, step(d1.x, d2.x)));

#vec2 sdf3d_smooth_subtraction(vec2 d1, vec2 d2, float k ) {    
#	float h = clamp(0.5-0.5*(d2.x+d1.x)/k, 0.0, 1.0);    
#	return vec2(mix(d2.x, -d1.x, h )+k*h*(1.0-h), d2.y);
#}

static func sdf3d_smooth_subtraction(d1 : Vector2, d2 : Vector2, k : float) -> Vector2:
	var h : float = clamp(0.5 - 0.5 * (d2.x + d1.x) / k, 0.0, 1.0);
	return Vector2(lerp(d2.x, -d1.x, h )+k*h*(1.0-h), d2.y);

#vec2 sdf3d_smooth_intersection(vec2 d1, vec2 d2, float k ) {    
#	float h = clamp(0.5-0.5*(d2.x-d1.x)/k, 0.0, 1.0);    
#	return vec2(mix(d2.x, d1.x, h)+k*h*(1.0-h), mix(d1.y, d2.y, step(d1.x, d2.x)));
#}

static func sdf3d_smooth_intersection(d1 : Vector2, d2 : Vector2, k : float) -> Vector2:
	var h : float = clamp(0.5 - 0.5 * (d2.x - d1.x) / k, 0.0, 1.0);
	return Vector2(lerp(d2.x, d1.x, h)+k*h*(1.0-h), lerp(d1.y, d2.y, step(d1.x, d2.x)));

static func sdf3d_rounded(v : Vector2, r : float) -> Vector2:
	return Vector2(v.x - r, v.y);

static func sdf3d_elongation(p : Vector3, v : Vector3) -> Vector3:
	return ((p) - clampv3((p), - absv3(v), absv3(v)))

static func sdf3d_repeat(p : Vector3, r : Vector2, randomness : float, pseed : int) -> Vector3:
	#$in(repeat($uv, vec3(1.0/$rx, 1.0/$ry, 0.0), float($seed), $r))
	return repeat(p, Vector3(1.0 / r.x, 1.0 / r.y, 0.00001), float(pseed), randomness)

#vec3 repeat(vec3 p, vec3 r, float seed, float randomness) {
#	vec3 a = (rand3(floor(mod((p.xy+0.5*r.xy)/r.xy, 1.0/r.xy)+vec2(seed)))-0.5)*6.28*randomness;
#	p = mod(p+0.5*r,r)-0.5*r;
#
#	vec3 rv;
#	float c;
#	float s;
#
#	c = cos(a.x);
#	s = sin(a.x);
#
#	rv.x = p.x;
#	rv.y = p.y*c+p.z*s;rv.z = -p.y*s+p.z*c;
#
#	c = cos(a.y);
#	s = sin(a.y);
#
#	p.x = rv.x*c+rv.z*s;
#	p.y = rv.y;
#	p.z = -rv.x*s+rv.z*c;
#
#	c = cos(a.z);
#	s = sin(a.z);
#
#	rv.x = p.x*c+p.y*s;
#	rv.y = -p.x*s+p.y*c;
#	rv.z = p.z;
#
#	return rv;
#}

static func repeat(p : Vector3, r : Vector3, pseed : float, randomness : float) -> Vector3:
	var a : Vector3 = (rand3(floorv2(modv2((Vector2(p.x, p.y) + Vector2(0.5, 0.5) * Vector2(r.x, r.y)) / Vector2(r.x, r.y), Vector2(1, 1) / Vector2(r.x, r.y)) + Vector2(pseed, pseed))) - Vector3(0.5, 0.5, 0.5)) * 6.28 * randomness
	p = modv3(p + Vector3(0.5, 0.5, 0.5) * r, r) - Vector3(0.5, 0.5, 0.5) * r;
	
	var rv : Vector3 = Vector3()
	var c : float = 0
	var s : float = 0

	c = cos(a.x);
	s = sin(a.x);

	rv.x = p.x;
	rv.y = p.y* c + p.z * s;
	rv.z = -p.y * s + p.z * c;
	
	c = cos(a.y);
	s = sin(a.y);

	p.x = rv.x*c+rv.z*s;
	p.y = rv.y;
	p.z = -rv.x*s+rv.z*c;

	c = cos(a.z);
	s = sin(a.z);

	rv.x = p.x * c + p.y * s;
	rv.y = -p.x * s + p.y * c;
	rv.z = p.z;
	
	return rv;

#vec3 rotate3d(vec3 p, vec3 a) {
#	vec3 rv;
#	float c;
#	float s;
#	c = cos(a.x);
#	s = sin(a.x);
#	rv.x = p.x;
#	rv.y = p.y*c+p.z*s;
#	rv.z = -p.y*s+p.z*c;
#	c = cos(a.y);
#	s = sin(a.y);
#	p.x = rv.x*c+rv.z*s;
#	p.y = rv.y;
#	p.z = -rv.x*s+rv.z*c;
#	c = cos(a.z);
#	s = sin(a.z);
#	rv.x = p.x*c+p.y*s;
#	rv.y = -p.x*s+p.y*c;
#	rv.z = p.z;
#	return rv;
#}

static func rotate3d(p : Vector3, a : Vector3) -> Vector3:
	var rv : Vector3 = Vector3()
	var c : float = 0
	var s : float = 0
	c = cos(a.x)
	s = sin(a.x)
	rv.x = p.x
	rv.y = p.y * c + p.z * s
	rv.z = -p.y * s + p.z * c
	c = cos(a.y)
	s = sin(a.y)
	p.x = rv.x * c + rv.z * s
	p.y = rv.y
	p.z = -rv.x * s + rv.z * c
	c = cos(a.z)
	s = sin(a.z)
	rv.x = p.x * c + p.y * s
	rv.y = -p.x * s + p.y * c
	rv.z = p.z
	
	return rv

#vec3 circle_repeat_transform(vec3 p, float count) {
#	float r = 6.28/count;
#	float pa = atan(p.x, p.y);
#	float a = mod(pa+0.5*r, r)-0.5*r;
#	vec3 rv;
#	float c = cos(a-pa);
#	float s = sin(a-pa);
#	rv.x = p.x*c+p.y*s;
#	rv.y = -p.x*s+p.y*c;
#	rv.z = p.z;
#	return rv;
#}

static func circle_repeat_transform(p : Vector3, count : float) -> Vector3:
	var r : float = 6.28 / count
	var pa : float = atan2(p.x, p.y)
	var a : float = modf(pa + 0.5 * r, r) - 0.5 * r
	var rv : Vector3 = Vector3()
	var c : float = cos(a-pa)
	var s : float = sin(a-pa)
	rv.x = p.x * c + p.y * s
	rv.y = -p.x * s + p.y * c
	rv.z = p.z
	return rv

#todo this needs to be solved
static func sdf3d_input(p : Vector3) -> Vector2:
	return sdf3d_sphere(p, 0.5)

#raymarching_preview.mmg
#vec3 render_$name(vec2 uv) {
#	vec3 p = vec3(uv, 2.0-raymarch_$name(vec3(uv, 2.0), vec3(0.0, 0.0, -1.0)));
#	vec3 n = normal_$name(p);
#	vec3 l = vec3(5.0, 5.0, 10.0);
#	vec3 ld = normalize(l-p);
#
#	float o = step(p.z, 0.001);
#	float shadow = 1.0-0.75*step(raymarch_$name(l, -ld), length(l-p)-0.01);
#	float light = 0.3+0.7*dot(n, ld)*shadow;
#
#	return vec3(0.8+0.2*o, 0.8+0.2*o, 1.0)*light;
#}

#static func sdf3d_render(p : Vector2) -> Vector3:
#	return Vector3()


# ========================= SHAPES.GD =========================



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
	
	return clamp((size - cos(floor(1.5 + angle / slice - 2.0 * step(0.5 * slice, modf(angle, slice))) * slice - angle) * uv.length()) / (edge * size), 0.0, 1.0);

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
	var angle : float = modf(atan(uv.y / uv.x) + 3.14159265359, slice) / slice
	
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


# ============================== SIMPLE.GD ========================



#----------------------
#profile.mmg

#		"inputs": [
#			{
#				"default": "dot($gradient($uv.x).xyz, vec3(1.0/3.0))",
#				"label": "2:",
#				"name": "in",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"f": "draw_profile_$style($uv, $in($uv), (dot($gradient($uv.x+0.001).xyz, vec3(1.0/3.0))-dot($gradient($uv.x-0.001).xyz, vec3(1.0/3.0)))/0.002, max(0.0001, $width))",
#				"longdesc": "An image showing the profile defined by the gradient",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "Style of the output image (fill or curve)",
#				"name": "style",
#				"shortdesc": "Style",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Curve",
#						"value": "curve"
#					},
#					{
#						"name": "Fill",
#						"value": "fill"
#					}
#				]
#			},
#			{
#				"default": {
#					"interpolation": 1,
#					"points": [
#						{
#							"a": 1,
#							"b": 0,
#							"g": 0,
#							"pos": 0,
#							"r": 0
#						},
#						{
#							"a": 1,
#							"b": 1,
#							"g": 1,
#							"pos": 1,
#							"r": 1
#						}
#					],
#					"type": "Gradient"
#				},
#				"label": "",
#				"longdesc": "Gradient that defines the profile to be shown",
#				"name": "gradient",
#				"shortdesc": "Gradient",
#				"type": "gradient"
#			},
#			{
#				"control": "None",
#				"default": 0.05,
#				"label": "",
#				"longdesc": "Width of the curve",
#				"max": 1,
#				"min": 0,
#				"name": "width",
#				"shortdesc": "Width",
#				"step": 0.01,
#				"type": "float"
#			}
#		]

#----------------------
#uniform.mmg
#Draws a uniform image

#		"outputs": [
#			{
#				"longdesc": "A uniform image of the selected color",
#				"rgba": "$(color)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"a": 1,
#					"b": 1,
#					"g": 1,
#					"r": 1
#				},
#				"label": "",
#				"longdesc": "Color of the uniform image",
#				"name": "color",
#				"shortdesc": "Color",
#				"type": "color"
#			}
#		]

#----------------------
#uniform_greyscale.mmg
#Draws a uniform greyscale image

#		"outputs": [
#			{
#				"f": "$(color)",
#				"longdesc": "A uniform image of the selected value",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "",
#				"longdesc": "The value of the uniform greyscale image",
#				"max": 1,
#				"min": 0,
#				"name": "color",
#				"shortdesc": "Value",
#				"step": 0.01,
#				"type": "float"
#			}
#		]

#float draw_profile_fill(vec2 uv, float y, float dy, float w) {\n\t
#	return 1.0-clamp(sin(1.57079632679-atan(dy))*(1.0-uv.y-y)/w, 0.0, 1.0);\n
#}
	
#float draw_profile_curve(vec2 uv, float y, float dy, float w) {\n\t
#	return 1.0-clamp(sin(1.57079632679-atan(dy))*abs(1.0-uv.y-y)/w, 0.0, 1.0);\n
#}

# ======================== TEX3D.GD =============================


#----------------------
#tex3d_apply.mmg
#Applies 3D textures to a rendered 3D signed distance function scene.

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "Height",
#				"longdesc": "The height map generated by the Render node",
#				"name": "z",
#				"shortdesc": "HeightMap",
#				"type": "f"
#			},
#			{
#				"default": "0.0",
#				"label": "Color",
#				"longdesc": "The color map generated by the Render node",
#				"name": "c",
#				"shortdesc": "ColorMap",
#				"type": "f"
#			},
#			{
#				"default": "vec3(1.0)",
#				"label": "Texture",
#				"longdesc": "The 3D texture",
#				"name": "t",
#				"shortdesc": "Tex3D",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The textured 3D scene",
#				"rgb": "$t(vec4($uv, $z($uv), $c($uv)))",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],

#----------------------
#tex3d_apply_invuvmap.mmg
#This node applies a 3D texture to an object using its inverse UV map.

#		"inputs": [
#			{
#				"default": "vec3(1.0)",
#				"label": "Texture",
#				"longdesc": "The input 3D texture",
#				"name": "t",
#				"shortdesc": "Texture",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "Inv. UV Map",
#				"longdesc": "The inverse UV map of the object",
#				"name": "map",
#				"shortdesc": "InvUVMap",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated texture",
#				"rgb": "$t(vec4($map($uv), 0.0))",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],

#----------------------
#tex3d_blend.mmg
#Blends its 3D texture inputs, using an optional mask

#		"inputs": [
#			{
#				"default": "vec3($uv.x, 1.0, 1.0)",
#				"label": "Source1",
#				"longdesc": "The foreground input",
#				"name": "s1",
#				"shortdesc": "Foreground",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(1.0, $uv.y, 1.0)",
#				"label": "Source2",
#				"longdesc": "The background input",
#				"name": "s2",
#				"shortdesc": "Background",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(1.0)",
#				"label": "Opacity",
#				"longdesc": "The optional opacity mask",
#				"name": "a",
#				"shortdesc": "Mask",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The 3D texture generated by the blend operation",
#				"shortdesc": "Output",
#				"tex3d": "blend3d_$blend_type($s1($uv).rgb, $s2($uv).rgb, $amount*dot($a($uv), vec3(1.0))/3.0)",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "The algorithm used to blend the inputs",
#				"name": "blend_type",
#				"shortdesc": "Blend mode",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Normal",
#						"value": "normal"
#					},
#					{
#						"name": "Multiply",
#						"value": "multiply"
#					},
#					{
#						"name": "Screen",
#						"value": "screen"
#					},
#					{
#						"name": "Overlay",
#						"value": "overlay"
#					},
#					{
#						"name": "Hard Light",
#						"value": "hard_light"
#					},
#					{
#						"name": "Soft Light",
#						"value": "soft_light"
#					},
#					{
#						"name": "Burn",
#						"value": "burn"
#					},
#					{
#						"name": "Dodge",
#						"value": "dodge"
#					},
#					{
#						"name": "Lighten",
#						"value": "lighten"
#					},
#					{
#						"name": "Darken",
#						"value": "darken"
#					},
#					{
#						"name": "Difference",
#						"value": "difference"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "3:",
#				"longdesc": "The opacity of the blend operation",
#				"max": 1,
#				"min": 0,
#				"name": "amount",
#				"shortdesc": "Opacity",
#				"step": 0,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_colorize.mmg
#Remaps a greyscale 3D texture to a custom gradient

#		"inputs": [
#			{
#				"default": "vec3($uv.x+0.5)",
#				"label": "",
#				"longdesc": "The input greyscale 3D texture",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The remapped color 3D texture ",
#				"shortdesc": "Output",
#				"tex3d": "$g(dot($in($uv), vec3(1.0))/3.0).rgb",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"interpolation": 1,
#					"points": [
#						{
#							"a": 1,
#							"b": 0,
#							"g": 0,
#							"pos": 0,
#							"r": 0
#						},
#						{
#							"a": 1,
#							"b": 1,
#							"g": 1,
#							"pos": 1,
#							"r": 1
#						}
#					],
#					"type": "Gradient"
#				},
#				"label": "",
#				"longdesc": "The gradient to which the input is remapped",
#				"name": "g",
#				"shortdesc": "Gradient",
#				"type": "gradient"
#			}
#		],

#----------------------
#tex3d_distort.mmg
#Distorts its input 3D texture using another 3D texture

#		"inputs": [
#			{
#				"default": "vec3(1.0)",
#				"label": "",
#				"longdesc": "The 3D texture to be distorted",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "",
#				"longdesc": "The 3D texture used to distort Input1",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The distorted 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "$in1(vec4($uv.xyz+($in2($uv)*$Distort*0.5-0.5), 0.0))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Distort",
#				"longdesc": "The strength of the distort effect",
#				"max": 1,
#				"min": 0,
#				"name": "Distort",
#				"shortdesc": "Strength",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_fbm.mmg
#Generates a 3D noise made of several octaves of a simple noise

#		"instance": "float $(name)_fbm(vec3 coord, vec3 size, int octaves, float persistence, float seed) {\n\tfloat normalize_factor = 0.0;\n\tfloat value = 0.0;\n\tfloat scale = 1.0;\n\tfor (int i = 0; i < octaves; i++) {\n\t\tvalue += tex3d_fbm_$noise(coord*size, size, seed) * scale;\n\t\tnormalize_factor += scale;\n\t\tsize *= 2.0;\n\t\tscale *= persistence;\n\t}\n\treturn value / normalize_factor;\n}\n",
#		"outputs": [
#			{
#				"longdesc": "Shows a greyscale 3D texture of the generated noise",
#				"shortdesc": "Output",
#				"tex3d": "vec3($(name)_fbm($(uv).xyz, vec3($(scale_x), $(scale_y), $(scale_z)), int($(iterations)), $(persistence), float($(seed))))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"default": 2,
#				"label": "Noise",
#				"longdesc": "The simple noise type",
#				"name": "noise",
#				"shortdesc": "Noise type",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Value",
#						"value": "value"
#					},
#					{
#						"name": "Perlin",
#						"value": "perlin"
#					},
#					{
#						"name": "Cellular",
#						"value": "cellular"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Scale X",
#				"longdesc": "The scale of the first octave along the X axis",
#				"max": 32,
#				"min": 1,
#				"name": "scale_x",
#				"shortdesc": "Scale.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Scale Y",
#				"longdesc": "The scale of the first octave along the Y axis",
#				"max": 32,
#				"min": 1,
#				"name": "scale_y",
#				"shortdesc": "Scale.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Scale Z",
#				"longdesc": "The scale of the first octave along the Z axis",
#				"max": 32,
#				"min": 1,
#				"name": "scale_z",
#				"shortdesc": "Scale.z",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 3,
#				"label": "Iterations",
#				"longdesc": "The number of noise octaves",
#				"max": 10,
#				"min": 1,
#				"name": "iterations",
#				"shortdesc": "Octaves",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Persistence",
#				"longdesc": "The persistence between two consecutive octaves",
#				"max": 1,
#				"min": 0,
#				"name": "persistence",
#				"shortdesc": "Persistence",
#				"step": 0.05,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_from2d.mmg
#Creates a 3D texture from a 2D texture

#		"inputs": [
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The input 2D texture",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "$in($uv.xy+vec2(0.5))",
#				"type": "tex3d"
#			}
#		],

#----------------------
#tex3d_pattern.mmg
#A greyscale 3D texture that combines patterns along all 3 axes

#		"instance": "float $(name)_fct(vec3 uv) {\n\treturn mix3d_$(mix)(wave3d_$(x_wave)($(x_scale)*uv.x), wave3d_$(y_wave)($(y_scale)*uv.y), wave3d_$(z_wave)($(z_scale)*uv.z));\n}",
#		"outputs": [
#			{
#				"longdesc": "The generated 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "vec3($(name)_fct($(uv).xyz))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "Combiner",
#				"longdesc": "The operation used to combine the X, Y and Z patterns",
#				"name": "mix",
#				"shortdesc": "Combine",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Multiply",
#						"value": "mul"
#					},
#					{
#						"name": "Add",
#						"value": "add"
#					},
#					{
#						"name": "Max",
#						"value": "max"
#					},
#					{
#						"name": "Min",
#						"value": "min"
#					},
#					{
#						"name": "Xor",
#						"value": "xor"
#					},
#					{
#						"name": "Pow",
#						"value": "pow"
#					}
#				]
#			},
#			{
#				"default": 0,
#				"label": "X",
#				"longdesc": "Pattern generated along the X axis",
#				"name": "x_wave",
#				"shortdesc": "Pattern.x",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Sine",
#						"value": "sine"
#					},
#					{
#						"name": "Triangle",
#						"value": "triangle"
#					},
#					{
#						"name": "Square",
#						"value": "square"
#					},
#					{
#						"name": "Sawtooth",
#						"value": "sawtooth"
#					},
#					{
#						"name": "Constant",
#						"value": "constant"
#					},
#					{
#						"name": "Bounce",
#						"value": "bounce"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "2:",
#				"longdesc": "Repetitions of the pattern along X axis",
#				"max": 32,
#				"min": 0,
#				"name": "x_scale",
#				"shortdesc": "Repeat.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"default": 0,
#				"label": "Y",
#				"longdesc": "Pattern generated along the Y axis",
#				"name": "y_wave",
#				"shortdesc": "Pattern.y",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Sine",
#						"value": "sine"
#					},
#					{
#						"name": "Triangle",
#						"value": "triangle"
#					},
#					{
#						"name": "Square",
#						"value": "square"
#					},
#					{
#						"name": "Sawtooth",
#						"value": "sawtooth"
#					},
#					{
#						"name": "Constant",
#						"value": "constant"
#					},
#					{
#						"name": "Bounce",
#						"value": "bounce"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "3:",
#				"longdesc": "Repetitions of the pattern along Y axis",
#				"max": 32,
#				"min": 0,
#				"name": "y_scale",
#				"shortdesc": "Repeat.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"default": 0,
#				"label": "Z",
#				"longdesc": "Pattern generated along the Z axis",
#				"name": "z_wave",
#				"shortdesc": "Pattern.z",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Sine",
#						"value": "sine"
#					},
#					{
#						"name": "Triangle",
#						"value": "triangle"
#					},
#					{
#						"name": "Square",
#						"value": "square"
#					},
#					{
#						"name": "Sawtooth",
#						"value": "sawtooth"
#					},
#					{
#						"name": "Constant",
#						"value": "constant"
#					},
#					{
#						"name": "Bounce",
#						"value": "bounce"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "4:",
#				"longdesc": "Repetitions of the pattern along Z axis",
#				"max": 32,
#				"min": 0,
#				"name": "z_scale",
#				"shortdesc": "Repeat.z",
#				"step": 1,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_rotate.mmg
#Rotates a 3D texture

#		"inputs": [
#			{
#				"default": "vec3(1.0)",
#				"label": "",
#				"longdesc": "The input 3D texture",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The rotated 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "$in(vec4(tex3d_rotate($uv.xyz, -vec3($ax, $ay, $az)*0.01745329251), $uv.w))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0,
#				"label": "X",
#				"longdesc": "The rotation around the X axis",
#				"max": 180,
#				"min": -180,
#				"name": "ax",
#				"shortdesc": "Rotate.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Y",
#				"longdesc": "The rotation around the Y axis",
#				"max": 180,
#				"min": -180,
#				"name": "ay",
#				"shortdesc": "Rotate.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Z",
#				"longdesc": "The rotation around the Z axis",
#				"max": 180,
#				"min": -180,
#				"name": "az",
#				"shortdesc": "Rotate.z",
#				"step": 1,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_select.mmg
#Selects a 3D texture for a given color index. This can be used to map several textures into a single 3D scene.

#		"code": "float $(name_uv)_d = ($uv.w-$v)/$t;",
#		"inputs": [
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The 3D texture associated to the specified color index",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The 3D texture(s) associated to other color indices",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The merged 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "mix($in1($uv), $in2($uv), clamp(1.0-$(name_uv)_d*$(name_uv)_d, 0.0, 1.0))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Value",
#				"longdesc": "The value of the selected color index",
#				"max": 1,
#				"min": 0,
#				"name": "v",
#				"shortdesc": "Value",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Tolerance",
#				"longdesc": "The tolerance used when comparing color indices",
#				"max": 1,
#				"min": 0.01,
#				"name": "t",
#				"shortdesc": "Tolerance",
#				"step": 0.001,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_select_shape.mmg
#Selects a 3D texture inside, and another outside a shape. This can be used to map several textures into a single 3D scene.

#		"inputs": [
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The 3D texture associated to the specified color index",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The 3D texture(s) associated to other color indices",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "tex3d"
#			},
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The shape in which input1 is applied",
#				"name": "shape",
#				"shortdesc": "Shape",
#				"type": "sdf3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The merged 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "mix($in1($uv), $in2($uv), clamp($shape($uv.xyz)/max($d, 0.0001), 0.0, 1.0))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Smoothness",
#				"longdesc": "The width of the transition area between both textures",
#				"max": 1,
#				"min": 0,
#				"name": "d",
#				"shortdesc": "Smoothness",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_apply.mmg

#----------------------
#tex3d_apply.mmg

#----------------------
#tex3d_apply.mmg

#----------------------
#tex3d_apply.mmg

#vec3 blend3d_normal(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*c1 + (1.0-opacity)*c2;\n
#}

#vec3 blend3d_multiply(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*c1*c2 + (1.0-opacity)*c2;\n
#}

#vec3 blend3d_screen(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*(1.0-(1.0-c1)*(1.0-c2)) + (1.0-opacity)*c2;\n
#}

#float blend3d_overlay_f(float c1, float c2) {\n\t
#	return (c1 < 0.5) ? (2.0*c1*c2) : (1.0-2.0*(1.0-c1)*(1.0-c2));\n
#}

#vec3 blend3d_overlay(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend3d_overlay_f(c1.x, c2.x), blend3d_overlay_f(c1.y, c2.y), blend3d_overlay_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}

#vec3 blend3d_hard_light(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*0.5*(c1*c2+blend3d_overlay(c1, c2, 1.0)) + (1.0-opacity)*c2;\n
#}

#float blend3d_soft_light_f(float c1, float c2) {\n\t
#	return (c2 < 0.5) ? (2.0*c1*c2+c1*c1*(1.0-2.0*c2)) : 2.0*c1*(1.0-c2)+sqrt(c1)*(2.0*c2-1.0);\n
#}
	
#vec3 blend3d_soft_light(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend3d_soft_light_f(c1.x, c2.x), blend3d_soft_light_f(c1.y, c2.y), blend3d_soft_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}
	
#float blend3d_burn_f(float c1, float c2) {\n\t
#	return (c1==0.0)?c1:max((1.0-((1.0-c2)/c1)),0.0);\n
#}
	
#vec3 blend3d_burn(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend3d_burn_f(c1.x, c2.x), blend3d_burn_f(c1.y, c2.y), blend3d_burn_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}
	
#float blend3d_dodge_f(float c1, float c2) {\n\t
#	return (c1==1.0)?c1:min(c2/(1.0-c1),1.0);\n
#}
	
#vec3 blend3d_dodge(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend3d_dodge_f(c1.x, c2.x), blend3d_dodge_f(c1.y, c2.y), blend3d_dodge_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}
		
#vec3 blend3d_lighten(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*max(c1, c2) + (1.0-opacity)*c2;\n
#}
		
#vec3 blend3d_darken(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*min(c1, c2) + (1.0-opacity)*c2;
#}
		
#vec3 blend3d_difference(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;\n
#}

#float rand31(vec3 p) {\n\t
#	return fract(sin(dot(p,vec3(127.1,311.7, 74.7)))*43758.5453123);\n
#}

#vec3 rand33(vec3 p) {\n\t
#	p = vec3( dot(p,vec3(127.1,311.7, 74.7)),
#		dot(p,vec3(269.5,183.3,246.1)),\n\t\t\t  
#		dot(p,vec3(113.5,271.9,124.6)));\n\n\t
#
#	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
#}
	
#float tex3d_fbm_value(vec3 coord, vec3 size, float seed) {\n\t
#	vec3 o = floor(coord)+rand3(vec2(seed, 1.0-seed))+size;\n\t
#	vec3 f = fract(coord);\n\t
#	float p000 = rand31(mod(o, size));\n\t
#	float p001 = rand31(mod(o + vec3(0.0, 0.0, 1.0), size));\n\t
#	float p010 = rand31(mod(o + vec3(0.0, 1.0, 0.0), size));\n\t
#	float p011 = rand31(mod(o + vec3(0.0, 1.0, 1.0), size));\n\t
#	float p100 = rand31(mod(o + vec3(1.0, 0.0, 0.0), size));\n\t
#	float p101 = rand31(mod(o + vec3(1.0, 0.0, 1.0), size));\n\t
#	float p110 = rand31(mod(o + vec3(1.0, 1.0, 0.0), size));\n\t
#	float p111 = rand31(mod(o + vec3(1.0, 1.0, 1.0), size));\n\t
#
#	vec3 t = f * f * (3.0 - 2.0 * f);\n\t
#
#	return mix(mix(mix(p000, p100, t.x), mix(p010, p110, t.x), t.y), mix(mix(p001, p101, t.x), mix(p011, p111, t.x), t.y), t.z);\n
#}

#float tex3d_fbm_perlin(vec3 coord, vec3 size, float seed) {\n\t
#	vec3 o = floor(coord)+rand3(vec2(seed, 1.0-seed))+size;\n\t
#	vec3 f = fract(coord);\n\t
#	vec3 v000 = normalize(rand33(mod(o, size))-vec3(0.5));\n\t
#	vec3 v001 = normalize(rand33(mod(o + vec3(0.0, 0.0, 1.0), size))-vec3(0.5));\n\t
#	vec3 v010 = normalize(rand33(mod(o + vec3(0.0, 1.0, 0.0), size))-vec3(0.5));\n\t
#	vec3 v011 = normalize(rand33(mod(o + vec3(0.0, 1.0, 1.0), size))-vec3(0.5));\n\t
#	vec3 v100 = normalize(rand33(mod(o + vec3(1.0, 0.0, 0.0), size))-vec3(0.5));\n\t
#	vec3 v101 = normalize(rand33(mod(o + vec3(1.0, 0.0, 1.0), size))-vec3(0.5));\n\t
#	vec3 v110 = normalize(rand33(mod(o + vec3(1.0, 1.0, 0.0), size))-vec3(0.5));\n\t
#	vec3 v111 = normalize(rand33(mod(o + vec3(1.0, 1.0, 1.0), size))-vec3(0.5));\n\t
#
#	float p000 = dot(v000, f);\n\tfloat p001 = dot(v001, f - vec3(0.0, 0.0, 1.0));\n\t
#	float p010 = dot(v010, f - vec3(0.0, 1.0, 0.0));\n\t
#	float p011 = dot(v011, f - vec3(0.0, 1.0, 1.0));\n\t
#	float p100 = dot(v100, f - vec3(1.0, 0.0, 0.0));\n\t
#	float p101 = dot(v101, f - vec3(1.0, 0.0, 1.0));\n\t
#	float p110 = dot(v110, f - vec3(1.0, 1.0, 0.0));\n\t
#	float p111 = dot(v111, f - vec3(1.0, 1.0, 1.0));\n\t
#
#	vec3 t = f * f * (3.0 - 2.0 * f);\n\t
#
#	return 0.5 + mix(mix(mix(p000, p100, t.x), mix(p010, p110, t.x), t.y), mix(mix(p001, p101, t.x), mix(p011, p111, t.x), t.y), t.z);
#}

#float tex3d_fbm_cellular(vec3 coord, vec3 size, float seed) {\n\t
#	vec3 o = floor(coord)+rand3(vec2(seed, 1.0-seed))+size;\n\t
#	vec3 f = fract(coord);\n\tfloat min_dist = 3.0;\n\t
#
#	for (float x = -1.0; x <= 1.0; x++) {\n\t\t
#		for (float y = -1.0; y <= 1.0; y++) {\n\t\t\t
#			for (float z = -1.0; z <= 1.0; z++) {\n\t\t\t\t
#				vec3 node = 0.4*rand33(mod(o + vec3(x, y, z), size)) + vec3(x, y, z);\n\t\t\t\t
#				float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y + (f - node).z * (f - node).z);\n\t\t\t\t
#				min_dist = min(min_dist, dist);\n\t\t\t
#			}\n\t\t
#
#		}\n\t
#
#	}\n\t
#
#	return min_dist;
#}


#float wave3d_constant(float x) {\n\t
#	return 1.0;\n
#}

#float wave3d_sine(float x) {\n\t
#	return 0.5-0.5*cos(3.14159265359*2.0*x);\n
#}

#float wave3d_triangle(float x) {\n\t
#	x = fract(x);\n\t
#	return min(2.0*x, 2.0-2.0*x);\n
#}

#float wave3d_sawtooth(float x) {\n\t
#	return fract(x);\n
#}

#float wave3d_square(float x) {\n\t
#	return (fract(x) < 0.5) ? 0.0 : 1.0;\n
#}

#float wave3d_bounce(float x) {\n\t
#	x = 2.0*(fract(x)-0.5);\n\t
#	return sqrt(1.0-x*x);\n
#}

#float mix3d_mul(float x, float y, float z) {\n\t
#	return x*y*z;\n
#}

#float mix3d_add(float x, float y, float z) {\n\t
#	return min(x+y+z, 1.0);\n
#}

#float mix3d_max(float x, float y, float z) {\n\t
#	return max(max(x, y), z);\n
#}

#float mix3d_min(float x, float y, float z) {\n\t
#	return min(min(x, y), z);\n
#}

#float mix3d_xor(float x, float y, float z) {\n\t
#	float xy = min(x+y, 2.0-x-y);\n\t
#	return min(xy+z, 2.0-xy-z);\n
#}

#float mix3d_pow(float x, float y, float z) {\n\t
#	return pow(pow(x, y), z);\n
#}

#vec3 tex3d_rotate(vec3 p, vec3 a) {\n\t
#	vec3 rv;\n\t
#	float c;\n\t
#	float s;\n\t
#	c = cos(a.x);\n\t
#	s = sin(a.x);\n\t
#	rv.x = p.x;\n\t
#	rv.y = p.y*c+p.z*s;\n\t
#	rv.z = -p.y*s+p.z*c;\n\t
#	c = cos(a.y);\n\t
#	s = sin(a.y);\n\t
#	p.x = rv.x*c+rv.z*s;\n\t
#	p.y = rv.y;\n\t
#	p.z = -rv.x*s+rv.z*c;\n\t
#	c = cos(a.z);\n\t
#	s = sin(a.z);\n\t
#	rv.x = p.x*c+p.y*s;\n\t
#	rv.y = -p.x*s+p.y*c;\n\t
#	rv.z = p.z;\n\t
#	return rv;\n
#}


# ================================== TILE.GD ============================


#----------------------
#tile2x2.mmg
#Places 4 input images into a single output to create an atlas of 4 images. 
#Chaining Tile2x2 nodes can be useful to create 16 images atlases.
#Atlases are used by remapping nodes such as CustomUV, Tiler and Splatter.

#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The first input",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The second input",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The third input",
#				"name": "in3",
#				"shortdesc": "Input3",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The fourth input",
#				"name": "in4",
#				"shortdesc": "Input4",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the generated atlas",
#				"rgba": "($uv.y < 0.5) ? (($uv.x < 0.5) ? ($in1(2.0*$uv)) : ($in2(2.0*$uv-vec2(1.0, 0.0)))) : (($uv.x < 0.5) ? ($in3(2.0*$uv-vec2(0.0, 1.0))) : ($in4(2.0*$uv-vec2(1.0, 1.0))))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],

#----------------------
#tile2x2_variations.mmg
#Places 4 input images into a single output to create an atlas of 4 images.
#Chaining Tile2x2 nodes can be useful to create 16 images atlases.
#Atlases are used by remapping nodes such as CustomUV, Tiler and Splatter.

#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The first input",
#				"name": "in",
#				"shortdesc": "Input1",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the generated atlas",
#				"rgba": "($uv.y < 0.5) ? (($uv.x < 0.5) ? ($in.variation(2.0*$uv, $seed)) : ($in.variation(2.0*$uv-vec2(1.0, 0.0), $seed+0.1))) : (($uv.x < 0.5) ? ($in.variation(2.0*$uv-vec2(0.0, 1.0), $seed+0.2)) : ($in.variation(2.0*$uv-vec2(1.0, 1.0), $seed+0.3)))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],

#----------------------
#tiler.mmg
#Tiles several occurences of an input image while adding randomness.

#vec4 $(name_uv)_rch = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), vec2(float($seed)));

#instance
#vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, vec2 _seed) {\n\t
#	float c = 0.0;\n\t
#	vec3 rc = vec3(0.0);\n\t
#	vec3 rc1;\n\t
#	for (int dx = -overlap; dx <= overlap; ++dx) {\n\t\t
#		for (int dy = -overlap; dy <= overlap; ++dy) {\n\t\t\t
#			vec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));\n\t\t\t
#			vec2 seed = rand2(pos+_seed);\n\t\t\t
#			rc1 = rand3(seed);\n\t\t\t
#			pos = fract(pos+vec2($fixed_offset/tile.x, 0.0)*floor(mod(pos.y*tile.y, 2.0))+$offset*seed/tile);\n\t\t\t
#			float mask = $mask(fract(pos+vec2(0.5)));\n\t\t\t
#
#			if (mask > 0.01) {\n\t\t\t\t
#				vec2 pv = fract(uv - pos)-vec2(0.5);\n\t\t\t\t
#				seed = rand2(seed);\n\t\t\t\t
#					float angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;\n\t\t\t\t
#				float ca = cos(angle);\n\t\t\t\t
#				float sa = sin(angle);\n\t\t\t\t
#				pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t\t
#				pv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\t\t
#				pv /= vec2($scale_x, $scale_y);\n\t\t\t\t
#				pv += vec2(0.5);\n\t\t\t\t
#				seed = rand2(seed);\n\t\t\t\t
#				vec2 clamped_pv = clamp(pv, vec2(0.0), vec2(1.0));\n\t\t\t\t
#				if (pv.x != clamped_pv.x || pv.y != clamped_pv.y) {\n\t\t\t\t\t
#					continue;\n\t\t\t\t
#				}\n\t\t\t\t
#
#				$select_inputs\n\t\t\t\t
#
#				float c1 = $in.variation(pv, $variations ? seed.x : 0.0)*mask*(1.0-$value*seed.x);\n\t\t\t\t
#				c = max(c, c1);\n\t\t\t\t
#				rc = mix(rc, rc1, step(c, c1));\n\t\t\t
#			}\n\t\t
#		}\n\t
#	}\n\t
#
#	return vec4(rc, c);\n
#}

#Inputs:

#in, float, default: 0, - The input image or atlas of 4 or 16 input images
#Mask, float, default: 1, - The mask applied to the pattern

#Outputs:
#Output, float, Shows the generated pattern
#$(name_uv)_rch.a

#Instance map, rgb, Shows a random color for each instance of the input image
#$(name_uv)_rch.rgb

#select_inputs enum
#1,  " "
#4, "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#16, "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"

#Parameters:
#tile, Vector2, default 4, min:1, max:64, step:1 - The number of columns of the tiles pattern
#overlap, float, default 1, min 0, max 5, step 1 - The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.
#select_inputs (Inputs), enum, default 0, values 1, 4, 16
#scale, Vector2, default 1, min:0, max:2, step:0.01 - "The scale of input images on the X axis
#fixed_offset, float, default 0.5, min 0, max 1, step 0.01 - The relative offset of odd rows
#offset (rnd_offset), float, default 0.5, min 0, max 1, step 0.01
#rotate (rnd_rotate), float, default 0, min 0, max 180, step 0.1
#scale (rnd_scale), float, default 0.5, min 0, max 1, step 0.01 - The random scale applied to each image instance
#value (rnd_value), float, default 0.5, min 0, max 1, step 0.01 - The random greyscale value applied to each image instance
#variations, bool, default false, (disabled) - Check to tile variations of the input

#----------------------
#tiler_advanced.mmg
#Tiles several occurences of an input image while adding randomness.

#		"code": "vec4 $(name_uv)_rch = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), float($seed));",
#		"inputs": [
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image or atlas of 4 or 16 input images",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "The mask applied to the pattern",
#				"name": "mask",
#				"shortdesc": "Mask",
#				"type": "f"
#			},
#			{
#				"default": "vec4(rand2($uv+vec2(float($seed))), rand2($uv-vec2(float($seed))))",
#				"label": "",
#				"longdesc": "An input color map used to generate the Instance map 1 output",
#				"name": "color1",
#				"shortdesc": "Color map 1",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(rand2(-$uv+vec2(float($seed))), rand2(-$uv-vec2(float($seed))))",
#				"label": "",
#				"longdesc": "An input color map used to generate the Instance map 2 output",
#				"name": "color2",
#				"shortdesc": "Color map 2",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "5:",
#				"longdesc": "A map for translation along the X axis",
#				"name": "tr_x",
#				"shortdesc": "Translate map X",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for translation along the Y axis",
#				"name": "tr_y",
#				"shortdesc": "Translate map Y",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for rotation",
#				"name": "r",
#				"shortdesc": "Rotate map",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for scale along the X axis",
#				"name": "sc_x",
#				"shortdesc": "Scale map X",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for scale along the Y axis",
#				"name": "sc_y",
#				"shortdesc": "Scale map Y",
#				"type": "f"
#			}
#		],
#		"instance": "vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, float _seed) {\n\tfloat c = 0.0;\n\tvec2 map_uv = vec2(0.0);\n\tfor (int dx = -overlap; dx <= overlap; ++dx) {\n\t\tfor (int dy = -overlap; dy <= overlap; ++dy) {\n\t\t\tvec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));\n\t\t\tfloat mask = $mask(fract(pos+vec2(0.5)));\n\t\t\tif (mask > 0.01) {\n\t\t\t\tvec2 pv = fract(uv - pos)-vec2(0.5);\n\t\t\t\tpos = fract(pos+vec2(0.5));\n\t\t\t\tpv -= vec2($translate_x*$tr_x(pos), $translate_y*$tr_y(pos))/tile;\n\t\t\t\tfloat angle = $r(pos) * $rotate * 0.01745329251;\n\t\t\t\tfloat ca = cos(angle);\n\t\t\t\tfloat sa = sin(angle);\n\t\t\t\tpv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t\tpv /= vec2($scale_x*$sc_x(pos), $scale_y*$sc_y(pos));\n\t\t\t\tpv += vec2(0.5);\n\t\t\t\tif (pv != clamp(pv, vec2(0.0), vec2(1.0))) {\n\t\t\t\t\tcontinue;\n\t\t\t\t}\n\t\t\t\tvec2 seed = rand2(vec2(_seed)+pos);\n\t\t\t\t$select_inputs\n\t\t\t\tfloat c1 = $in.variation(pv, $variations ? seed.x : 0.0)*mask;\n\t\t\t\tc = max(c, c1);\n\t\t\t\tmap_uv = mix(map_uv, pos, step(c, c1));\n\t\t\t}\n\t\t}\n\t}\n\treturn vec4(map_uv, 0.0, c);\n}",
#		"outputs": [
#			{
#				"f": "$(name_uv)_rch.a",
#				"longdesc": "Shows the generated pattern",
#				"shortdesc": "Output",
#				"type": "f"
#			},
#			{
#				"longdesc": "Shows a color for each instance of the input image",
#				"rgba": "$color1($(name_uv)_rch.rg)",
#				"shortdesc": "Instance map 1",
#				"type": "rgba"
#			},
#			{
#				"longdesc": "Shows a color for each instance of the input image",
#				"rgba": "$color2($(name_uv)_rch.rg)",
#				"shortdesc": "Instance map 2",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Tile X",
#				"longdesc": "The number of columns of the tiles pattern",
#				"max": 64,
#				"min": 1,
#				"name": "tx",
#				"shortdesc": "Tile.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Tile Y",
#				"longdesc": "The number of rows of the tiles pattern",
#				"max": 64,
#				"min": 1,
#				"name": "ty",
#				"shortdesc": "Tile.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Overlap",
#				"longdesc": "The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.",
#				"max": 5,
#				"min": 0,
#				"name": "overlap",
#				"shortdesc": "Overlap",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"default": 0,
#				"label": "Inputs",
#				"longdesc": "The input type of the node:\n- 1: single image\n- 4: atlas of 4 images\n- 16: atlas of 16 images\nAtlases can be created using the Tile2x2 node.",
#				"name": "select_inputs",
#				"shortdesc": "Input",
#				"type": "enum",
#				"values": [
#					{
#						"name": "1",
#						"value": " "
#					},
#					{
#						"name": "4",
#						"value": "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#					},
#					{
#						"name": "16",
#						"value": "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Translate X",
#				"longdesc": "The translation along the X axis applied to the instances",
#				"max": 1,
#				"min": 0,
#				"name": "translate_x",
#				"shortdesc": "Translate.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Translate Y",
#				"longdesc": "The translation along the Y axis applied to the instances",
#				"max": 1,
#				"min": 0,
#				"name": "translate_y",
#				"shortdesc": "Translate.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rotate",
#				"longdesc": "The angle of instances of the input",
#				"max": 180,
#				"min": 0,
#				"name": "rotate",
#				"shortdesc": "Rotate",
#				"step": 0.1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Scale X",
#				"longdesc": "The scale of input images on the X axis",
#				"max": 2,
#				"min": 0,
#				"name": "scale_x",
#				"shortdesc": "Scale.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Scale Y",
#				"longdesc": "The scale of input images on the Y axis",
#				"max": 2,
#				"min": 0,
#				"name": "scale_y",
#				"shortdesc": "Scale.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Variations",
#				"longdesc": "Check to tile variations of the input",
#				"name": "variations",
#				"shortdesc": "Variations",
#				"type": "boolean"
#			}
#		],

#----------------------
#tiler_advanced_color.mmg
#Tiles several occurences of an input image while adding randomness.

#		"code": "vec2 $(name_uv)_mapuv;\nvec4 $(name_uv)_rch = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), float($seed), $(name_uv)_mapuv);",
#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image or atlas of 4 or 16 input images",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "The mask applied to the pattern",
#				"name": "mask",
#				"shortdesc": "Mask",
#				"type": "f"
#			},
#			{
#				"default": "vec4(rand2($uv+vec2(float($seed))), rand2($uv-vec2(float($seed))))",
#				"label": "",
#				"longdesc": "An input color map used to generate the Instance map 1 output",
#				"name": "color1",
#				"shortdesc": "Color map 1",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(rand2(-$uv+vec2(float($seed))), rand2(-$uv-vec2(float($seed))))",
#				"label": "",
#				"longdesc": "An input color map used to generate the Instance map 2 output",
#				"name": "color2",
#				"shortdesc": "Color map 2",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "5:",
#				"longdesc": "A map for translation along the X axis",
#				"name": "tr_x",
#				"shortdesc": "Translate map X",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for translation along the Y axis",
#				"name": "tr_y",
#				"shortdesc": "Translate map Y",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for rotation",
#				"name": "r",
#				"shortdesc": "Rotate map",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for scale along the X axis",
#				"name": "sc_x",
#				"shortdesc": "Scale map X",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for scale along the Y axis",
#				"name": "sc_y",
#				"shortdesc": "Scale map Y",
#				"type": "f"
#			}
#		],
#		"instance": "vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, float _seed, out vec2 outmapuv) {\n\t// $seed\n\tvec4 c = vec4(0.0);\n\toutmapuv = vec2(0.0);\n\tfor (int dx = -overlap; dx <= overlap; ++dx) {\n\t\tfor (int dy = -overlap; dy <= overlap; ++dy) {\n\t\t\tvec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));\n\t\t\tfloat mask = $mask(fract(pos+vec2(0.5)));\n\t\t\tif (mask > 0.01) {\n\t\t\t\tvec2 pv = fract(uv - pos)-vec2(0.5);\n\t\t\t\tpos = fract(pos+vec2(0.5));\n\t\t\t\tpv -= vec2($translate_x*$tr_x(pos), $translate_y*$tr_y(pos))/tile;\n\t\t\t\tfloat angle = $r(pos) * $rotate * 0.01745329251;\n\t\t\t\tfloat ca = cos(angle);\n\t\t\t\tfloat sa = sin(angle);\n\t\t\t\tpv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t\tpv /= vec2($scale_x*$sc_x(pos), $scale_y*$sc_y(pos));\n\t\t\t\tpv += vec2(0.5);\n\t\t\t\tif (pv != clamp(pv, vec2(0.0), vec2(1.0))) {\n\t\t\t\t\tcontinue;\n\t\t\t\t}\n\t\t\t\tvec2 seed = rand2(vec2(_seed)+pos);\n\t\t\t\t$select_inputs\n\t\t\t\tvec4 n = $in.variation(pv, $variations ? seed.x : 0.0);\n\t\t\t\tfloat na = n.a*mask;\n\t\t\t\toutmapuv = mix(outmapuv, pos, step(c.a, na));\n\t\t\t\tc = mix(c, n, na);\n\t\t\t}\n\t\t}\n\t}\n\treturn c;\n}\n",
#		"outputs": [
#			{
#				"longdesc": "Shows the generated pattern",
#				"rgba": "$(name_uv)_rch",
#				"shortdesc": "Output",
#				"type": "rgba"
#			},
#			{
#				"longdesc": "Shows a color for each instance of the input image",
#				"rgba": "$color1($(name_uv)_mapuv)",
#				"shortdesc": "Instance map 1",
#				"type": "rgba"
#			},
#			{
#				"longdesc": "Shows a color for each instance of the input image",
#				"rgba": "$color2($(name_uv)_mapuv)",
#				"shortdesc": "Instance map 2",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Tile X",
#				"longdesc": "The number of columns of the tiles pattern",
#				"max": 64,
#				"min": 1,
#				"name": "tx",
#				"shortdesc": "Tile.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Tile Y",
#				"longdesc": "The number of rows of the tiles pattern",
#				"max": 64,
#				"min": 1,
#				"name": "ty",
#				"shortdesc": "Tile.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Overlap",
#				"longdesc": "The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.",
#				"max": 5,
#				"min": 0,
#				"name": "overlap",
#				"shortdesc": "Overlap",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"default": 0,
#				"label": "Inputs",
#				"longdesc": "The input type of the node:\n- 1: single image\n- 4: atlas of 4 images\n- 16: atlas of 16 images\nAtlases can be created using the Tile2x2 node.",
#				"name": "select_inputs",
#				"shortdesc": "Input",
#				"type": "enum",
#				"values": [
#					{
#						"name": "1",
#						"value": " "
#					},
#					{
#						"name": "4",
#						"value": "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#					},
#					{
#						"name": "16",
#						"value": "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Translate X",
#				"longdesc": "The translation along the X axis applied to the instances",
#				"max": 1,
#				"min": 0,
#				"name": "translate_x",
#				"shortdesc": "Translate.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Translate Y",
#				"longdesc": "The translation along the Y axis applied to the instances",
#				"max": 1,
#				"min": 0,
#				"name": "translate_y",
#				"shortdesc": "Translate.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rotate",
#				"longdesc": "The angle of instances of the input",
#				"max": 180,
#				"min": 0,
#				"name": "rotate",
#				"shortdesc": "Rotate",
#				"step": 0.1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Scale X",
#				"longdesc": "The scale of input images on the X axis",
#				"max": 2,
#				"min": 0,
#				"name": "scale_x",
#				"shortdesc": "Scale.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Scale Y",
#				"longdesc": "The scale of input images on the Y axis",
#				"max": 2,
#				"min": 0,
#				"name": "scale_y",
#				"shortdesc": "Scale.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Variations",
#				"longdesc": "Check to tile variations of the input",
#				"name": "variations",
#				"shortdesc": "Variations",
#				"type": "boolean"
#			}
#		],

#----------------------
#tiler_color.mmg
#Tiles several occurences of an input image while adding randomness.

#vec3 $(name_uv)_random_color;\n
#vec4 $(name_uv)_tiled_output = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), vec2(float($seed)), $(name_uv)_random_color);

#vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, vec2 _seed, out vec3 random_color) {\n\t
#	vec4 c = vec4(0.0);\n\t
#	vec3 rc = vec3(0.0);\n\t
#	vec3 rc1;\n\t
#
#	for (int dx = -overlap; dx <= overlap; ++dx) {\n\t\t
#		for (int dy = -overlap; dy <= overlap; ++dy) {\n\t\t\t
#			vec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));\n\t\t\t
#			vec2 seed = rand2(pos+_seed);\n\t\t\t
#			rc1 = rand3(seed);\n\t\t\t
#			pos = fract(pos+vec2($fixed_offset/tile.x, 0.0)*floor(mod(pos.y*tile.y, 2.0))+$offset*seed/tile);\n\t\t\t
#			float mask = $mask(fract(pos+vec2(0.5)));\n\t\t\t
#			if (mask > 0.01) {\n\t\t\t\t
#				vec2 pv = fract(uv - pos)-vec2(0.5);\n\t\t\t\t
#				seed = rand2(seed);\n\t\t\t\t
#				float angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;\n\t\t\t\t
#				float ca = cos(angle);\n\t\t\t\t
#				float sa = sin(angle);\n\t\t\t\t
#				pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t\t
#				pv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\t\t
#				pv /= vec2($scale_x, $scale_y);\n\t\t\t\t
#				pv += vec2(0.5);\n\t\t\t\t
#				pv = clamp(pv, vec2(0.0), vec2(1.0));\n\t\t\t\t
#
#				$select_inputs\n\t\t\t\t
#
#				vec4 n = $in.variation(pv, $variations ? seed.x : 0.0);\n\t\t\t\t
#
#				seed = rand2(seed);\n\t\t\t\t
#				float na = n.a*mask*(1.0-$opacity*seed.x);\n\t\t\t\t
#				float a = (1.0-c.a)*(1.0*na);\n\t\t\t\t
#
#				c = mix(c, n, na);\n\t\t\t\t
#				rc = mix(rc, rc1, n.a);\n\t\t\t
#			}\n\t\t
#		}\n\t
#	}\n\t
#
#	random_color = rc;\n\t
#	return c;\n
#}


#Inputs:

#in, rgba, default: 0, - The input image or atlas of 4 or 16 input images
#Mask, float, default: 1, - The mask applied to the pattern

#Outputs:
#Output, float, Shows the generated pattern
#$(name_uv)_tiled_output

#Instance map, rgb, Shows a random color for each instance of the input image
#$(name_uv)_random_color

#select_inputs enum
#1,  " "
#4, "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#16, "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"

#Parameters:
#tile, Vector2, default 4, min:1, max:64, step:1 - The number of columns of the tiles pattern
#overlap, float, default 1, min 0, max 5, step 1 - The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.
#select_inputs (Inputs), enum, default 0, values 1, 4, 16
#scale, Vector2, default 1, min:0, max:2, step:0.01 - "The scale of input images on the X axis
#fixed_offset, float, default 0.5, min 0, max 1, step 0.01 - The relative offset of odd rows
#offset (rnd_offset), float, default 0.5, min 0, max 1, step 0.01
#rotate (rnd_rotate), float, default 0, min 0, max 180, step 0.1
#scale (rnd_scale), float, default 0.5, min 0, max 1, step 0.01 - The random scale applied to each image instance
#opacity (rnd_opacity), float, default 0, min 0, max 1, step 0.01 - The random greyscale value applied to each image instance
#variations, bool, default false, (disabled) - Check to tile variations of the input

# ========================= TRANSFORMS.GD =======================



#----------------------
#transform.mmg
#Translates, rotates and scales its input

#		"inputs": [
#			{
#				"default": "vec4($uv, 0.0, 1.0)",
#				"label": "",
#				"longdesc": "The input image to be transformed",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for translation along the X axis",
#				"name": "tx",
#				"shortdesc": "TranslateMap.x",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for translation along the Y axis",
#				"name": "ty",
#				"shortdesc": "TranslateMap.y",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for rotation",
#				"name": "r",
#				"shortdesc": "RotateMap",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for scaling along the X axis",
#				"name": "sx",
#				"shortdesc": "ScaleMap.x",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for scaling along the Y axis",
#				"name": "sy",
#				"shortdesc": "ScaleMap.y",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the transformed image",
#				"rgba": "$i(transform($uv, vec2($translate_x*(2.0*$tx($uv)-1.0), $translate_y*(2.0*$ty($uv)-1.0)), $rotate*0.01745329251*(2.0*$r($uv)-1.0), vec2($scale_x*(2.0*$sx($uv)-1.0), $scale_y*(2.0*$sy($uv)-1.0)), $repeat))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "2:Translate X:",
#				"longdesc": "The translation along the X axis",
#				"max": 1,
#				"min": -1,
#				"name": "translate_x",
#				"shortdesc": "Translate.x",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Translate Y:",
#				"longdesc": "The translation along the Y axis",
#				"max": 1,
#				"min": -1,
#				"name": "translate_y",
#				"shortdesc": "Translate.y",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Radius1.a",
#				"default": 0,
#				"label": "Rotate:",
#				"longdesc": "The rotation angle",
#				"max": 720,
#				"min": -720,
#				"name": "rotate",
#				"shortdesc": "Rotate",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Scale1.x",
#				"default": 1,
#				"label": "Scale X:",
#				"longdesc": "The scaling factor along the X axis",
#				"max": 50,
#				"min": 0,
#				"name": "scale_x",
#				"shortdesc": "Scale.x",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Scale1.y",
#				"default": 1,
#				"label": "Scale Y:",
#				"longdesc": "The scaling factor along the Y axis",
#				"max": 50,
#				"min": 0,
#				"name": "scale_y",
#				"shortdesc": "Scale.y",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Repeat:",
#				"longdesc": "Repeat the input if checked, clamps otherwise",
#				"name": "repeat",
#				"shortdesc": "Repeat",
#				"type": "boolean"
#			}
#		]

#----------------------
#transform2.mmg
#Translates, rotates and scales its input


#		"inputs": [
#			{
#				"default": "vec4($uv, 0.0, 1.0)",
#				"label": "",
#				"longdesc": "The input image to be transformed",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for translation along the X axis",
#				"name": "tx",
#				"shortdesc": "TranslateMap.x",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for translation along the Y axis",
#				"name": "ty",
#				"shortdesc": "TranslateMap.y",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for rotation",
#				"name": "r",
#				"shortdesc": "RotateMap",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for scaling along the X axis",
#				"name": "sx",
#				"shortdesc": "ScaleMap.x",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"label": "",
#				"longdesc": "An optional map for scaling along the Y axis",
#				"name": "sy",
#				"shortdesc": "ScaleMap.y",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the transformed image",
#				"rgba": "$i($mode(transform2($uv, vec2($translate_x*(2.0*$tx($uv)-1.0), $translate_y*(2.0*$ty($uv)-1.0)), $rotate*0.01745329251*(2.0*$r($uv)-1.0), vec2($scale_x*(2.0*$sx($uv)-1.0), $scale_y*(2.0*$sy($uv)-1.0)))))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "2:Translate X:",
#				"longdesc": "The translation along the X axis",
#				"max": 1,
#				"min": -1,
#				"name": "translate_x",
#				"shortdesc": "Translate.x",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Translate Y:",
#				"longdesc": "The translation along the Y axis",
#				"max": 1,
#				"min": -1,
#				"name": "translate_y",
#				"shortdesc": "Translate.y",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Radius1.a",
#				"default": 0,
#				"label": "Rotate:",
#				"longdesc": "The rotation angle",
#				"max": 720,
#				"min": -720,
#				"name": "rotate",
#				"shortdesc": "Rotate",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Scale1.x",
#				"default": 1,
#				"label": "Scale X:",
#				"longdesc": "The scaling factor along the X axis",
#				"max": 50,
#				"min": 0,
#				"name": "scale_x",
#				"shortdesc": "Scale.x",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Scale1.y",
#				"default": 1,
#				"label": "Scale Y:",
#				"longdesc": "The scaling factor along the Y axis",
#				"max": 50,
#				"min": 0,
#				"name": "scale_y",
#				"shortdesc": "Scale.y",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"default": 0,
#				"label": "Mode",
#				"longdesc": "Defines the behavior beyond the limits or the input image:\n- Clamp stretches the edges\n- Repeat tiles the input\n- Extend shows parts of the input that are beyond the edges",
#				"name": "mode",
#				"shortdesc": "Mode",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Clamp",
#						"value": "transform2_clamp"
#					},
#					{
#						"name": "Repeat",
#						"value": "fract"
#					},
#					{
#						"name": "Extend",
#						"value": ""
#					}
#				]
#			}
#		]

#----------------------
#translate.mmg
#Translates its input

#		"inputs": [
#			{
#				"default": "vec4($uv, 0.0, 1.0)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the translated image",
#				"rgba": "$i($uv-vec2($translate_x, $translate_y))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "Translate X:",
#				"longdesc": "The translation along the X axis",
#				"max": 1,
#				"min": -1,
#				"name": "translate_x",
#				"shortdesc": "Translate.x",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Translate Y:",
#				"longdesc": "The translation along the Y axis",
#				"max": 1,
#				"min": -1,
#				"name": "translate_y",
#				"shortdesc": "Translate.y",
#				"step": 0.005,
#				"type": "float"
#			}
#		],

#----------------------
#rotate.mmg
#Rotates its input

#		"inputs": [
#			{
#				"default": "vec4($uv, 0.0, 1.0)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the rotated image",
#				"rgba": "$i(rotate($uv, vec2(0.5+$cx, 0.5+$cy), $rotate*0.01745329251))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "Center X:",
#				"longdesc": "The position of the rotation center",
#				"max": 1,
#				"min": -1,
#				"name": "cx",
#				"shortdesc": "Center.x",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Center Y:",
#				"longdesc": "The position of the rotation center",
#				"max": 1,
#				"min": -1,
#				"name": "cy",
#				"shortdesc": "Center.y",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Radius1.a",
#				"default": 0,
#				"label": "Rotate:",
#				"longdesc": "The angle of the rotation",
#				"max": 720,
#				"min": -720,
#				"name": "rotate",
#				"shortdesc": "Angle",
#				"step": 0.005,
#				"type": "float"
#			}
#		],

#----------------------
#scale.mmg
#Scales its input

#		"inputs": [
#			{
#				"default": "vec4($uv, 0.0, 1.0)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the scaled image",
#				"rgba": "$i(scale($uv, vec2(0.5+$cx, 0.5+$cy), vec2($scale_x, $scale_y)))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "P1.x",
#				"default": 0,
#				"label": "Center X:",
#				"longdesc": "The position of the scale center",
#				"max": 1,
#				"min": -1,
#				"name": "cx",
#				"shortdesc": "Center.x",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "P1.y",
#				"default": 0,
#				"label": "Center Y:",
#				"longdesc": "The poisition of the scale center",
#				"max": 1,
#				"min": -1,
#				"name": "cy",
#				"shortdesc": "Center.y",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Scale1.x",
#				"default": 1,
#				"label": "Scale X:",
#				"longdesc": "The scale amount along the X axis",
#				"max": 50,
#				"min": 0,
#				"name": "scale_x",
#				"shortdesc": "Scale.x",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "Scale1.y",
#				"default": 1,
#				"label": "Scale Y:",
#				"longdesc": "The scale amount along the Y axis",
#				"max": 50,
#				"min": 0,
#				"name": "scale_y",
#				"shortdesc": "Scale.y",
#				"step": 0.005,
#				"type": "float"
#			}
#		],

#----------------------
#shear.mmg
#Performs a shear stress transform on its input

#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the transformed image",
#				"rgba": "$in($uv+$amount*($uv.yx-vec2($center))*vec2($direction))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 1,
#				"label": "",
#				"longdesc": "The direction of the shear transform (horizontal or vertical)",
#				"name": "direction",
#				"shortdesc": "Direction",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Horizontal",
#						"value": "1.0, 0.0"
#					},
#					{
#						"name": "Vertical",
#						"value": "0.0, 1.0"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The amount of the transform",
#				"max": 1,
#				"min": -1,
#				"name": "amount",
#				"shortdesc": "Amount",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The position of the shear center",
#				"max": 1,
#				"min": 0,
#				"name": "center",
#				"shortdesc": "Center",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#mirror.mmg
#Mirrors its input while applying an offset from the center

#		"inputs": [
#			{
#				"default": "vec4($uv, 0, 1)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the mirrored image",
#				"rgba": "$i(uvmirror_$direction($uv, $offset))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "The mirror direction (horizontal or vertical)",
#				"name": "direction",
#				"shortdesc": "Direction",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Horizontal",
#						"value": "h"
#					},
#					{
#						"name": "Vertical",
#						"value": "v"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The offset from the center",
#				"max": 1,
#				"min": 0,
#				"name": "offset",
#				"shortdesc": "Offset",
#				"step": 0.005,
#				"type": "float"
#			}
#		],

#----------------------
#kaleidoscope.mmg
#Replicated an angle of the input image several times around the center.

#		"inputs": [
#			{
#				"default": "vec4($uv, 0, 1)",
#				"label": "",
#				"longdesc": "The input image",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the transformed image",
#				"rgba": "$i(kal_rotate($uv, $count, $offset))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The number of replications of an angle of the input",
#				"max": 10,
#				"min": 2,
#				"name": "count",
#				"shortdesc": "Count",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The angular offset of the replicated angle of the input",
#				"max": 180,
#				"min": -180,
#				"name": "offset",
#				"shortdesc": "Offset",
#				"step": 0.1,
#				"type": "float"
#			}
#		],

#----------------------
#warp.mmg
#Warps its input according to a heightmap

#		"code": "vec2 $(name_uv)_slope = $(name)_slope($uv, $eps);\nvec2 $(name_uv)_warp = $mode;",
#		"global": "",
#		"inputs": [
#			{
#				"default": "vec4(sin($uv.x*20.0)*0.5+0.5, sin($uv.y*20.0)*0.5+0.5, 0, 1)",
#				"label": "",
#				"longdesc": "The input image to be warped",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			},
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"longdesc": "The height map whose slopes are used to deform the input",
#				"name": "d",
#				"shortdesc": "Height map",
#				"type": "f"
#			}
#		],
#		"instance": "vec2 $(name)_slope(vec2 uv, float epsilon) {\n\treturn vec2($d(fract(uv+vec2(epsilon, 0.0)))-$d(fract(uv-vec2(epsilon, 0.0))), $d(fract(uv+vec2(0.0, epsilon)))-$d(fract(uv-vec2(0.0, epsilon))));\n}",
#		"outputs": [
#			{
#				"longdesc": "Shows the warped image",
#				"rgba": "$in($uv+$amount*$(name_uv)_warp)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "Both warp modes extract their direction from the height map slopes:\n- Slope warp intensity only depends on the slope\n- Distance to top warp intensity depends on the slope and the distance to the top, and can be used to create mosaic-like patterns\n\nA Transform node with translate maps can produce effects similar to Slope Warp and is generally faster.",
#				"name": "mode",
#				"shortdesc": "Mode",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Slope",
#						"value": "$(name_uv)_slope"
#					},
#					{
#						"name": "Distance to top",
#						"value": "$(name_uv)_slope*(1.0-$d($uv))"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The strength of the warp effect",
#				"max": 1,
#				"min": 0,
#				"name": "amount",
#				"shortdesc": "Strength",
#				"step": 0.005,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The offset used to measure slopes",
#				"max": 0.2,
#				"min": 0.005,
#				"name": "eps",
#				"shortdesc": "Epsilon",
#				"step": 0.005,
#				"type": "float"
#			}
#		],

#----------------------
#warp2.mmg
#Warps its input according to a heightmap

#		"code": "vec2 $(name_uv)_slope = $(name)_slope($uv);\nvec2 $(name_uv)_warp = $mode;",
#		"inputs": [
#			{
#				"default": "vec4(sin($uv.x*20.0)*0.5+0.5, sin($uv.y*20.0)*0.5+0.5, 0, 1)",
#				"label": "",
#				"longdesc": "The input image to be warped",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			},
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"longdesc": "The height map whose slopes are used to deform the input",
#				"name": "d",
#				"shortdesc": "Height map",
#				"type": "f"
#			}
#		],
#		"instance": "vec2 $(name)_slope(vec2 uv) {\n    vec2 e = vec2(0.001, 0.0);\n    return 0.5*vec2($d(uv+e)-$d(uv-e), $d(uv+e.yx)-$d(uv-e.yx))/e.x;\n}",
#		"outputs": [
#			{
#				"longdesc": "Shows the warped image",
#				"rgba": "$in($uv+$amount*$(name_uv)_warp)",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "Both warp modes extract their direction from the height map slopes:\n- Slope warp intensity only depends on the slope\n- Distance to top warp intensity depends on the slope and the distance to the top, and can be used to create mosaic-like patterns\n\nA Transform node with translate maps can produce effects similar to Slope Warp and is generally faster.",
#				"name": "mode",
#				"shortdesc": "Mode",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Slope",
#						"value": "$(name_uv)_slope"
#					},
#					{
#						"name": "Distance to top",
#						"value": "$(name_uv)_slope*(1.0-$d($uv))"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The strength of the warp effect",
#				"max": 1,
#				"min": 0,
#				"name": "amount",
#				"shortdesc": "Strength",
#				"step": 0.005,
#				"type": "float"
#			}
#		],

#----------------------
#circle_map.mmg
#Maps its input into a circle

#		"inputs": [
#			{
#				"default": "vec4($uv, 0.0, 1.0)",
#				"label": "",
#				"longdesc": "The input image to be remapped",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the remapped image",
#				"rgba": "$in(vec2(fract($repeat*atan($uv.y-0.5, $uv.x-0.5)*0.15915494309), min(0.99999, 2.0/$radius*length($uv-vec2(0.5)))))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Radius",
#				"longdesc": "The radius of the circle where the input is mapped",
#				"max": 1.5,
#				"min": 0,
#				"name": "radius",
#				"shortdesc": "Radius",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Repeat",
#				"longdesc": "The number of repetitions of the input image around the circle",
#				"max": 16,
#				"min": 0,
#				"name": "repeat",
#				"shortdesc": "Repeat",
#				"step": 1,
#				"type": "float"
#			}
#		],

#----------------------
#custom_uv.mmg
#Remaps an Input image using a custom UV map.

#		"code": "vec3 $(name_uv)_map = $map($uv);\nfloat $(name_uv)_rnd =  float($seed)+$(name_uv)_map.z;\n",
#		"inputs": [
#			{
#				"default": "vec4(1.0)",
#				"label": "Input",
#				"longdesc": "The image or atlas of images to be remapped.",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgba"
#			},
#			{
#				"default": "vec3(1.0)",
#				"label": "UV",
#				"longdesc": "The custom UV map to be used for remapping.",
#				"name": "map",
#				"shortdesc": "Map",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the remapped image",
#				"rgba": "$in(get_from_tileset($inputs, $(name_uv)_rnd, custom_uv_transform($(name_uv)_map.xy, vec2($sx, $sy), $rotate*0.01745329251, $scale, vec2($(name_uv)_map.z, float($seed)))))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "Inputs",
#				"longdesc": "The input type of the node:\n- 1: single image\n- 4: atlas of 4 images\n- 16: atlas of 16 images\nAtlases can be created using the Tile2x2 node.",
#				"name": "inputs",
#				"shortdesc": "Inputs",
#				"type": "enum",
#				"values": [
#					{
#						"name": "1",
#						"value": "1.0"
#					},
#					{
#						"name": "4",
#						"value": "2.0"
#					},
#					{
#						"name": "16",
#						"value": "4.0"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Scale X",
#				"longdesc": "The scale of the input image along the X axis.",
#				"max": 5,
#				"min": 0,
#				"name": "sx",
#				"shortdesc": "Scale.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Scale Y",
#				"longdesc": "The scale of the input image along the Y axis.",
#				"max": 5,
#				"min": 0,
#				"name": "sy",
#				"shortdesc": "Scale.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rnd Rotate",
#				"longdesc": "The random rotation applied to each remapped instance.",
#				"max": 180,
#				"min": 0,
#				"name": "rotate",
#				"shortdesc": "RndRotate",
#				"step": 0.1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Rnd Scale",
#				"longdesc": "The random scale applied to each remapped instance.",
#				"max": 1,
#				"min": 0,
#				"name": "scale",
#				"shortdesc": "RndScale",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#splatter.mmg
#Spreads several occurences of an input image randomly.

#vec4 $(name_uv)_rch = splatter_$(name)($uv, int($count), vec2(float($seed)));

#vec4 splatter_$(name)(vec2 uv, int count, vec2 seed) {\n\t
#	float c = 0.0;\n\t
#	vec3 rc = vec3(0.0);\n\t
#	vec3 rc1;\n\t
#
#	for (int i = 0; i < count; ++i) {\n\t\t
#		seed = rand2(seed);\n\t\t
#		rc1 = rand3(seed);\n\t\t
#		float mask = $mask(fract(seed+vec2(0.5)));\n\t\t
#
#		if (mask > 0.01) {\n\t\t\t
#			vec2 pv = fract(uv - seed)-vec2(0.5);\n\t\t\t
#			seed = rand2(seed);\n\t\t\t
#			float angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;\n\t\t\t
#			float ca = cos(angle);\n\t\t\t
#			float sa = sin(angle);\n\t\t\t
#			pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t
#			pv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\t
#			pv /= vec2($scale_x, $scale_y);\n\t\t\t
#			pv += vec2(0.5);\n\t\t\t
#			seed = rand2(seed);\n\t\t\t
#			vec2 clamped_pv = clamp(pv, vec2(0.0), vec2(1.0));\n\t\t\t
#
#			if (pv.x != clamped_pv.x || pv.y != clamped_pv.y) {\n\t\t\t\t
#				continue;\n\t\t\t
#			}\n\t\t\t
#
#			$select_inputs\n\t\t\t
#
#			float c1 = $in.variation(pv, $variations ? seed.x : 0.0)*mask*(1.0-$value*seed.x);\n\t\t\t
#			c = max(c, c1);\n\t\t\t
#			rc = mix(rc, rc1, step(c, c1));\n\t\t
#		}\n\t
#	}\n\t
#
#	return vec4(rc, c);\n
#}

#Inputs:

#in, float, default: 0, - The input image or atlas of 4 or 16 input images
#Mask, float, default: 1, - The mask applied to the pattern

#Outputs:
#Output, float, Shows the generated pattern
#$(name_uv)_rch.a

#Instance map, rgb, Shows a random color for each instance of the input image
#$(name_uv)_rch.rgb

#select_inputs enum
#1,  " "
#4, "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#16, "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"

#Parameters:
#count, int, default 25, min 1, max 100, - The number of occurences of the input image
#select_inputs (Inputs), enum, default 0, values 1, 4, 16
#tile, Vector2, default 4, min:1, max:64, step:1 - The number of columns of the tiles pattern
#overlap, float, default 1, min 0, max 5, step 1 - The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.
#scale, Vector2, default 1, min:0, max:2, step:0.01 - "The scale of input images on the X axis
#rotate (rnd_rotate), float, default 0, min 0, max 180, step 0.1
#scale (rnd_scale), float, default 0, min 0, max 1, step 0.01 - The random scale applied to each image instance
#value (rnd_value), float, default 0, min 0, max 1, step 0.01

#----------------------
#splatter_color.mmg
#preads several occurences of an input image randomly.

#vec4 splatter_$(name)(vec2 uv, int count, vec2 seed) {\n\t
#	vec4 c = vec4(0.0);\n\t
#
#	for (int i = 0; i < count; ++i) {\n\t\t
#		seed = rand2(seed);\n\t\t
#		float mask = $mask(fract(seed+vec2(0.5)));\n\t\t
#
#		if (mask > 0.01) {\n\t\t\t
#			vec2 pv = fract(uv - seed)-vec2(0.5);\n\t\t\t
#			seed = rand2(seed);\n\t\t\t
#			float angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;\n\t\t\t
#			float ca = cos(angle);\n\t\t\t
#			float sa = sin(angle);\n\t\t\t
#			pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t
#			pv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\t
#			pv /= vec2($scale_x, $scale_y);\n\t\t\tpv += vec2(0.5);\n\t\t\t
#			seed = rand2(seed);\n\t\t\t
#
#			if (pv != clamp(pv, vec2(0.0), vec2(1.0))) {\n\t\t\t\t
#				continue;\n\t\t\t
#			}\n\t\t\t
#
#			$select_inputs\n\t\t\t
#
#			vec4 n = $in.variation(pv, $variations ? seed.x : 0.0);\n\t\t\t
#
#			float na = n.a*mask*(1.0-$opacity*seed.x);\n\t\t\t
#			float a = (1.0-c.a)*(1.0*na);\n\t\t\t
#			c = mix(c, n, na);\n\t\t
#		}\n\t
#	}\n\t
#
#	return c;\n
#}

#Inputs:

#in, rgba, default: 0, - The input image or atlas of 4 or 16 input images
#Mask, float, default: 1, - The mask applied to the pattern

#Outputs:
#Output, rgba, Shows the generated pattern
#splatter_$(name)($uv, int($count), vec2(float($seed)))

#select_inputs enum
#1,  " "
#4, "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#16, "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"

#Parameters:
#count, int, default 25, min 1, max 100, - The number of occurences of the input image
#select_inputs (Inputs), enum, default 0, values 1, 4, 16
#tile, Vector2, default 4, min:1, max:64, step:1 - The number of columns of the tiles pattern
#overlap, float, default 1, min 0, max 5, step 1 - The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.
#scale, Vector2, default 1, min:0, max:2, step:0.01 - "The scale of input images on the X axis
#rotate (rnd_rotate), float, default 0, min 0, max 180, step 0.1
#scale (rnd_scale), float, default 0, min 0, max 1, step 0.01 - The random scale applied to each image instance
#value (rnd_value), float, default 0, min 0, max 1, step 0.01
#variations bool

#----------------------
#circle_splatter.mmg
#Spreads several occurences of an input image in a circle or spiral pattern.

#vec4 $(name_uv)_rch = splatter_$(name)($uv, int($count), int($rings), vec2(float($seed)));

#vec4 splatter_$(name)(vec2 uv, int count, int rings, vec2 seed) {\n\t
#	float c = 0.0;\n\t
#	vec3 rc = vec3(0.0);\n\t
#	vec3 rc1;\n\t
#	seed = rand2(seed);\n\t
#
#	for (int i = 0; i < count; ++i) {\n\t\t
#		float a = -1.57079632679+6.28318530718*float(i)*$rings/float(count);\n\t\t
#		float rings_distance = ceil(float(i+1)*float(rings)/float(count))/float(rings);\n\t\t
#		float spiral_distance = float(i+1)/float(count);\n\t\t
#		vec2 pos = $radius*mix(rings_distance, spiral_distance, $spiral)*vec2(cos(a), sin(a));\n\t\t
#		float mask = $mask(fract(pos-vec2(0.5)));\n\t\t
#
#		if (mask > 0.01) {\n\t\t\t
#			vec2 pv = uv-0.5-pos;\n\t\t\t
#			rc1 = rand3(seed);\n\t\t\tseed = rand2(seed);\n\t\t\t
#			float angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251 + (a+1.57079632679) * $i_rotate;\n\t\t\t
#			float ca = cos(angle);\n\t\t\t
#			float sa = sin(angle);\n\t\t\t
#			pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t
#			pv /= mix(1.0, float(i+1)/float(count+1), $i_scale);\n\t\t\t
#			pv /= vec2($scale_x, $scale_y);\n\t\t\t
#			pv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\t
#			pv += vec2(0.5);\n\t\t\tseed = rand2(seed);\n\t\t\t
#
#			if (pv != clamp(pv, vec2(0.0), vec2(1.0))) {\n\t\t\t\t
#				continue;\n\t\t\t
#			}\n\t\t\t
#
#			$select_inputs\n\t\t\t
#
#			float c1 = $in(pv)*mask*(1.0-$value*seed.x);\n\t\t\t
#
#			c = max(c, c1);\n\t\t\trc = mix(rc, rc1, step(c, c1));\n\t\t
#		}\n\t
#	}\n\t
#
#	return vec4(rc, c);\n
#}


#Inputs:

#in, float, default: 0, - The input image or atlas of 4 or 16 input images
#Mask, float, default: 1, - The mask applied to the pattern

#Outputs:
#Output, float, Shows the generated pattern
#$(name_uv)_rch.rgb

#select_inputs enum
#1,  " "
#4, "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#16, "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"

#Parameters:
#count, int, default 10, min 1, max 256, - The number of occurences of the input image
#rings, int, default 1, min 1, max 16, - The number of occurences of the input image
#select_inputs (Inputs), enum, default 0, values 1, 4, 16
#scale, Vector2, default 1, min:0, max:2, step:0.01 - "The scale of input images on the X axis
#radius, float, default 0.4, min 0, max 0.5, step 0.01
#spiral, float, default 0, min 0, max 1, step 0.01
#i_rotate (inc_rotate), float, default 0, min 0, max 180, step 0.1
#i_scale (inc_scale), float, default 0, min 0, max 1, step 0.01
#rotate (rnd_rotate), float, default 0, min 0, max 180, step 0.1
#scale (rnd_scale), float, default 0, min 0, max 1, step 0.01 - The random scale applied to each image instance
#value (rnd_value), float, default 0, min 0, max 1, step 0.01

#----------------------
#warp_dilation.mmg

#{
#	"connections": [
#		{
#			"from": "warp_dilation",
#			"from_port": 0,
#			"to": "buffer_5",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_5",
#			"from_port": 0,
#			"to": "gen_outputs",
#			"to_port": 0
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 1,
#			"to": "buffer_6",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_6",
#			"from_port": 0,
#			"to": "warp_dilation",
#			"to_port": 1
#		},
#		{
#			"from": "gen_inputs",
#			"from_port": 0,
#			"to": "buffer_7",
#			"to_port": 0
#		},
#		{
#			"from": "buffer_7",
#			"from_port": 0,
#			"to": "warp_dilation",
#			"to_port": 0
#		}
#	],
#	"label": "Warp Dilation",
#	"longdesc": "",
#	"name": "warp_dilation",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"nodes": [
#		{
#			"name": "buffer_5",
#			"node_position": {
#				"x": -387.923584,
#				"y": -38
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "buffer_6",
#			"node_position": {
#				"x": -636.189514,
#				"y": -90.757477
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "buffer_7",
#			"node_position": {
#				"x": -635.189514,
#				"y": -199.757477
#			},
#			"parameters": {
#				"lod": 0,
#				"size": 9
#			},
#			"type": "buffer"
#		},
#		{
#			"name": "warp_dilation",
#			"node_position": {
#				"x": -404.125,
#				"y": -172.25
#			},
#			"parameters": {
#				"a": 0,
#				"d": 0.5,
#				"mode": 0,
#				"s": 9
#			},
#			"type": "warp_dilation_nobuf"
#		},
#		{
#			"name": "gen_inputs",
#			"node_position": {
#				"x": -1127.189453,
#				"y": -144.691238
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"name": "port1",
#					"type": "f"
#				},
#				{
#					"group_size": 0,
#					"name": "port0",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_outputs",
#			"node_position": {
#				"x": -70.923584,
#				"y": -122.691238
#			},
#			"parameters": {
#
#			},
#			"ports": [
#				{
#					"group_size": 0,
#					"name": "port0",
#					"type": "f"
#				}
#			],
#			"type": "ios"
#		},
#		{
#			"name": "gen_parameters",
#			"node_position": {
#				"x": -463.856934,
#				"y": -398.757477
#			},
#			"parameters": {
#				"a": 0,
#				"d": 0.5,
#				"mode": 0,
#				"s": 9
#			},
#			"type": "remote",
#			"widgets": [
#				{
#					"label": "Mode",
#					"linked_widgets": [
#						{
#							"node": "warp_dilation",
#							"widget": "mode"
#						}
#					],
#					"name": "mode",
#					"type": "linked_control"
#				},
#				{
#					"label": "Resolution",
#					"linked_widgets": [
#						{
#							"node": "warp_dilation",
#							"widget": "s"
#						},
#						{
#							"node": "buffer_7",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_6",
#							"widget": "size"
#						},
#						{
#							"node": "buffer_5",
#							"widget": "size"
#						}
#					],
#					"name": "s",
#					"type": "linked_control"
#				},
#				{
#					"label": "Distance",
#					"linked_widgets": [
#						{
#							"node": "warp_dilation",
#							"widget": "d"
#						}
#					],
#					"name": "d",
#					"type": "linked_control"
#				},
#				{
#					"label": "Attenuation",
#					"linked_widgets": [
#						{
#							"node": "warp_dilation",
#							"widget": "a"
#						}
#					],
#					"name": "a",
#					"type": "linked_control"
#				}
#			]
#		}
#	],
#	"parameters": {
#		"a": 0,
#		"d": 0.5,
#		"mode": 0,
#		"s": 9
#	},
#	"shortdesc": "",
#	"type": "graph"
#}

#----------------------
#warp_dilation_nobuf.mmg

#{
#	"name": "warp_dilation",
#	"node_position": {
#		"x": 0,
#		"y": 0
#	},
#	"parameters": {
#		"a": 0,
#		"d": 0.5,
#		"mode": 0,
#		"s": 9
#	},
#	"shader_model": {
#		"code": "",
#		"global": "",
#		"inputs": [
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"longdesc": "The input image",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "f"
#			},
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"longdesc": "The height map whose contours or slopes are followed",
#				"name": "hm",
#				"shortdesc": "Height map",
#				"type": "f"
#			}
#		],
#		"instance": "vec2 $(name)_slope(vec2 uv, float epsilon) {\n\tfloat dx = $hm(fract(uv+vec2(epsilon, 0.0)))-$hm(fract(uv-vec2(epsilon, 0.0)));\n\tfloat dy = $hm(fract(uv+vec2(0.0, epsilon)))-$hm(fract(uv-vec2(0.0, epsilon)));\n\treturn vec2($mode);\n}\n\nfloat $(name)_dilate(vec2 uv, vec2 slope) {\n\tfloat e = 1.0/$s;\n\tfloat v = 0.0;\n\tfor (float x = 0.0; x <= $d; x += e) {\n\t\tv = max(v, $in(fract(uv))*(1.0-x/$d*$a));\n\t\tuv += e*normalize($(name)_slope(uv, 0.0001));\n\t}\n\treturn v;\n}",
#		"longdesc": "Dilates its input following the contours or slope of an input heightmap",
#		"name": "Warp Dilation",
#		"outputs": [
#			{
#				"f": "$(name)_dilate($uv, normalize($(name)_slope($uv, 0.001)))",
#				"longdesc": "The dilated image",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "Mode",
#				"longdesc": "The dilate mode (clockwise contour, counter clockwise contour or slope)",
#				"name": "mode",
#				"shortdesc": "Mode",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Contour (cw)",
#						"value": "-dy,dx"
#					},
#					{
#						"name": "Contour (ccw)",
#						"value": "dy, -dx"
#					},
#					{
#						"name": "Slope",
#						"value": "dx,dy"
#					}
#				]
#			},
#			{
#				"default": 9,
#				"first": 6,
#				"label": "Resolution",
#				"last": 12,
#				"longdesc": "The resolution at which the contours or slopes are followed (higher values will be more precise but rendering time will be higher)",
#				"name": "s",
#				"shortdesc": "Resolution",
#				"type": "size"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Distance",
#				"longdesc": "The distance along which the contours or slopes are followed",
#				"max": 0.5,
#				"min": 0,
#				"name": "d",
#				"shortdesc": "Distance",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Attenuation",
#				"longdesc": "The attenuation applied along the path",
#				"max": 1,
#				"min": 0,
#				"name": "a",
#				"shortdesc": "Attenuation",
#				"step": 0.01,
#				"type": "float"
#			}
#		],
#		"shortdesc": "Warp Dilation"
#	},
#	"type": "shader"
#}

#----------------------
#repeat.mmg
#Translates, rotates and scales its input

#		"inputs": [
#			{
#				"default": "vec4($uv, 0.0, 1.0)",
#				"label": "",
#				"longdesc": "The input image to be transformed",
#				"name": "i",
#				"shortdesc": "Input",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the transformed image",
#				"rgba": "$i(fract($uv))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],

#----------------------
#remap.mmg
#The remapped image map

#		"code": "float $(name_uv)_x = $in($uv)*($max-$min);",
#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The greyscale input map",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "f"
#			}
#		],
#		"outputs": [
#			{
#				"f": "$min+$(name_uv)_x-mod($(name_uv)_x, max($step, 0.00000001))",
#				"longdesc": "The remapped image map",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Min",
#				"longdesc": "The value generated for black areas of the input",
#				"max": 10,
#				"min": -10,
#				"name": "min",
#				"shortdesc": "Min",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Max",
#				"longdesc": "The value generated for white areas of the input",
#				"max": 10,
#				"min": -10,
#				"name": "max",
#				"shortdesc": "Max",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Step",
#				"longdesc": "The step between generated values",
#				"max": 1,
#				"min": 0,
#				"name": "step",
#				"shortdesc": "Step",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#height_to_angle.mmg
#Generates an angle map to be used by Advances Tiler nodes from a heightmap

#		"inputs": [
#			{
#				"default": "0.0",
#				"function": true,
#				"label": "",
#				"longdesc": "The input heightmap",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "f"
#			}
#		],
#		"instance": "float $(name)_fct(vec2 uv, float epsilon) {\n\tvec3 e = vec3(epsilon, -epsilon, 0);\n\tvec2 rv = vec2(1.0, -1.0)*$in(uv+e.xy);\n\trv += vec2(-1.0, 1.0)*$in(uv-e.xy);\n\trv += vec2(1.0, 1.0)*$in(uv+e.xx);\n\trv += vec2(-1.0, -1.0)*$in(uv-e.xx);\n\trv += vec2(2.0, 0.0)*$in(uv+e.xz);\n\trv += vec2(-2.0, 0.0)*$in(uv-e.xz);\n\trv += vec2(0.0, 2.0)*$in(uv+e.zx);\n\trv += vec2(0.0, -2.0)*$in(uv-e.zx);\n\treturn atan(rv.y, rv.x)/3.141592;\n}",
#		"outputs": [
#			{
#				"f": "$(name)_fct($uv, 0.0001)+$angle/180.0",
#				"longdesc": "The generated angle map. Values are between -1 and 1 and the corresponding Advanced Tiler parameter (Rotate) must be set to 180.",
#				"shortdesc": "Output",
#				"type": "f"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0,
#				"label": "",
#				"longdesc": "The offset angle applied to the generated map",
#				"max": 180,
#				"min": -180,
#				"name": "angle",
#				"shortdesc": "Angle",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#vec2 transform(vec2 uv, vec2 translate, float rotate, vec2 scale, bool repeat) {\n \t
#	vec2 rv;\n\t
#	uv -= translate;\n\t
#	uv -= vec2(0.5);\n\t
#	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;\n\t
#	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;\n\t
#	rv /= scale;\n\t
#	rv += vec2(0.5);\n    
#
#	if (repeat) {\n\t\t
#		return fract(rv);\n\t
#	} else {\n\t\t
#		return clamp(rv, vec2(0.0), vec2(1.0));\n\t
#	}\t\n
#}

#static func transform(uv : Vector2, translate : Vector2, rotate : float, scale : Vector2, repeat : bool) -> Vector2:
#	var rv : Vector2 = Vector2()
#	uv -= translate
#	uv -= Vector2(0.5, 0.5)
#	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y
#	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y
#	rv /= scale
#	rv += Vector2(0.5, 0.5)
#
#	if (repeat):
#		return fractv2(rv)
#	else:
#		return clampv2(rv, Vector2(0, 0), Vector2(1, 1))

#vec2 transform2_clamp(vec2 uv) {\n\t
#	return clamp(uv, vec2(0.0), vec2(1.0));\n
#}

static func transform2_clamp(uv : Vector2) -> Vector2:
	return clampv2(uv, Vector2(0, 0), Vector2(1, 1))

#vec2 transform2(vec2 uv, vec2 translate, float rotate, vec2 scale) {\n \t
#	vec2 rv;\n\t
#	uv -= translate;\n\t
#	uv -= vec2(0.5);\n\t
#	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;\n\t
#	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;\n\t
#	rv /= scale;\n\t
#	rv += vec2(0.5);\n\t
#	return rv;\t\n
#}

static func transform2(uv : Vector2, translate : Vector2, rotate : float, scale : Vector2) -> Vector2:
	var rv : Vector2 = Vector2()
	uv -= translate
	uv -= Vector2(0.5, 0.5)
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y
	rv /= scale
	rv += Vector2(0.5, 0.5)
	return rv

#vec2 rotate(vec2 uv, vec2 center, float rotate) {\n \t
#	vec2 rv;\n\t
#	uv -= center;\n\t
#	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;\n\t
#	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;\n\t
#	rv += center;\n    
#	return rv;\t\n
#}

static func rotate(uv : Vector2, center : Vector2, rotate : float) -> Vector2:
	var rv : Vector2 = Vector2()
	uv -= center
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y
	rv += center
	return rv

#vec2 scale(vec2 uv, vec2 center, vec2 scale) {\n\t
#	uv -= center;\n\t
#	uv /= scale;\n\t
#	uv += center;\n    
#	return uv;\n
#}

static func scale(uv : Vector2, center : Vector2, scale : Vector2) -> Vector2:
	uv -= center
	uv /= scale
	uv += center
	return uv

#vec2 uvmirror_h(vec2 uv, float offset) {\n\t
#	return vec2(max(0, abs(uv.x-0.5)-0.5*offset)+0.5, uv.y);
#}

static func uvmirror_h(uv : Vector2, offset : float) -> Vector2:
	return Vector2(max(0, abs(uv.x - 0.5) - 0.5 * offset)+0.5, uv.y)

#vec2 uvmirror_v(vec2 uv, float offset) {\n\t
#	return vec2(uv.x, max(0, abs(uv.y-0.5)-0.5*offset)+0.5);\n
#}

static func uvmirror_v(uv : Vector2, offset : float) -> Vector2:
	return Vector2(uv.x, max(0, abs(uv.y - 0.5) - 0.5 * offset) + 0.5)

#vec2 kal_rotate(vec2 uv, float count, float offset) {\n\t
#	float pi = 3.14159265359;\n\t
#	offset *= pi/180.0;\n\t
#	offset += pi*(1.0/count+0.5);\n\t
#	uv -= vec2(0.5);\n\t
#
#	float l = length(uv);\n\t
#	float a = mod(atan(uv.y, uv.x)+offset, 2.0*pi/count)-offset;\n\t
#
#	return vec2(0.5)+l*vec2(cos(a), sin(a));\n
#}

static func kal_rotate(uv : Vector2, count : float, offset : float) -> Vector2:
	var pi : float = 3.14159265359
	offset *= pi / 180.0
	offset += pi * (1.0/ count + 0.5)
	uv -= Vector2(0.5, 0.5)

	var l : float = uv.length()
	var a : float = modf(atan2(uv.y, uv.x) + offset, 2.0 * pi / count) - offset

	return Vector2(0.5, 0.5) + l * Vector2(cos(a), sin(a))

#vec2 get_from_tileset(float count, float seed, vec2 uv) {\n\t
#	return clamp((uv+floor(rand2(vec2(seed))*count))/count, vec2(0.0), vec2(1.0));\n
#}

static func get_from_tileset(count : float, pseed : float, uv : Vector2) -> Vector2:
	return clampv2((uv + floorv2(rand2(Vector2(pseed, pseed))*count))/count, Vector2(0, 0), Vector2(1, 1))

#vec2 custom_uv_transform(vec2 uv, vec2 cst_scale, float rnd_rotate, float rnd_scale, vec2 seed) {\n\t
#	seed = rand2(seed);\n\t
#	uv -= vec2(0.5);\n\t
#	float angle = (seed.x * 2.0 - 1.0) * rnd_rotate;\n\t
#	float ca = cos(angle);\n\t
#	float sa = sin(angle);\n\t
#	uv = vec2(ca*uv.x+sa*uv.y, -sa*uv.x+ca*uv.y);\n\t
#	uv *= (seed.y-0.5)*2.0*rnd_scale+1.0;\n\t
#	uv /= cst_scale;\n\t
#	uv += vec2(0.5);\n\t
#
#	return uv;\n
#}

static func custom_uv_transform(uv : Vector2, cst_scale : Vector2, rnd_rotate : float, rnd_scale : float, pseed : Vector2) -> Vector2:
	pseed = rand2(pseed)
	uv -= Vector2(0.5, 0.5)
	var angle : float = (pseed.x * 2.0 - 1.0) * rnd_rotate
	var ca : float = cos(angle)
	var sa : float = sin(angle)
	uv = Vector2(ca * uv.x + sa * uv.y, -sa * uv.x + ca * uv.y)
	uv *= (pseed.y-0.5)*2.0*rnd_scale+1.0
	uv /= cst_scale
	uv += Vector2(0.5, 0.5)

	return uv











