tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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
		uv = Commons.floorv2(uv * s) / s
		var f : float = 1.0 / s
		return Color(uv.x, uv.y, f, f)

#vec3 fill_to_uv_stretch(vec2 coord, vec4 bb, float seed) {
#	vec2 uv_islands = fract(coord-bb.xy)/bb.zw;
#	float random_value = rand(vec2(seed)+bb.xy+bb.zw);
#	return vec3(uv_islands, random_value);
#}

static func fill_to_uv_stretch(coord : Vector2, bb : Color, pseed : float) -> Vector3:
	var uv_islands : Vector2 = Commons.fractv2(coord - Vector2(bb.r, bb.g)) / Vector2(bb.b, bb.a)
	var random_value : float = Commons.rand(Vector2(pseed, pseed) + Vector2(bb.r, bb.g) + Vector2(bb.b, bb.a))
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
		uv_islands = Commons.fractv2(adjusted_coord - Vector2(bb.r, bb.g)) / Vector2(bb.b, bb.b)
	else:
		var adjusted_coord : Vector2 = coord + Vector2((bb.a - bb.b) / 2.0, 0.0);
		uv_islands = Commons.fractv2(adjusted_coord - Vector2(bb.r, bb.g)) / Vector2(bb.a, bb.a)

	var random_value : float = Commons.rand(Vector2(pseed, pseed) + Vector2(bb.r, bb.g) + Vector2(bb.b, bb.a))
	return Vector3(uv_islands.x, uv_islands.y, random_value)
