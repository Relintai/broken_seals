tool
class_name MMNode
extends Resource

export(Vector2) var graph_position : Vector2 = Vector2()

var input_properties : Array
var output_properties : Array

var properties_initialized : bool = false

var dirty : bool = true

#MMMateial
func render(material) -> bool:
	if !dirty:
		return false
	
	for p in input_properties:
		if p.input_property && p.input_property.owner.dirty:
			return false
			
	_render(material)
	
	dirty = false
	
	return true

#MMMateial
func _render(material) -> void:
	pass

func render_image(material) -> Image:
	var image : Image = Image.new()
	image.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)

	image.lock()
	
	var w : float = image.get_width()
	var h : float = image.get_height()
	
	var pseed : float = randf() + randi()
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var v : Vector2 = Vector2(x / w, y / h)

			var col : Color = get_value_for(v, pseed)

			image.set_pixel(x, y, col)

	image.unlock()

	return image

func get_value_for(uv : Vector2, pseed : int) -> Color:
	return Color()

func init_properties() -> void:
	if !properties_initialized:
		properties_initialized = true
		
		_init_properties()

func _init_properties() -> void:
	pass

func register_methods(mm_graph_node) -> void:
	init_properties()
	_register_methods(mm_graph_node)

func _register_methods(mm_graph_node) -> void:
	pass

func get_graph_position() -> Vector2:
	return graph_position

func set_graph_position(pos : Vector2) -> void:
	graph_position = pos
	
	emit_changed()

func register_input_property(prop : MMNodeUniversalProperty) -> void:
	prop.owner = self
	
	if !prop.is_connected("changed", self, "on_input_property_changed"):
		prop.connect("changed", self, "on_input_property_changed")
	
	input_properties.append(prop) 

func unregister_input_property(prop : MMNodeUniversalProperty) -> void:
	if prop.owner == self:
		prop.owner = null
	
	if prop.is_connected("changed", self, "on_input_property_changed"):
		prop.disconnect("changed", self, "on_input_property_changed")
	
	input_properties.erase(prop)

func register_output_property(prop : MMNodeUniversalProperty) -> void:
	prop.owner = self
	
	output_properties.append(prop) 

func unregister_output_property(prop : MMNodeUniversalProperty) -> void:
	if prop.owner == self:
		prop.owner = null
	
	output_properties.erase(prop)

func set_dirty(val : bool) -> void:
	var changed : bool = val != dirty
	
	dirty = val
	
	if changed:
		emit_changed()

func on_input_property_changed() -> void:
	set_dirty(true)
	emit_changed()
