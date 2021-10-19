tool
extends MMNode

var NoiseFBM = preload("res://addons/mat_maker_gd/nodes/common/noise_fbm.gd")

export(Resource) var image : Resource

export(int, "Value,Perlin,Simplex,Cellular1,Cellular2,Cellular3,Cellular4,Cellular5,Cellular6") var type : int = 0
export(Vector2) var scale : Vector2 = Vector2(2, 2)
export(int) var folds : int = 0
export(int) var iterations : int = 5
export(float) var persistence : float = 0.5

func _init_properties():
	if !image:
		image = MMNodeUniversalProperty.new()
		image.default_type = MMNodeUniversalProperty.MMNodeUniversalPropertyDefaultType.DEFAULT_TYPE_IMAGE
		
	image.output_slot_type = MMNodeUniversalProperty.SlotTypes.SLOT_TYPE_IMAGE

	register_output_property(image)

func _register_methods(mm_graph_node) -> void:
	mm_graph_node.add_slot_texture_universal(image)
	mm_graph_node.add_slot_enum("get_type", "set_type", "Type", [ "Value", "Perlin", "Simplex", "Cellular1", "Cellular2", "Cellular3", "Cellular4", "Cellular5", "Cellular6" ])#, Vector2(0, 1))
	mm_graph_node.add_slot_vector2("get_scale", "set_scale", "Scale")#, Vector2(1, 10))
	mm_graph_node.add_slot_int("get_folds", "set_folds", "folds")#, Vector2(0, 1))
	mm_graph_node.add_slot_int("get_iterations", "set_iterations", "Iterations")#, Vector2(0, 1))
	mm_graph_node.add_slot_float("get_persistence", "set_persistence", "Persistence", 0.01)#, Vector2(0, 1))

func get_value_for(uv : Vector2, pseed : int) -> Color:
	var ps : float = 1.0 / float(pseed)
	
	#"Value,Perlin,Simplex,Cellular1,Cellular2,Cellular3,Cellular4,Cellular5,Cellular6"
	if type == 0:
		return NoiseFBM.fbmval(uv, scale, folds, iterations, persistence, ps)
	elif type == 1:
		return NoiseFBM.perlin(uv, scale, folds, iterations, persistence, ps)
	elif type == 2:
		return NoiseFBM.simplex(uv, scale, folds, iterations, persistence, ps)
	elif type == 3:
		return NoiseFBM.cellular(uv, scale, folds, iterations, persistence, ps)
	elif type == 4:
		return NoiseFBM.cellular2(uv, scale, folds, iterations, persistence, ps)
	elif type == 5:
		return NoiseFBM.cellular3(uv, scale, folds, iterations, persistence, ps)
	elif type == 6:
		return NoiseFBM.cellular4(uv, scale, folds, iterations, persistence, ps)
	elif type == 7:
		return NoiseFBM.cellular5(uv, scale, folds, iterations, persistence, ps)
	elif type == 8:
		return NoiseFBM.cellular6(uv, scale, folds, iterations, persistence, ps)
	
	return Color()

func _render(material) -> void:
	var img : Image = render_image(material)
	
	image.set_value(img)

func get_type() -> int:
	return type
	
func set_type(val : int) -> void:
	type = val
	
	set_dirty(true)

func get_scale() -> Vector2:
	return scale
	
func set_scale(val : Vector2) -> void:
	scale = val
	
	set_dirty(true)

func get_folds() -> int:
	return folds
	
func set_folds(val : int) -> void:
	folds = val
	
	set_dirty(true)

func get_iterations() -> int:
	return iterations
	
func set_iterations(val : int) -> void:
	iterations = val
	
	set_dirty(true)

func get_persistence() -> float:
	return persistence
	
func set_persistence(val : float) -> void:
	persistence = val
	
	set_dirty(true)
