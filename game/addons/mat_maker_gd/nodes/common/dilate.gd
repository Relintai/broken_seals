tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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

