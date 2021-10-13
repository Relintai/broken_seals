tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

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

