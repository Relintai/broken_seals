tool
extends Resource
class_name WorldGenBaseResource

export(Rect2) var rect : Rect2 = Rect2(0, 0, 100, 100)
export(bool) var locked : bool = false

func get_rect() -> Rect2:
	return rect

func set_rect(r : Rect2) -> void:
	rect = r
	emit_changed()

func get_content() -> Array:
	return Array()

func set_content(arr : Array) -> void:
	pass
	
func add_content(entry : WorldGenBaseResource) -> void:
	pass

func create_content(item_name : String = "") -> void:
	pass

func remove_content_entry(entry : WorldGenBaseResource) -> void:
	pass

func get_content_with_name(name : String) -> WorldGenBaseResource:
	if resource_name == name:
		return self
		
	for c in get_content():
		if c:
			var cc = c.get_content_with_name(name)
			if cc:
				return cc
		
	return null

func get_all_contents_with_name(name : String) -> Array:
	var arr : Array = Array()
	
	if resource_name == name:
		arr.append(self)
		
	for c in get_content():
		if c:
			var cc : Array = c.get_all_contents_with_name(name)
			arr.append_array(cc)
		
	return arr

func duplicate_content_entry(entry : WorldGenBaseResource) -> void:
	var de : WorldGenBaseResource = entry.duplicate(true)
	de.resource_name += " (Duplicate)"
	add_content(de)

func setup_terra_library(library : TerramanLibrary, pseed : int) -> void:
	_setup_terra_library(library, pseed)
	
	for c in get_content():
		if c:
			c.setup_terra_library(library, pseed)

func _setup_terra_library(library : TerramanLibrary, pseed : int) -> void:
	pass

func generate_terra_chunk(chunk: TerraChunk, pseed : int, spawn_mobs: bool) -> void:
	generate_terra_chunk_internal(chunk, pseed, spawn_mobs, get_rect())
	
func generate_terra_chunk_internal(chunk: TerraChunk, pseed : int, spawn_mobs: bool, world_parent_rect : Rect2) -> void:
	var wcr : Rect2 = get_rect()
	wcr.position += world_parent_rect.position
	
	var p : Vector2 = Vector2(chunk.get_position_x(), chunk.get_position_z())
	
	#TODO
	#if !wcr.has_point(p):
	#	return
		
	_generate_terra_chunk(chunk, spawn_mobs, spawn_mobs)
	
	for c in get_content():
		if c:
			c.generate_terra_chunk_internal(chunk, pseed, spawn_mobs, wcr)
	
func _generate_terra_chunk(chunk: TerraChunk, pseed : int, spawn_mobs: bool) -> void:
	pass
	
func generate_map(pseed : int) -> Image:
	var img : Image = Image.new()
	
	img.create(get_rect().size.x, get_rect().size.y, false, Image.FORMAT_RGBA8)
	
	add_to_map(img, pseed)
	
	return img

func add_to_map(var img : Image, pseed : int) -> void:
	_add_to_map(img, pseed)
	
	for c in get_content():
		if c:
			c.add_to_map(img, pseed)

func _add_to_map(var img : Image, pseed : int) -> void:
	pass

func get_editor_rect_border_color() -> Color:
	return Color(1, 1, 1, 1)

func get_editor_rect_color() -> Color:
	return Color(1, 1, 1, 0.9)

func get_editor_rect_border_size() -> int:
	return 2

func get_editor_font_color() -> Color:
	return Color(0, 0, 0, 1)

func get_editor_class() -> String:
	return "WorldGenBaseResource"

func get_editor_additional_text() -> String:
	return "WorldGenBaseResource"

func setup_property_inspector(inspector) -> void:
	inspector.add_slot_line_edit("get_name", "set_name", "Name")
	inspector.add_slot_rect2("get_rect", "set_rect", "Rect", 1)
