tool
extends MMNode

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")
var SDF2D = preload("res://addons/mat_maker_gd/nodes/common/sdf3d.gd")

export(Resource) var input : Resource

export(Resource) var out_height_map : Resource
export(Resource) var out_normal_map : Resource
export(Resource) var out_color_map : Resource

func _init_properties():
	if !input:
		input = MMNodeUniversalProperty.new()
		input.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_VECTOR2
	
	#for some reason this doesn't work, todo check
#	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_FLOAT
	input.input_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_UNIVERSAL
	input.slot_name = "Input"

	if !out_height_map:
		out_height_map = MMNodeUniversalProperty.new()
		out_height_map.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_height_map.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	
	if !out_normal_map:
		out_normal_map = MMNodeUniversalProperty.new()
		out_normal_map.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_normal_map.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE
	
	if !out_color_map:
		out_color_map = MMNodeUniversalProperty.new()
		out_color_map.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	out_color_map.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(out_height_map)
	register_output_property(out_normal_map)
	register_output_property(out_color_map)
	register_input_property(input)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_label_universal(input)
	mm_graph_node.add_slot_texture_universal(out_height_map)
	mm_graph_node.add_slot_texture_universal(out_normal_map)
	mm_graph_node.add_slot_texture_universal(out_color_map)


func _render(material) -> void:
	var height_map : Image = Image.new()
	var normal_map : Image = Image.new()
	var color_map : Image = Image.new()
	
	height_map.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	normal_map.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
	color_map.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	height_map.lock()
	normal_map.lock()
	color_map.lock()
	
	var w : float = material.image_size.x
	var h : float = material.image_size.y
	
	var pseed : float = randf() + randi()
	
	for x in range(material.image_size.x):
		for y in range(material.image_size.y):
			var uv : Vector2 = Vector2(x / w, y / h)
			
			var raymarch : Vector2 = sdf3d_raymarch(uv)
			
			#HeightMap - float - The generated height map
			#1.0-$(name_uv)_d.x
			var hmf : float = 1.0 - raymarch.x
			var height_map_col : Color = Color(hmf, hmf, hmf, 1)

			#NormalMap - rgb - The generated normal map
			#vec3(0.5) + 0.5* normal_$name(vec3($uv-vec2(0.5), 1.0-$(name_uv)_d.x))
			var nuv : Vector2 = uv - Vector2(0.5, 0.5)
			var n : Vector3 = sdf3d_normal(Vector3(nuv.x, nuv.y, 1.0 - raymarch.x))
			var nn : Vector3 = Vector3(0.5, 0.5, 0.5) + 0.5 * n
			
			var normal_map_col : Color = Color(nn.x, nn.y, nn.z, 1)

			#ColorMap - float - The generated color index map
			#$(name_uv)_d.y
			var color_map_col : Color = Color(raymarch.y, raymarch.y, raymarch.y, 1)
	
			height_map.set_pixel(x, y, height_map_col)
			normal_map.set_pixel(x, y, normal_map_col)
			color_map.set_pixel(x, y, color_map_col)

	height_map.unlock()
	normal_map.unlock()
	color_map.unlock()
	
	out_height_map.set_value(height_map)
	out_normal_map.set_value(normal_map)
	out_color_map.set_value(color_map)

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return Color()

#vec2 raymarch_$name(vec2 uv) {
#	vec3 ro = vec3(uv-vec2(0.5), 1.0);
#	vec3 rd = vec3(0.0, 0.0, -1.0);
#	float dO = 0.0;
#	float c = 0.0;    
#
#	for (int i=0; i < 100; i++) {    
#		vec3 p = ro + rd*dO;        
#		vec2 dS = $sdf(p);        
#		dO += dS.x;        
#
#		if (dO >= 1.0) {
#			break;
#		} else if (dS.x < 0.0001) {
#			c = dS.y;
#			break;
#		}    
#	}        
#
#	return vec2(dO, c);
#}

func sdf3d_raymarch(uv : Vector2) -> Vector2:
	var ro : Vector3 = Vector3(uv.x - 0.5, uv.y - 0.5, 1.0);
	var rd : Vector3 = Vector3(0.0, 0.0, -1.0);
	var dO : float = 0.0;
	var c : float = 0.0;
	
	for i in range(100):
		var p : Vector3 = ro + rd * dO;
		var dS : Vector2 = input.get_value_sdf3d(p)
		
		dO += dS.x;

		if (dO >= 1.0):
			break;
		elif (dS.x < 0.0001):
			c = dS.y;
			break;
	
	return Vector2(dO, c);

#vec3 normal_$name(vec3 p) {
#	if (p.z <= 0.0) {
#		return vec3(0.0, 0.0, 1.0);
#	}
#
#	float d = $sdf(p).x;
#	float e = .001;        
#	vec3 n = d - vec3(        
#		$sdf(p-vec3(e, 0.0, 0.0)).x,        
#		$sdf(p-vec3(0.0, e, 0.0)).x,        
#		$sdf(p-vec3(0.0, 0.0, e)).x);        
#
#	return vec3(-1.0, -1.0, -1.0)*normalize(n);
#}

func sdf3d_normal(p : Vector3) -> Vector3:
	if (p.z <= 0.0):
		return Vector3(0.0, 0.0, 1.0);

	var d : float = input.get_value_sdf3d(p).x
	var e : float = .001;
	
	var n : Vector3 = Vector3(
		d - input.get_value_sdf3d(p - Vector3(e, 0.0, 0.0)).x,
		d - input.get_value_sdf3d(p - Vector3(0.0, e, 0.0)).x,
		d - input.get_value_sdf3d(p - Vector3(0.0, 0.0, e)).x)
	
	return Vector3(-1.0, -1.0, -1.0) * n.normalized()
	
