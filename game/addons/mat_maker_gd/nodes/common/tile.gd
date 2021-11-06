tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#----------------------
#tile2x2.mmg
#Places 4 input images into a single output to create an atlas of 4 images. 
#Chaining Tile2x2 nodes can be useful to create 16 images atlases.
#Atlases are used by remapping nodes such as CustomUV, Tiler and Splatter.

#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The first input",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The second input",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The third input",
#				"name": "in3",
#				"shortdesc": "Input3",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(0.0)",
#				"label": "",
#				"longdesc": "The fourth input",
#				"name": "in4",
#				"shortdesc": "Input4",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the generated atlas",
#				"rgba": "($uv.y < 0.5) ? (($uv.x < 0.5) ? ($in1(2.0*$uv)) : ($in2(2.0*$uv-vec2(1.0, 0.0)))) : (($uv.x < 0.5) ? ($in3(2.0*$uv-vec2(0.0, 1.0))) : ($in4(2.0*$uv-vec2(1.0, 1.0))))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],

#----------------------
#tile2x2_variations.mmg
#Places 4 input images into a single output to create an atlas of 4 images.
#Chaining Tile2x2 nodes can be useful to create 16 images atlases.
#Atlases are used by remapping nodes such as CustomUV, Tiler and Splatter.

#		"inputs": [
#			{
#				"default": "vec4(0.0)",
#				"function": true,
#				"label": "",
#				"longdesc": "The first input",
#				"name": "in",
#				"shortdesc": "Input1",
#				"type": "rgba"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "Shows the generated atlas",
#				"rgba": "($uv.y < 0.5) ? (($uv.x < 0.5) ? ($in.variation(2.0*$uv, $seed)) : ($in.variation(2.0*$uv-vec2(1.0, 0.0), $seed+0.1))) : (($uv.x < 0.5) ? ($in.variation(2.0*$uv-vec2(0.0, 1.0), $seed+0.2)) : ($in.variation(2.0*$uv-vec2(1.0, 1.0), $seed+0.3)))",
#				"shortdesc": "Output",
#				"type": "rgba"
#			}
#		],

#----------------------
#tiler.mmg
#Tiles several occurences of an input image while adding randomness.

#vec4 $(name_uv)_rch = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), vec2(float($seed)));

#instance
#vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, vec2 _seed) {\n\t
#	float c = 0.0;\n\t
#	vec3 rc = vec3(0.0);\n\t
#	vec3 rc1;\n\t
#	for (int dx = -overlap; dx <= overlap; ++dx) {\n\t\t
#		for (int dy = -overlap; dy <= overlap; ++dy) {\n\t\t\t
#			vec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));\n\t\t\t
#			vec2 seed = rand2(pos+_seed);\n\t\t\t
#			rc1 = rand3(seed);\n\t\t\t
#			pos = fract(pos+vec2($fixed_offset/tile.x, 0.0)*floor(mod(pos.y*tile.y, 2.0))+$offset*seed/tile);\n\t\t\t
#			float mask = $mask(fract(pos+vec2(0.5)));\n\t\t\t
#
#			if (mask > 0.01) {\n\t\t\t\t
#				vec2 pv = fract(uv - pos)-vec2(0.5);\n\t\t\t\t
#				seed = rand2(seed);\n\t\t\t\t
#					float angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;\n\t\t\t\t
#				float ca = cos(angle);\n\t\t\t\t
#				float sa = sin(angle);\n\t\t\t\t
#				pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t\t
#				pv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\t\t
#				pv /= vec2($scale_x, $scale_y);\n\t\t\t\t
#				pv += vec2(0.5);\n\t\t\t\t
#				seed = rand2(seed);\n\t\t\t\t
#				vec2 clamped_pv = clamp(pv, vec2(0.0), vec2(1.0));\n\t\t\t\t
#				if (pv.x != clamped_pv.x || pv.y != clamped_pv.y) {\n\t\t\t\t\t
#					continue;\n\t\t\t\t
#				}\n\t\t\t\t
#
#				$select_inputs\n\t\t\t\t
#
#				float c1 = $in.variation(pv, $variations ? seed.x : 0.0)*mask*(1.0-$value*seed.x);\n\t\t\t\t
#				c = max(c, c1);\n\t\t\t\t
#				rc = mix(rc, rc1, step(c, c1));\n\t\t\t
#			}\n\t\t
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
#tile, Vector2, default 4, min:1, max:64, step:1 - The number of columns of the tiles pattern
#overlap, float, default 1, min 0, max 5, step 1 - The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.
#select_inputs (Inputs), enum, default 0, values 1, 4, 16
#scale, Vector2, default 1, min:0, max:2, step:0.01 - "The scale of input images on the X axis
#fixed_offset, float, default 0.5, min 0, max 1, step 0.01 - The relative offset of odd rows
#offset (rnd_offset), float, default 0.5, min 0, max 1, step 0.01
#rotate (rnd_rotate), float, default 0, min 0, max 180, step 0.1
#scale (rnd_scale), float, default 0.5, min 0, max 1, step 0.01 - The random scale applied to each image instance
#value (rnd_value), float, default 0.5, min 0, max 1, step 0.01 - The random greyscale value applied to each image instance
#variations, bool, default false, (disabled) - Check to tile variations of the input

