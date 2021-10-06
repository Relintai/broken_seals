tool
class_name MMNode
extends Resource

export(Vector2) var graph_position : Vector2 = Vector2()

func recalculate_image(material, slot_idx : int) -> ImageTexture:
	var image : Image = Image.new()
	image.create(material.image_size.x, material.image_size.y, false, Image.FORMAT_RGBA8)
		
	var tex : ImageTexture = ImageTexture.new()

	image.lock()
	
	var w : float = image.get_width()
	var h : float = image.get_width()
	
	var pseed : float = randf() + randi()
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var v : Vector2 = Vector2(x / w, y / h)

			var col : Color = get_value_for(v, slot_idx, pseed)

			image.set_pixel(x, y, col)

	image.unlock()
	
	tex.create_from_image(image)

	return tex

func get_value_for(uv : Vector2, slot_idx : int, pseed : int) -> Color:
	return Color()

func register_methods(mm_graph_node) -> void:
	pass

func get_graph_position() -> Vector2:
	return graph_position

func set_graph_position(pos : Vector2) -> void:
	graph_position = pos
	
	emit_changed()
