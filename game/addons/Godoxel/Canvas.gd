extends Control
class_name GECanvas
tool

export var pixel_size: int = 16 setget set_pixel_size
export(int, 1, 2500) var canvas_width = 48 setget set_canvas_width # == pixels
export(int, 1, 2500) var canvas_height = 28 setget set_canvas_height # == pixels
export var grid_size = 16 setget set_grid_size
export var big_grid_size = 10 setget set_big_grid_size
export var can_draw = true

var mouse_in_region
var mouse_on_top

var layers : Array = [] # Key: layer_name, val: GELayer
var active_layer: GELayer
var preview_layer: GELayer
var tool_layer: GELayer
var canvas_layers: Control

var canvas
var grid
var big_grid
var selected_pixels = []

var symmetry_x = false
var symmetry_y = false


func _enter_tree():
	#-------------------------------
	# Set nodes
	#-------------------------------
	canvas = find_node("Canvas")
	grid = find_node("Grid")
	big_grid = find_node("BigGrid")
	canvas_layers = find_node("CanvasLayers")
	
	#-------------------------------
	# setup layers and canvas
	#-------------------------------
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
	#-------------------------------
	# setup layers and canvas
	#-------------------------------
	#canvas_size = Vector2(int(rect_size.x / grid_size), int(rect_size.y / grid_size))
	#pixel_size = canvas_size
	
	active_layer = add_new_layer("Layer1")
	preview_layer = add_new_layer("Preview")
	tool_layer = add_new_layer("Tool")
	
	set_process(true)


func _process(delta):
	if not is_visible_in_tree():
		return
	var mouse_position = get_local_mouse_position()
	var rect = Rect2(Vector2(0, 0), rect_size)
	mouse_in_region = rect.has_point(mouse_position)


func _draw():
	for layer in layers:
		layer.update_texture()
	
	preview_layer.update_texture()
	tool_layer.update_texture()


func resize(width: int, height: int):
	if width < 0:
		width = 1
	if height < 0:
		height = 1
	
	set_canvas_width(width)
	set_canvas_height(height)
	
	preview_layer.resize(width, height)
	tool_layer.resize(width, height)
	for layer in layers:
		layer.resize(width, height)


#-------------------------------
# Export
#-------------------------------

func set_pixel_size(size: int):
	pixel_size = size
	set_grid_size(grid_size)
	set_big_grid_size(big_grid_size)
	set_canvas_width(canvas_width)
	set_canvas_height(canvas_height)


func set_grid_size(size):
	grid_size = size
	if not find_node("Grid"):
		return
	find_node("Grid").size = size * pixel_size


func set_big_grid_size(size):
	big_grid_size = size
	if not find_node("BigGrid"):
		return
	find_node("BigGrid").size = size * pixel_size


func set_canvas_width(val: int):
	canvas_width = val
	rect_size.x = canvas_width * pixel_size


func set_canvas_height(val: int):
	canvas_height = val
	rect_size.y = canvas_height * pixel_size


#-------------------------------
# Layer
#-------------------------------



func toggle_alpha_locked(layer_name: String):
	var layer = find_layer_by_name(layer_name)
	layer.toggle_alpha_locked()


func is_alpha_locked() -> bool:
	return active_layer.alpha_locked


func get_content_margin() -> Rect2:
	var rect = Rect2(999999, 999999, -999999, -999999)
	
	preview_layer.image.get_used_rect()
	for layer in layers:
		
		var r = layer.image.get_used_rect()
		
		if r.position.x < rect.position.x:
			rect.position.x = r.position.x
		if r.position.y < rect.position.y:
			rect.position.y = r.position.y
		if r.size.x > rect.size.x:
			rect.size.x = r.size.x
		if r.size.y > rect.size.y:
			rect.size.y = r.size.y
		
	return rect 


func crop_to_content():
	var rect = get_content_margin()
	
	#print(rect)
	
	for layer in layers:
		layer.image
	
#	set_canvas_width(rect.size.x)
#	set_canvas_height(rect.size.x)
	
#	preview_layer.resize(width, height)
#	tool_layer.resize(width, height)
#	for layer in layers:
#		layer.resize(width, height)


func get_active_layer():
	return active_layer


func get_preview_layer():
	return preview_layer


func clear_active_layer():
	active_layer.clear()


func clear_preview_layer():
	preview_layer.clear()


func clear_layer(layer_name: String):
	for layer in layers:
		if layer.name == layer_name:
			layer.clear()
			break


func remove_layer(layer_name: String):
	# change current layer if the active layer is removed
	var del_layer = find_layer_by_name(layer_name)
	del_layer.clear()
	if del_layer == active_layer:
		for layer in layers:
			if layer == preview_layer or layer == active_layer or layer == tool_layer:
				continue
			active_layer = layer
			break
	layers.erase(del_layer)
	return active_layer


func add_new_layer(layer_name: String):
	for layer in layers:
		if layer.name == layer_name:
			return
	var layer = GELayer.new()
	layer.name = layer_name
	
	if layer_name == "Preview":
		layer.create($PreviewLayer, canvas_width, canvas_height)
	elif layer_name == "Tool":
		layer.create($ToolPreviewLayer, canvas_width, canvas_height)
	else:
		var texture_rect = TextureRect.new()
		texture_rect.name = layer_name
		canvas_layers.add_child(texture_rect, true)
		texture_rect.expand = true
		texture_rect.anchor_right = 1
		texture_rect.anchor_bottom = 1
		texture_rect.margin_right = 0
		texture_rect.margin_bottom = 0
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		layer.create(texture_rect, canvas_width, canvas_height)
		layers.append(layer)
	
	return layer


