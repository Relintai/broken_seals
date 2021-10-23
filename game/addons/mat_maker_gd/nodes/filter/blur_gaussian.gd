tool
extends MMNode

var Filter = preload("res://addons/mat_maker_gd/nodes/common/filter.gd")

export(Resource) var image : Resource
export(Resource) var input : Resource
export(Resource) var sigma : Resource
export(int, "Both,X,Y") var direction : int = 0

var size : int = 0

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_COLOR
		input.set_default_value(Color())

	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = ">>>    Input1    "
	
	if !sigma:
		sigma = MMNodeUniversalProperty.new()
		sigma.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_FLOAT
		sigma.set_default_value(50)

	sigma.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	sigma.slot_name = "Sigma"
		
	register_input_property(input)
	register_output_property(image)
	register_input_property(sigma)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_int_universal(sigma)

	mm_graph_node.add_slot_enum("get_direction", "set_direction", "Direction", [ "Both", "X", "Y" ])


func _render(material) -> void:
	size = max(material.image_size.x, material.image_size.y)
	
	var img : Image = render_image(material)

	image.set_value(img)

func render_image(material) -> Image:
	var img : Image = Image.new()
	img.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	img.lock()
	
	var w : float = img.get_width()
	var h : float = img.get_width()
	
	var pseed : float = randf() + randi()
	
	if direction == 0:
		for x in range(img.get_width()):
			for y in range(img.get_height()):
				var v : Vector2 = Vector2(x / w, y / h)
				var col : Color = get_value_x(v, pseed)
				img.set_pixel(x, y, col)
		
		img.unlock()
		image.set_value(img)
		
		var image2 : Image = Image.new()
		image2.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
		image2.lock()
				
		for x in range(img.get_width()):
			for y in range(img.get_height()):
				var v : Vector2 = Vector2(x / w, y / h)
				var col : Color = get_value_y_img(v, pseed)
				image2.set_pixel(x, y, col)
				
		image2.unlock()
		
		return image2
	
	if direction == 1:
		for x in range(img.get_width()):
			for y in range(img.get_height()):
				var v : Vector2 = Vector2(x / w, y / h)
				var col : Color = get_value_x(v, pseed)
				img.set_pixel(x, y, col)

	if direction == 2:
		for x in range(img.get_width()):
			for y in range(img.get_height()):
				var v : Vector2 = Vector2(x / w, y / h)
				var col : Color = get_value_y(v, pseed)
				img.set_pixel(x, y, col)

	img.unlock()

	return img

func get_value_x(uv : Vector2, pseed : int) -> Color:
	var sig_def : float = sigma.get_default_value(uv)
	var sig : float = sigma.get_value(uv)

	return gaussian_blur_x(uv, size, sig_def, sig)

func get_value_y(uv : Vector2, pseed : int) -> Color:
	var sig_def : float = sigma.get_default_value(uv)
	var sig : float = sigma.get_value(uv)

	return gaussian_blur_y(uv, size, sig_def, sig)

func get_value_y_img(uv : Vector2, pseed : int) -> Color:
	var sig_def : float = sigma.get_default_value(uv)
	var sig : float = sigma.get_value(uv)

	return gaussian_blur_y_img(uv, size, sig_def, sig)

func get_direction() -> int:
	return direction

func set_direction(val : int) -> void:
	direction = val

	set_dirty(true)

#----------------------
#gaussian_blur_x.mmg

#vec4 $(name)_fct(vec2 uv) {
#	float e = 1.0 / $size;
#	vec4 rv = vec4(0.0);
#	float sum = 0.0;
#	float sigma = max(0.000001, $sigma * $amount(uv));
#
#	for (float i = -50.0; i <= 50.0; i += 1.0) {
#		float coef = exp(-0.5 * (pow(i / sigma, 2.0))) / (6.28318530718 * sigma * sigma);
#		rv += $in(uv+vec2(i*e, 0.0))*coef;
#		sum += coef;
#	}
#
#	return rv/sum;
#}

func gaussian_blur_x(uv : Vector2, psize : float, psigma : float, pamount : float) -> Color:
	var e : float = 1.0 / psize
	var rv : Color = Color()
	var sum : float = 0.0
	var sigma : float = max(0.000001, psigma * pamount)#pamount(uv))

	var i : float = -50

	while i <= 50: #for (float i = -50.0; i <= 50.0; i += 1.0) {
		var coef : float = exp(-0.5 * (pow(i / sigma, 2.0))) / (6.28318530718 * sigma * sigma)
		rv += input.get_value(uv + Vector2(i*e, 0.0)) * coef
		sum += coef
		
		i += 1

	return rv / sum;


#----------------------
#gaussian_blur_y.mmg

#vec4 $(name)_fct(vec2 uv) {
#	float e = 1.0/$size;
#	vec4 rv = vec4(0.0);
#	float sum = 0.0;
#	float sigma = max(0.000001, $sigma*$amount(uv));
#	for (float i = -50.0; i <= 50.0; i += 1.0) {
#		float coef = exp(-0.5 * (pow(i / sigma, 2.0))) / (6.28318530718*sigma*sigma);
#		rv += $in(uv+vec2(0.0, i*e))*coef;
#		sum += coef;
#	}
#
#	return rv/sum;
#}

func gaussian_blur_y(uv : Vector2, psize : float, psigma : float, pamount : float) -> Color:
	var e : float = 1.0 / psize
	var rv : Color = Color()
	var sum : float = 0.0
	var sigma : float = max(0.000001, psigma * pamount)#pamount(uv))

	var i : float = -50

	while i <= 50: #for (float i = -50.0; i <= 50.0; i += 1.0) {
		var coef : float = exp(-0.5 * (pow(i / sigma, 2.0))) / (6.28318530718 * sigma * sigma)
		rv += input.get_value(uv + Vector2(0.0, i * e)) * coef
		sum += coef
		
		i += 1

	return rv / sum;


func gaussian_blur_y_img(uv : Vector2, psize : float, psigma : float, pamount : float) -> Color:
	var e : float = 1.0 / psize
	var rv : Color = Color()
	var sum : float = 0.0
	var sigma : float = max(0.000001, psigma * pamount)#pamount(uv))

	var i : float = -50

	while i <= 50: #for (float i = -50.0; i <= 50.0; i += 1.0) {
		var coef : float = exp(-0.5 * (pow(i / sigma, 2.0))) / (6.28318530718 * sigma * sigma)
		rv += image.get_value(uv + Vector2(0.0, i * e)) * coef
		sum += coef
		
		i += 1

	return rv / sum;
