tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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
		