#----------------------
#tiler_advanced.mmg
#Tiles several occurences of an input image while adding randomness.

#		"code": "vec4 $(name_uv)_rch = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), float($seed));",
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
#			},
#			{
#				"default": "vec4(rand2($uv+vec2(float($seed))), rand2($uv-vec2(float($seed))))",
#				"label": "",
#				"longdesc": "An input color map used to generate the Instance map 1 output",
#				"name": "color1",
#				"shortdesc": "Color map 1",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(rand2(-$uv+vec2(float($seed))), rand2(-$uv-vec2(float($seed))))",
#				"label": "",
#				"longdesc": "An input color map used to generate the Instance map 2 output",
#				"name": "color2",
#				"shortdesc": "Color map 2",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "5:",
#				"longdesc": "A map for translation along the X axis",
#				"name": "tr_x",
#				"shortdesc": "Translate map X",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for translation along the Y axis",
#				"name": "tr_y",
#				"shortdesc": "Translate map Y",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for rotation",
#				"name": "r",
#				"shortdesc": "Rotate map",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for scale along the X axis",
#				"name": "sc_x",
#				"shortdesc": "Scale map X",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for scale along the Y axis",
#				"name": "sc_y",
#				"shortdesc": "Scale map Y",
#				"type": "f"
#			}
#		],
#		"instance": "vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, float _seed) {\n\tfloat c = 0.0;\n\tvec2 map_uv = vec2(0.0);\n\tfor (int dx = -overlap; dx <= overlap; ++dx) {\n\t\tfor (int dy = -overlap; dy <= overlap; ++dy) {\n\t\t\tvec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));\n\t\t\tfloat mask = $mask(fract(pos+vec2(0.5)));\n\t\t\tif (mask > 0.01) {\n\t\t\t\tvec2 pv = fract(uv - pos)-vec2(0.5);\n\t\t\t\tpos = fract(pos+vec2(0.5));\n\t\t\t\tpv -= vec2($translate_x*$tr_x(pos), $translate_y*$tr_y(pos))/tile;\n\t\t\t\tfloat angle = $r(pos) * $rotate * 0.01745329251;\n\t\t\t\tfloat ca = cos(angle);\n\t\t\t\tfloat sa = sin(angle);\n\t\t\t\tpv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t\tpv /= vec2($scale_x*$sc_x(pos), $scale_y*$sc_y(pos));\n\t\t\t\tpv += vec2(0.5);\n\t\t\t\tif (pv != clamp(pv, vec2(0.0), vec2(1.0))) {\n\t\t\t\t\tcontinue;\n\t\t\t\t}\n\t\t\t\tvec2 seed = rand2(vec2(_seed)+pos);\n\t\t\t\t$select_inputs\n\t\t\t\tfloat c1 = $in.variation(pv, $variations ? seed.x : 0.0)*mask;\n\t\t\t\tc = max(c, c1);\n\t\t\t\tmap_uv = mix(map_uv, pos, step(c, c1));\n\t\t\t}\n\t\t}\n\t}\n\treturn vec4(map_uv, 0.0, c);\n}",
#		"outputs": [
#			{
#				"f": "$(name_uv)_rch.a",
#				"longdesc": "Shows the generated pattern",
#				"shortdesc": "Output",
#				"type": "f"
#			},
#			{
#				"longdesc": "Shows a color for each instance of the input image",
#				"rgba": "$color1($(name_uv)_rch.rg)",
#				"shortdesc": "Instance map 1",
#				"type": "rgba"
#			},
#			{
#				"longdesc": "Shows a color for each instance of the input image",
#				"rgba": "$color2($(name_uv)_rch.rg)",
#				"shortdesc": "Instance map 2",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Tile X",
#				"longdesc": "The number of columns of the tiles pattern",
#				"max": 64,
#				"min": 1,
#				"name": "tx",
#				"shortdesc": "Tile.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Tile Y",
#				"longdesc": "The number of rows of the tiles pattern",
#				"max": 64,
#				"min": 1,
#				"name": "ty",
#				"shortdesc": "Tile.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Overlap",
#				"longdesc": "The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.",
#				"max": 5,
#				"min": 0,
#				"name": "overlap",
#				"shortdesc": "Overlap",
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
#				"default": 0,
#				"label": "Translate X",
#				"longdesc": "The translation along the X axis applied to the instances",
#				"max": 1,
#				"min": 0,
#				"name": "translate_x",
#				"shortdesc": "Translate.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Translate Y",
#				"longdesc": "The translation along the Y axis applied to the instances",
#				"max": 1,
#				"min": 0,
#				"name": "translate_y",
#				"shortdesc": "Translate.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rotate",
#				"longdesc": "The angle of instances of the input",
#				"max": 180,
#				"min": 0,
#				"name": "rotate",
#				"shortdesc": "Rotate",
#				"step": 0.1,
#				"type": "float"
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
#				"default": false,
#				"label": "Variations",
#				"longdesc": "Check to tile variations of the input",
#				"name": "variations",
#				"shortdesc": "Variations",
#				"type": "boolean"
#			}
#		],

