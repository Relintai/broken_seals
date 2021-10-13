tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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

#		"code": "vec4 $(name_uv)_rch = splatter_$(name)($uv, int($count), vec2(float($seed)));",
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
#			}
#		],
#		"instance": "vec4 splatter_$(name)(vec2 uv, int count, vec2 seed) {\n\tfloat c = 0.0;\n\tvec3 rc = vec3(0.0);\n\tvec3 rc1;\n\tfor (int i = 0; i < count; ++i) {\n\t\tseed = rand2(seed);\n\t\trc1 = rand3(seed);\n\t\tfloat mask = $mask(fract(seed+vec2(0.5)));\n\t\tif (mask > 0.01) {\n\t\t\tvec2 pv = fract(uv - seed)-vec2(0.5);\n\t\t\tseed = rand2(seed);\n\t\t\tfloat angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;\n\t\t\tfloat ca = cos(angle);\n\t\t\tfloat sa = sin(angle);\n\t\t\tpv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\tpv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\tpv /= vec2($scale_x, $scale_y);\n\t\t\tpv += vec2(0.5);\n\t\t\tseed = rand2(seed);\n\t\t\tvec2 clamped_pv = clamp(pv, vec2(0.0), vec2(1.0));\n\t\t\tif (pv.x != clamped_pv.x || pv.y != clamped_pv.y) {\n\t\t\t\tcontinue;\n\t\t\t}\n\t\t\t$select_inputs\n\t\t\tfloat c1 = $in.variation(pv, $variations ? seed.x : 0.0)*mask*(1.0-$value*seed.x);\n\t\t\tc = max(c, c1);\n\t\t\trc = mix(rc, rc1, step(c, c1));\n\t\t}\n\t}\n\treturn vec4(rc, c);\n}\n",
#		"outputs": [
#			{
#				"f": "$(name_uv)_rch.a",
#				"longdesc": "Shows the generated pattern",
#				"shortdesc": "Output",
#				"type": "f"
#			},
#			{
#				"longdesc": "Shows a random color for each instance of the input image",
#				"rgb": "$(name_uv)_rch.rgb",
#				"shortdesc": "Instance map",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 10,
#				"label": "Count",
#				"longdesc": "The number of occurences of the input image",
#				"max": 100,
#				"min": 1,
#				"name": "count",
#				"shortdesc": "Count",
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
#				"control": "None",
#				"default": 0,
#				"label": "Rnd Rotate",
#				"longdesc": "The random rotation applied to each image instance",
#				"max": 180,
#				"min": 0,
#				"name": "rotate",
#				"shortdesc": "RndRotate",
#				"step": 0.1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rnd Scale",
#				"longdesc": "The random scale applied to each image instance",
#				"max": 1,
#				"min": 0,
#				"name": "scale",
#				"shortdesc": "RndScale",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Rnd Value",
#				"longdesc": "The random greyscale value applied to each image instance",
#				"max": 1,
#				"min": 0,
#				"name": "value",
#				"shortdesc": "RndValue",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Variations",
#				"longdesc": "Check to splat variations of the input",
#				"name": "variations",
#				"shortdesc": "Variations",
#				"type": "boolean"
#			}
#		]

#----------------------
#splatter_color.mmg
#preads several occurences of an input image randomly.

