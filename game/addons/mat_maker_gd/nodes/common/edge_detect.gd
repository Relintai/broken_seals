tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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
		
