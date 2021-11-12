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

static func transform(uv : Vector2, translate : Vector2, rotate : float, scale : Vector2, repeat : bool) -> Vector2:
	var rv : Vector2 = Vector2()
	uv -= translate
	uv -= Vector2(0.5, 0.5)
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y
	rv /= scale
	rv += Vector2(0.5, 0.5)

	if (repeat):
		return Commons.fractv2(rv)
	else:
		return Commons.clampv2(rv, Vector2(0, 0), Vector2(1, 1))

#vec2 transform2_clamp(vec2 uv) {\n\t
#	return clamp(uv, vec2(0.0), vec2(1.0));\n
#}

static func transform2_clamp(uv : Vector2) -> Vector2:
	return Commons.clampv2(uv, Vector2(0, 0), Vector2(1, 1))

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
	var a : float = Commons.modf(atan2(uv.y, uv.x) + offset, 2.0 * pi / count) - offset

	return Vector2(0.5, 0.5) + l * Vector2(cos(a), sin(a))

#vec2 get_from_tileset(float count, float seed, vec2 uv) {\n\t
#	return clamp((uv+floor(rand2(vec2(seed))*count))/count, vec2(0.0), vec2(1.0));\n
#}

static func get_from_tileset(count : float, pseed : float, uv : Vector2) -> Vector2:
	return Commons.clampv2((uv + Commons.floorv2(Commons.rand2(Vector2(pseed, pseed))*count))/count, Vector2(0, 0), Vector2(1, 1))

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
	pseed = Commons.rand2(pseed)
	uv -= Vector2(0.5, 0.5)
	var angle : float = (pseed.x * 2.0 - 1.0) * rnd_rotate
	var ca : float = cos(angle)
	var sa : float = sin(angle)
	uv = Vector2(ca * uv.x + sa * uv.y, -sa * uv.x + ca * uv.y)
	uv *= (pseed.y-0.5)*2.0*rnd_scale+1.0
	uv /= cst_scale
	uv += Vector2(0.5, 0.5)

	return uv
