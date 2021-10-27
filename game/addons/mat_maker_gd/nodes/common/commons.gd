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