#		"inputs": [
#			{
#				"default": "vec4(0.0, 0.0, 0.0, 0.0)",
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
#			}
#		],
#		"instance": "vec4 splatter_$(name)(vec2 uv, int count, vec2 seed) {\n\tvec4 c = vec4(0.0);\n\tfor (int i = 0; i < count; ++i) {\n\t\tseed = rand2(seed);\n\t\tfloat mask = $mask(fract(seed+vec2(0.5)));\n\t\tif (mask > 0.01) {\n\t\t\tvec2 pv = fract(uv - seed)-vec2(0.5);\n\t\t\tseed = rand2(seed);\n\t\t\tfloat angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;\n\t\t\tfloat ca = cos(angle);\n\t\t\tfloat sa = sin(angle);\n\t\t\tpv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\tpv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\tpv /= vec2($scale_x, $scale_y);\n\t\t\tpv += vec2(0.5);\n\t\t\tseed = rand2(seed);\n\t\t\tif (pv != clamp(pv, vec2(0.0), vec2(1.0))) {\n\t\t\t\tcontinue;\n\t\t\t}\n\t\t\t$select_inputs\n\t\t\tvec4 n = $in.variation(pv, $variations ? seed.x : 0.0);\n\t\t\tfloat na = n.a*mask*(1.0-$opacity*seed.x);\n\t\t\tfloat a = (1.0-c.a)*(1.0*na);\n\t\t\tc = mix(c, n, na);\n\t\t}\n\t}\n\treturn c;\n}\n",
#		"outputs": [
#			{
#				"longdesc": "Shows the generated pattern",
#				"rgba": "splatter_$(name)($uv, int($count), vec2(float($seed)))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 10,
#				"label": "Count",
#				"longdesc": "The number of occurences of the input image",
#				"max": 100,
#				"min": 1,
#				"name": "count",
#				"shortdesc": "Count",
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
#				"control": "None",
#				"default": 0,
#				"label": "Rnd Rotate",
#				"longdesc": "The random rotation applied to each image instance",
#				"max": 180,
#				"min": 0,
#				"name": "rotate",
#				"shortdesc": "RndRotate",
#				"step": 0.1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rnd Scale",
#				"longdesc": "The random scale applied to each image instance",
#				"max": 1,
#				"min": 0,
#				"name": "scale",
#				"shortdesc": "RndScale",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Rnd Opacity",
#				"longdesc": "The random opacity applied to each image instance",
#				"max": 1,
#				"min": 0,
#				"name": "opacity",
#				"shortdesc": "RndOpacity",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"default": false,
#				"label": "Variations",
#				"longdesc": "Check to splat variations of the input",
#				"name": "variations",
#				"shortdesc": "Variations",
#				"type": "boolean"
#			}
#		]

#----------------------
#circle_splatter.mmg
#Spreads several occurences of an input image in a circle or spiral pattern.