#----------------------
#tiler_advanced_color.mmg
#Tiles several occurences of an input image while adding randomness.

#		"code": "vec2 $(name_uv)_mapuv;\nvec4 $(name_uv)_rch = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), float($seed), $(name_uv)_mapuv);",
#		"inputs": [
#			{
#				"default": "vec4(1.0)",
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
#			},
#			{
#				"default": "vec4(rand2($uv+vec2(float($seed))), rand2($uv-vec2(float($seed))))",
#				"label": "",
#				"longdesc": "An input color map used to generate the Instance map 1 output",
#				"name": "color1",
#				"shortdesc": "Color map 1",
#				"type": "rgba"
#			},
#			{
#				"default": "vec4(rand2(-$uv+vec2(float($seed))), rand2(-$uv-vec2(float($seed))))",
#				"label": "",
#				"longdesc": "An input color map used to generate the Instance map 2 output",
#				"name": "color2",
#				"shortdesc": "Color map 2",
#				"type": "rgba"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "5:",
#				"longdesc": "A map for translation along the X axis",
#				"name": "tr_x",
#				"shortdesc": "Translate map X",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for translation along the Y axis",
#				"name": "tr_y",
#				"shortdesc": "Translate map Y",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for rotation",
#				"name": "r",
#				"shortdesc": "Rotate map",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for scale along the X axis",
#				"name": "sc_x",
#				"shortdesc": "Scale map X",
#				"type": "f"
#			},
#			{
#				"default": "1.0",
#				"function": true,
#				"label": "",
#				"longdesc": "A map for scale along the Y axis",
#				"name": "sc_y",
#				"shortdesc": "Scale map Y",
#				"type": "f"
#			}
#		],
#		"instance": "vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, float _seed, out vec2 outmapuv) {\n\t// $seed\n\tvec4 c = vec4(0.0);\n\toutmapuv = vec2(0.0);\n\tfor (int dx = -overlap; dx <= overlap; ++dx) {\n\t\tfor (int dy = -overlap; dy <= overlap; ++dy) {\n\t\t\tvec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));\n\t\t\tfloat mask = $mask(fract(pos+vec2(0.5)));\n\t\t\tif (mask > 0.01) {\n\t\t\t\tvec2 pv = fract(uv - pos)-vec2(0.5);\n\t\t\t\tpos = fract(pos+vec2(0.5));\n\t\t\t\tpv -= vec2($translate_x*$tr_x(pos), $translate_y*$tr_y(pos))/tile;\n\t\t\t\tfloat angle = $r(pos) * $rotate * 0.01745329251;\n\t\t\t\tfloat ca = cos(angle);\n\t\t\t\tfloat sa = sin(angle);\n\t\t\t\tpv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t\tpv /= vec2($scale_x*$sc_x(pos), $scale_y*$sc_y(pos));\n\t\t\t\tpv += vec2(0.5);\n\t\t\t\tif (pv != clamp(pv, vec2(0.0), vec2(1.0))) {\n\t\t\t\t\tcontinue;\n\t\t\t\t}\n\t\t\t\tvec2 seed = rand2(vec2(_seed)+pos);\n\t\t\t\t$select_inputs\n\t\t\t\tvec4 n = $in.variation(pv, $variations ? seed.x : 0.0);\n\t\t\t\tfloat na = n.a*mask;\n\t\t\t\toutmapuv = mix(outmapuv, pos, step(c.a, na));\n\t\t\t\tc = mix(c, n, na);\n\t\t\t}\n\t\t}\n\t}\n\treturn c;\n}\n",
#		"outputs": [
#			{
#				"longdesc": "Shows the generated pattern",
#				"rgba": "$(name_uv)_rch",
#				"shortdesc": "Output",
#				"type": "rgba"
#			},
#			{
#				"longdesc": "Shows a color for each instance of the input image",
#				"rgba": "$color1($(name_uv)_mapuv)",
#				"shortdesc": "Instance map 1",
#				"type": "rgba"
#			},
#			{
#				"longdesc": "Shows a color for each instance of the input image",
#				"rgba": "$color2($(name_uv)_mapuv)",
#				"shortdesc": "Instance map 2",
#				"type": "rgba"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Tile X",
#				"longdesc": "The number of columns of the tiles pattern",
#				"max": 64,
#				"min": 1,
#				"name": "tx",
#				"shortdesc": "Tile.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Tile Y",
#				"longdesc": "The number of rows of the tiles pattern",
#				"max": 64,
#				"min": 1,
#				"name": "ty",
#				"shortdesc": "Tile.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 1,
#				"label": "Overlap",
#				"longdesc": "The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.",
#				"max": 5,
#				"min": 0,
#				"name": "overlap",
#				"shortdesc": "Overlap",
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
#				"default": 0,
#				"label": "Translate X",
#				"longdesc": "The translation along the X axis applied to the instances",
#				"max": 1,
#				"min": 0,
#				"name": "translate_x",
#				"shortdesc": "Translate.x",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Translate Y",
#				"longdesc": "The translation along the Y axis applied to the instances",
#				"max": 1,
#				"min": 0,
#				"name": "translate_y",
#				"shortdesc": "Translate.y",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Rotate",
#				"longdesc": "The angle of instances of the input",
#				"max": 180,
#				"min": 0,
#				"name": "rotate",
#				"shortdesc": "Rotate",
#				"step": 0.1,
#				"type": "float"
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
#				"default": false,
#				"label": "Variations",
#				"longdesc": "Check to tile variations of the input",
#				"name": "variations",
#				"shortdesc": "Variations",
#				"type": "boolean"
#			}
#		],

