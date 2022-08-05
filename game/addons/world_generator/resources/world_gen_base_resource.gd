tool
extends Resource
class_name WorldGenBaseResource

export(Rect2) var rect : Rect2 = Rect2(0, 0, 100, 100)
export(Vector2i) var min_size : Vector2i = Vector2i(1, 1)
export(Vector2i) var max_size : Vector2i = Vector2i(1000000, 1000000)
export(bool) var locked : bool = false

func get_rect() -> Rect2:
	return rect

func set_rect(r : Rect2) -> void:
	rect.position = r.position
	rect.size.x = max(min_size.x, r.size.x)
	rect.size.y = max(min_size.y, r.size.y)
	rect.size.x = min(max_size.x, rect.size.x)
	rect.size.y = min(max_size.y, rect.size.y)
	emit_changed()

func get_min_size() -> Vector2i:
	return min_size

func set_min_size(r : Vector2i) -> void:
	min_size = r
	emit_changed()
	
func get_max_size() -> Vector2i:
	return max_size

func set_max_size(r : Vector2i) -> void:
	max_size = r
	emit_changed()

func get_locked() -> bool:
	return locked

func set_locked(r : bool) -> void:
	locked = r
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

func is_spawner() -> bool:
	return _is_spawner()
	
func _is_spawner() -> bool:
	return false
	
func get_spawn_local_position() -> Vector2:
	return _get_spawn_local_position()
	
func _get_spawn_local_position() -> Vector2:
	return Vector2()

func get_spawn_positions(var parent_position : Vector2 = Vector2()) -> Array:
	if is_spawner():
		return [ [ resource_name, parent_position + rect.position + get_spawn_local_position() ] ]
		
	var spawners : Array
	var p : Vector2 = parent_position + rect.position
		
	for c in get_content():
		if c:
			spawners.append_array(c.get_spawn_positions(p))
		
	return spawners

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

func duplicate_content_entry(entry : WorldGenBaseResource, add : bool = true) -> WorldGenBaseResource:
	var de : WorldGenBaseResource = entry.duplicate(true)
	de.resource_name += " (Duplicate)"
	
	if add:
		add_content(de)
		
	return de

func setup_terra_library(library : TerrainLibrary, pseed : int) -> void:
	_setup_terra_library(library, pseed)
	
	for c in get_content():
		if c:
			c.setup_terra_library(library, pseed)

func _setup_terra_library(library : TerrainLibrary, pseed : int) -> void:
	pass

func generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool) -> void:
	var p : Vector2 = Vector2(chunk.get_position_x(), chunk.get_position_z())

	var raycast : WorldGenRaycast = get_hit_stack(p)
	
	if raycast.size() == 0:
		_generate_terra_chunk_fallback(chunk, pseed, spawn_mobs)
		return
	
	while raycast.next():
		raycast.get_resource()._generate_terra_chunk(chunk, pseed, spawn_mobs, raycast)
	
func _generate_terra_chunk(chunk: TerrainChunk, pseed : int, spawn_mobs: bool, raycast : WorldGenRaycast) -> void:
	pass
	
func _generate_terra_chunk_fallback(chunk: TerrainChunk, pseed : int, spawn_mobs: bool) -> void:
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL, 1)
	chunk.set_voxel(1, 0, 0, TerrainChunkDefault.DEFAULT_CHANNEL_ISOLEVEL)
	
func generate_map(pseed : int) -> Image:
	var img : Image = Image.new()
	
	img.create(get_rect().size.x, get_rect().size.y, false, Image.FORMAT_RGBA8)
	
	add_to_map(img, pseed)
	
	return img

func add_to_map(img : Image, pseed : int) -> void:
	_add_to_map(img, pseed)
	
	for c in get_content():
		if c:
			c.add_to_map(img, pseed)

func _add_to_map(img : Image, pseed : int) -> void:
	pass

func get_hit_stack(pos : Vector2, raycast : WorldGenRaycast = null) -> WorldGenRaycast:
	var r : Rect2 = get_rect()
	var local_pos : Vector2 = pos - rect.position
	r.position = Vector2()

	if !raycast:
		raycast = WorldGenRaycast.new()

	if r.has_point(local_pos):
		var local_uv : Vector2 = local_pos / rect.size
		raycast.add_data(self, local_pos, local_uv)
		
	for c in get_content():
		if c:
			c.get_hit_stack(local_pos, raycast)
	
	return raycast

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
	return ""
	
func eitor_draw_additional(control : Control) -> void:
	_eitor_draw_additional(control)
	
func _eitor_draw_additional(control : Control) -> void:
	pass
	
func eitor_draw_additional_background(control : Control) -> void:
	_eitor_draw_additional_background(control)
	
func _eitor_draw_additional_background(control : Control) -> void:
	pass

func setup_property_inspector(inspector) -> void:
	inspector.add_slot_line_edit("get_name", "set_name", "Name")
	inspector.add_slot_rect2("get_rect", "set_rect", "Rect", 1)
	inspector.add_slot_vector2i("get_min_size", "set_min_size", "Min Size", 1)
	inspector.add_slot_vector2i("get_max_size", "set_max_size", "Max Size", 1)
	inspector.add_slot_bool("get_locked", "set_locked", "Locked")