#		"code": "vec4 $(name_uv)_rch = splatter_$(name)($uv, int($count), int($rings), vec2(float($seed)));",
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
#			}
#		],
#		"instance": "vec4 splatter_$(name)(vec2 uv, int count, int rings, vec2 seed) {\n\tfloat c = 0.0;\n\tvec3 rc = vec3(0.0);\n\tvec3 rc1;\n\tseed = rand2(seed);\n\tfor (int i = 0; i < count; ++i) {\n\t\tfloat a = -1.57079632679+6.28318530718*float(i)*$rings/float(count);\n\t\tfloat rings_distance = ceil(float(i+1)*float(rings)/float(count))/float(rings);\n\t\tfloat spiral_distance = float(i+1)/float(count);\n\t\tvec2 pos = $radius*mix(rings_distance, spiral_distance, $spiral)*vec2(cos(a), sin(a));\n\t\tfloat mask = $mask(fract(pos-vec2(0.5)));\n\t\tif (mask > 0.01) {\n\t\t\tvec2 pv = uv-0.5-pos;\n\t\t\trc1 = rand3(seed);\n\t\t\tseed = rand2(seed);\n\t\t\tfloat angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251 + (a+1.57079632679) * $i_rotate;\n\t\t\tfloat ca = cos(angle);\n\t\t\tfloat sa = sin(angle);\n\t\t\tpv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\tpv /= mix(1.0, float(i+1)/float(count+1), $i_scale);\n\t\t\tpv /= vec2($scale_x, $scale_y);\n\t\t\tpv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\tpv += vec2(0.5);\n\t\t\tseed = rand2(seed);\n\t\t\tif (pv != clamp(pv, vec2(0.0), vec2(1.0))) {\n\t\t\t\tcontinue;\n\t\t\t}\n\t\t\t$select_inputs\n\t\t\tfloat c1 = $in(pv)*mask*(1.0-$value*seed.x);\n\t\t\tc = max(c, c1);\n\t\t\trc = mix(rc, rc1, step(c, c1));\n\t\t}\n\t}\n\treturn vec4(rc, c);\n}\n",
#		"outputs": [
#			{
#				"f": "$(name_uv)_rch.a",
#				"longdesc": "Shows the generated pattern",
#				"shortdesc": "Output",
#				"type": "f"
#			},
#			{
#				"longdesc": "Shows a random color for each instance of the input image",
#				"rgb": "$(name_uv)_rch.rgb",
#				"shortdesc": "Instance map",
#				"type": "rgb"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 10,
#				"label": "Count",
#				"longdesc": "The number of occurences of the input image",
#				"max": 256,
#				"min": 1,
#				"name": "count",
#				"shortdesc": "Count",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Rings",
#				"longdesc": "The number of rings of the circle pattern",
#				"max": 16,
#				"min": 1,
#				"name": "rings",
#				"shortdesc": "Rings",
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
#				"control": "None",
#				"default": 0.25,
#				"label": "Radius",
#				"longdesc": "The radius of the outer circle pattern",
#				"max": 0.5,
#				"min": 0,
#				"name": "radius",
#				"shortdesc": "Radius",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Spiral",
#				"longdesc": "The type of pattern:\n- 0: circles\n- 1: spiral",
#				"max": 1,
#				"min": 0,
#				"name": "spiral",
#				"shortdesc": "Spiral",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Inc Rotate",
#				"longdesc": "The rotate increment along the pattern",
#				"max": 1,
#				"min": 0,
#				"name": "i_rotate",
#				"shortdesc": "IncRotate",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Inc Scale",
#				"longdesc": "The scale increment of the pattern",
#				"max": 1,
#				"min": 0,
#				"name": "i_scale",
#				"shortdesc": "IncScale",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rnd Rotate",
#				"longdesc": "The random rotation applied to each image instance",
#				"max": 180,
#				"min": 0,
#				"name": "rotate",
#				"shortdesc": "RndRotate",
#				"step": 0.1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rnd Scale",
#				"longdesc": "The random scale applied to each image instance",
#				"max": 1,
#				"min": 0,
#				"name": "scale",
#				"shortdesc": "RndScale",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Rnd Value",
#				"longdesc": "The random greyscale value applied to each image instance",
#				"max": 1,
#				"min": 0,
#				"name": "value",
#				"shortdesc": "RndValue",
#				"step": 0.01,
#				"type": "float"
#			}
#		]

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


#vec2 transform2_clamp(vec2 uv) {\n\t
#	return clamp(uv, vec2(0.0), vec2(1.0));\n
#}
	
#vec2 transform2(vec2 uv, vec2 translate, float rotate, vec2 scale) {\n \t
#	vec2 rv;\n\tuv -= translate;\n\t
#	uv -= vec2(0.5);\n\t
#	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;\n\t
#	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;\n\t
#	rv /= scale;\n\t
#	rv += vec2(0.5);\n\t
#	return rv;\t\n
#}

#vec2 rotate(vec2 uv, vec2 center, float rotate) {\n \t
#	vec2 rv;\n\t
#	uv -= center;\n\t
#	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;\n\t
#	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;\n\t
#	rv += center;\n    
#	return rv;\t\n
#}

#vec2 scale(vec2 uv, vec2 center, vec2 scale) {\n\t
#	uv -= center;\n\t
#	uv /= scale;\n\t
#	uv += center;\n    
#	return uv;\n
#}

#vec2 uvmirror_v(vec2 uv, float offset) {\n\t
#	return vec2(uv.x, max(0, abs(uv.y-0.5)-0.5*offset)+0.5);\n
#}

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


#vec2 get_from_tileset(float count, float seed, vec2 uv) {\n\t
#	return clamp((uv+floor(rand2(vec2(seed))*count))/count, vec2(0.0), vec2(1.0));\n
#}

#vec2 custom_uv_transform(vec2 uv, vec2 cst_scale, float rnd_rotate, float rnd_scale, vec2 seed) {\n\t
#	seed = rand2(seed);\n\tuv -= vec2(0.5);\n\t
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