#----------------------
#tiler_color.mmg
#Tiles several occurences of an input image while adding randomness.

#vec3 $(name_uv)_random_color;\n
#vec4 $(name_uv)_tiled_output = tiler_$(name)($uv, vec2($tx, $ty), int($overlap), vec2(float($seed)), $(name_uv)_random_color);

#vec4 tiler_$(name)(vec2 uv, vec2 tile, int overlap, vec2 _seed, out vec3 random_color) {\n\t
#	vec4 c = vec4(0.0);\n\t
#	vec3 rc = vec3(0.0);\n\t
#	vec3 rc1;\n\t
#
#	for (int dx = -overlap; dx <= overlap; ++dx) {\n\t\t
#		for (int dy = -overlap; dy <= overlap; ++dy) {\n\t\t\t
#			vec2 pos = fract((floor(uv*tile)+vec2(float(dx), float(dy))+vec2(0.5))/tile-vec2(0.5));\n\t\t\t
#			vec2 seed = rand2(pos+_seed);\n\t\t\t
#			rc1 = rand3(seed);\n\t\t\t
#			pos = fract(pos+vec2($fixed_offset/tile.x, 0.0)*floor(mod(pos.y*tile.y, 2.0))+$offset*seed/tile);\n\t\t\t
#			float mask = $mask(fract(pos+vec2(0.5)));\n\t\t\t
#			if (mask > 0.01) {\n\t\t\t\t
#				vec2 pv = fract(uv - pos)-vec2(0.5);\n\t\t\t\t
#				seed = rand2(seed);\n\t\t\t\t
#				float angle = (seed.x * 2.0 - 1.0) * $rotate * 0.01745329251;\n\t\t\t\t
#				float ca = cos(angle);\n\t\t\t\t
#				float sa = sin(angle);\n\t\t\t\t
#				pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);\n\t\t\t\t
#				pv *= (seed.y-0.5)*2.0*$scale+1.0;\n\t\t\t\t
#				pv /= vec2($scale_x, $scale_y);\n\t\t\t\t
#				pv += vec2(0.5);\n\t\t\t\t
#				pv = clamp(pv, vec2(0.0), vec2(1.0));\n\t\t\t\t
#
#				$select_inputs\n\t\t\t\t
#
#				vec4 n = $in.variation(pv, $variations ? seed.x : 0.0);\n\t\t\t\t
#
#				seed = rand2(seed);\n\t\t\t\t
#				float na = n.a*mask*(1.0-$opacity*seed.x);\n\t\t\t\t
#				float a = (1.0-c.a)*(1.0*na);\n\t\t\t\t
#
#				c = mix(c, n, na);\n\t\t\t\t
#				rc = mix(rc, rc1, n.a);\n\t\t\t
#			}\n\t\t
#		}\n\t
#	}\n\t
#
#	random_color = rc;\n\t
#	return c;\n
#}


