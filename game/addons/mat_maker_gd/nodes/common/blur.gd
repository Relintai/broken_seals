tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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

