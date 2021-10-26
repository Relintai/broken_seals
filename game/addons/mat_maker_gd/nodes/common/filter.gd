tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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
	
	var p : Vector3 = Commons.absv3(Commons.fractv3(Vector3(c.x, c.x, c.x) + Vector3(K.r, K.g, K.b)) * 6.0 - Vector3(K.a, K.a, K.a));
	
	return c.z * lerp(Vector3(K.r, K.r, K.r), Commons.clampv3(p - Vector3(K.r, K.r, K.r), Vector3(), Vector3(1, 1, 1)), c.y);

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
	
	var v : Vector3 = Commons.clampv3(cv, Vector3(), Vector3(1, 1, 1))
	
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
	if (Commons.rand2(uv) < Vector2(opacity, opacity)):
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
	return opacity * Commons.maxv3(c1, c2) + (1.0 - opacity) * c2

#vec3 blend_darken(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*min(c1, c2) + (1.0-opacity)*c2;\n
#}

static func blend_darken(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * Commons.minv3(c1, c2) + (1.0 - opacity) * c2

#vec3 blend_difference(vec2 uv, vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;\n
#}

static func blend_difference(uv : Vector2, c1 : Vector3, c2 : Vector3, opacity : float) -> Vector3:
	return opacity * Commons.clampv3(c2 - c1, Vector3(), Vector3(1, 1, 1)) + (1.0 - opacity) * c2

#vec4 adjust_levels(vec4 input, vec4 in_min, vec4 in_mid, vec4 in_max, vec4 out_min, vec4 out_max) {\n\t
#	input = clamp((input-in_min)/(in_max-in_min), 0.0, 1.0);\n\t
#	in_mid = (in_mid-in_min)/(in_max-in_min);\n\t
#	vec4 dark = step(in_mid, input);\n\t
#
#	input = 0.5*mix(input/(in_mid), 1.0+(input-in_mid)/(1.0-in_mid), dark);\n\t
#	return out_min+input*(out_max-out_min);\n
#}