#Inputs:

#in, rgba, default: 0, - The input image or atlas of 4 or 16 input images
#Mask, float, default: 1, - The mask applied to the pattern

#Outputs:
#Output, float, Shows the generated pattern
#$(name_uv)_tiled_output

#Instance map, rgb, Shows a random color for each instance of the input image
#$(name_uv)_random_color

#select_inputs enum
#1,  " "
#4, "pv = clamp(0.5*(pv+floor(rand2(seed)*2.0)), vec2(0.0), vec2(1.0));"
#16, "pv = clamp(0.25*(pv+floor(rand2(seed)*4.0)), vec2(0.0), vec2(1.0));"

#Parameters:
#tile, Vector2, default 4, min:1, max:64, step:1 - The number of columns of the tiles pattern
#overlap, float, default 1, min 0, max 5, step 1 - The number of neighbour tiles an instance of the input image can overlap. Set this parameter to the lowest value that generates the expected result (where all instances are fully visible) to improve performance.
#select_inputs (Inputs), enum, default 0, values 1, 4, 16
#scale, Vector2, default 1, min:0, max:2, step:0.01 - "The scale of input images on the X axis
#fixed_offset, float, default 0.5, min 0, max 1, step 0.01 - The relative offset of odd rows
#offset (rnd_offset), float, default 0.5, min 0, max 1, step 0.01
#rotate (rnd_rotate), float, default 0, min 0, max 180, step 0.1
#scale (rnd_scale), float, default 0.5, min 0, max 1, step 0.01 - The random scale applied to each image instance
#opacity (rnd_opacity), float, default 0, min 0, max 1, step 0.01 - The random greyscale value applied to each image instance
#variations, bool, default false, (disabled) - Check to tile variations of the input