func duplicate_layer(layer_name: String, new_layer_name: String):
	for layer in layers:
		if layer.name == new_layer_name:
			return
	
	var dup_layer :GELayer = find_layer_by_name(layer_name)
	var layer :GELayer = add_new_layer(new_layer_name)
	layer.image.copy_from(dup_layer.image)
	return layer


func toggle_layer_visibility(layer_name: String):
	for layer in layers:
		if layer.name == layer_name:
			layer.visible = not layer.visible


func find_layer_by_name(layer_name: String):
	for layer in layers:
		if layer.name == layer_name:
			return layer
	return null


func toggle_lock_layer(layer_name: String):
	find_layer_by_name(layer_name).toggle_lock()


func is_active_layer_locked() -> bool:
	return active_layer.locked


func move_layer_forward(layer_name: String):
	var layer = find_layer_by_name(layer_name).texture_rect_ref
	var new_idx = max(layer.get_index() - 1, 0)
	canvas_layers.move_child(layer, new_idx)


func move_layer_back(layer_name: String):
	var layer = find_layer_by_name(layer_name).texture_rect_ref
	canvas_layers.move_child(layer, layer.get_index() + 1)


func select_layer(layer_name: String):
	active_layer = find_layer_by_name(layer_name)


#-------------------------------
# Check 
#-------------------------------

func _on_mouse_entered():
	mouse_on_top = true


func _on_mouse_exited():
	mouse_on_top = false


func is_inside_canvas(x, y):
	if x < 0 or y < 0:
		return false
	if x >= canvas_width or y >= canvas_height:
		return false
	return true



#-------------------------------
# Basic pixel-layer options
#-------------------------------


#Note: Arrays are always passed by reference. To get a copy of an array which 
#      can be modified independently of the original array, use duplicate.
# (https://docs.godotengine.org/en/stable/classes/class_array.html)
func set_pixel_arr(pixels: Array, color: Color):
	for pixel in pixels:
		_set_pixel(active_layer, pixel.x, pixel.y, color)


func set_pixel_v(pos: Vector2, color: Color):
	set_pixel(pos.x, pos.y, color)


func set_pixel(x: int, y: int, color: Color):
	_set_pixel(active_layer, x, y, color)


func _set_pixel_v(layer: GELayer, v: Vector2, color: Color):
	_set_pixel(layer, v.x, v.y, color)


func _set_pixel(layer: GELayer, x: int, y: int, color: Color):
	if not is_inside_canvas(x, y):
		return
	layer.set_pixel(x, y, color)


func get_pixel_v(pos: Vector2):
	return get_pixel(pos.x, pos.y)


func get_pixel(x: int, y: int):
	if active_layer:
		return active_layer.get_pixel(x, y)
	return null


func set_preview_pixel_v(pos: Vector2, color: Color):
	set_preview_pixel(pos.x, pos.y, color)


func set_preview_pixel(x:int, y: int, color: Color):
	if not is_inside_canvas(x, y):
		return
	preview_layer.set_pixel(x, y, color)


func get_preview_pixel_v(pos: Vector2):
	return get_preview_pixel(pos.x, pos.y)


func get_preview_pixel(x: int, y: int):
	if not preview_layer: 
		return null
	return preview_layer.get_pixel(x, y)



#-------------------------------
# Grid
#-------------------------------


func toggle_grid():
	$Grid.visible = not $Grid.visible


func show_grid():
	$Grid.show()


func hide_grid():
	$Grid.hide()


#-------------------------------
# Handy tools
#-------------------------------


func select_color(x, y):
	print("???")
	var same_color_pixels = []
	var color = get_pixel(x, y)
	for x in range(active_layer.layer_width):
		for y in range(active_layer.layer_height):
			var pixel_color = active_layer.get_pixel(x, y)
			if pixel_color == color:
				same_color_pixels.append(color)
	return same_color_pixels


func select_same_color(x, y):
	return get_neighbouring_pixels(x, y)


# returns array of Vector2
# yoinked from 
# https://www.geeksforgeeks.org/flood-fill-algorithm-implement-fill-paint/
func get_neighbouring_pixels(pos_x: int, pos_y: int) -> Array:
	var pixels = []
	
	var to_check_queue = []
	var checked_queue = []
	
	to_check_queue.append(GEUtils.to_1D(pos_x, pos_y, canvas_width))
	
	var color = get_pixel(pos_x, pos_y)
	
	while not to_check_queue.empty():
		var idx = to_check_queue.pop_front()
		var p = GEUtils.to_2D(idx, canvas_width)
		
		if idx in checked_queue:
			continue
		
		checked_queue.append(idx)
		
		if get_pixel(p.x, p.y) != color:
			continue
		
		# add to result
		pixels.append(p)
		
		# check neighbours
		var x = p.x - 1
		var y = p.y
		if is_inside_canvas(x, y):
			idx = GEUtils.to_1D(x, y, canvas_width)
			to_check_queue.append(idx)
		
		x = p.x + 1
		if is_inside_canvas(x, y):
			idx = GEUtils.to_1D(x, y, canvas_width)
			to_check_queue.append(idx)
		
		x = p.x
		y = p.y - 1
		if is_inside_canvas(x, y):
			idx = GEUtils.to_1D(x, y, canvas_width)
			to_check_queue.append(idx)
		
		y = p.y + 1
		if is_inside_canvas(x, y):
			idx = GEUtils.to_1D(x, y, canvas_width)
			to_check_queue.append(idx)
	
	return pixels

