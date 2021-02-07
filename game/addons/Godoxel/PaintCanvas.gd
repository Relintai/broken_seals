tool
extends Control

var image = Image.new()
var last_pixel = []
onready var canvas_image_node = get_node("CanvasImage")
export var grid_size = 16
export var canvas_size = Vector2(48, 28)
export var region_size = 10
export var can_draw = true

var mouse_in_region
var mouse_on_top

#terms
#global cell - a cell that has a global grid position on the canvas
#local cell - a cell that has a local grid position in a chunk region on the canvas
#chunk region - a set of cells contained in an even number

#TODO: Maybe each chunk region can hold an image resource so that way the engine wouldn't lag at all when updating the canvas

var layers = {}
var active_layer

var preview_layer = "preview"
var preview_enabled = false


func _enter_tree():
	#----------------------
	# init Layer
	#----------------------
	layers[preview_layer] = {
		"layer": null,
		"data": [],
		"chunks": null,
	}
	
	canvas_size = Vector2(int(rect_size.x / grid_size), int(rect_size.y / grid_size))
	#print("canvas_size: ", canvas_size)


func _ready():
	active_layer = add_existing_layer(get_tree().get_nodes_in_group("layer")[0])
	#print("active Layer: ", active_layer)


func get_layer_data(layer_name):
	return layers[layer_name]


func get_active_layer():
	return layers[active_layer]


func get_preview_layer():
	return layers[preview_layer]


func clear_active_layer():
	for pixel in layers[active_layer].data:
		set_global_cell_in_chunk(pixel[0], pixel[1], Color(0,0,0,0))


func clear_layer(layer_name: String):
	for pixel in layers[layer_name].data:
		set_global_cell_in_chunk(pixel[0], pixel[1], Color(0,0,0,0))


func clear_preview_layer():
	for pixel in layers["preview"].data:
		set_global_cell_in_chunk(pixel[0], pixel[1], Color(0,0,0,0))


func remove_layer(layer_name):
	get_node("ChunkNodes").remove_child(layers[layer_name].chunks)
	layers[layer_name].chunks.queue_free()
	
	layers.erase(layer_name)
	
	if active_layer == layer_name:
		for layer in layers:
			if layer == preview_layer:
				continue
			active_layer = layer
			break
	
	return active_layer
	


# only needed for init
func add_existing_layer(layer):
	layers[layer.name] = {
		"layer": layer,
		"data": [],
		"chunks": null,
	}
	generate_chunks()
	return layer.name


func add_new_layer(layer_name):
	layers[layer_name] = {
		"layer": null,
		"data": [],
		"chunks": null,
	}
	
	generate_chunks()
	
	return layer_name


func duplicate_layer(layer: String, neu_layer_name: String):
	var _preview = preview_enabled
	preview_enabled = false
	var _temp = active_layer
	active_layer = neu_layer_name
	
	layers[neu_layer_name] = {
		"layer": null,
		"data": layers[layer].data.duplicate(true),
		"chunks": null,
	}
	
	generate_chunks()
#	get_node("ChunkNodes").remove_child(layers[neu_layer_name].chunks)
#	get_node("ChunkNodes").add_child_below_node(layers[layer].chunks, layers[neu_layer_name].chunks, true)
	
	for pixel in layers[neu_layer_name].data:
		set_pixel_cell(pixel[0], pixel[1], pixel[2])
	active_layer = _temp
	
	preview_enabled = _preview
	return neu_layer_name


func toggle_layer_visibility(layer_name):
	layers[layer_name].chunks.visible = not layers[layer_name].chunks.visible
	#print("Layer: ", layer_name, " is now: ", layers[layer_name].chunks.visible)


var util = preload("res://addons/Godoxel/Util.gd")


func _on_mouse_entered():
	mouse_on_top = true


func _on_mouse_exited():
	mouse_on_top = false


func _process(delta):
	var mouse_position = get_local_mouse_position()
	var rect = Rect2(Vector2(0, 0), rect_size)
	mouse_in_region = rect.has_point(mouse_position)
	update()
	#if not Engine.editor_hint:
	#	print(mouse_on_canvas, " | ", has_focus())
	#draw_canvas_out just updates the image constantly
	#if can_draw:
	#	draw_canvas_out()


func generate_chunks():
	var maxium_chunk_size = get_maxium_filled_chunks()
	#TODO: We probably don't need to check for x and y anymore
	for key in layers:
		if layers[key].chunks != null:
			continue
		
		var chunk_node = Control.new()
		get_node("ChunkNodes").add_child(chunk_node)
		chunk_node.owner = self
		
		layers[key].chunks = chunk_node
		
		for x in maxium_chunk_size.x:
			for y in maxium_chunk_size.y:
				var paint_canvas_chunk = load("res://addons/Godoxel/PaintCanvasChunk.tscn").instance()
				paint_canvas_chunk.setup(region_size)
				paint_canvas_chunk.name = "C-%s-%s" % [x, y]
				paint_canvas_chunk.rect_position = Vector2(x * (grid_size * region_size), y * (grid_size * region_size))
				layers[key].chunks.add_child(paint_canvas_chunk)


func get_maxium_filled_chunks():
	return Vector2(canvas_size.x / region_size, canvas_size.y / region_size).ceil()

#TODO: Remake these functions with godot's setget features
#so that we don't have to call these functions
func resize_grid(grid):
	#print(grid)
	if grid <= 0:
		return
	grid_size = grid
	canvas_image_node.rect_scale = Vector2(grid, grid)

func resize_canvas(x, y):
	image.unlock()
	image.create(x, y, true, Image.FORMAT_RGBA8)
	canvas_size = Vector2(x, y)
	#setup_all_chunks()
	image.lock()

#func draw_canvas_out(a = ""):
#	if canvas_image_node == null:
#		return
#	var image_texture = ImageTexture.new()
#	image_texture.create_from_image(image)
#	image_texture.set_flags(0)
#	canvas_image_node.texture = image_texture

func get_wrapped_region_cell(x, y):
	return Vector2(wrapi(x, 0, region_size), wrapi(y, 0, region_size))

func get_region_from_cell(x, y):
	return Vector2(floor(x / region_size), floor(y / region_size))


func set_local_cell_in_chunk(chunk_x, chunk_y, local_cell_x, local_cell_y, color):
	var chunk_node
	
	if preview_enabled:
		chunk_node = layers.preview.chunks.get_node_or_null("C-%s-%s" % [chunk_x, chunk_y])
	else:
		chunk_node = layers[active_layer].chunks.get_node_or_null("C-%s-%s" % [chunk_x, chunk_y])
	
	if chunk_node == null:
		#print("Can't find chunk node!")
		return
	chunk_node.set_cell(local_cell_x, local_cell_y, color)


func set_global_cell_in_chunk(cell_x, cell_y, color):
	var chunk = get_region_from_cell(cell_x, cell_y)
	var wrapped_cell = get_wrapped_region_cell(cell_x, cell_y)
	set_local_cell_in_chunk(chunk.x, chunk.y, wrapped_cell.x, wrapped_cell.y, color)

#func update_chunk_region_from_cell(x, y):
#	var region_to_update = get_region_from_cell(x, y)
#	update_chunk_region(region_to_update.x, region_to_update.y)

func get_pixel_cell_color(x, y):
	if not cell_in_canvas_region(x, y):
		return null
	var pixel_cell = get_pixel_cell(x, y)
	if pixel_cell == null:
		#We already checked that the cell can't be out of the canvas region so we can assume the pixel cell is completely transparent if it's null
		return Color(0, 0, 0, 0)
	else:
		return util.color_from_array(pixel_cell[2])

func get_pixel_cell_color_v(vec2):
	return get_pixel_cell_color(vec2.x, vec2.y)

func get_pixel_cell(x, y):
	if active_layer == null:
		return
	if not cell_in_canvas_region(x, y):
		return null
	
	for pixel in get_active_layer().data:
		if pixel[0] == x and pixel[1] == y:
			return pixel
	
	return null

func get_pixel_cell_v(vec2):
	return get_pixel_cell(vec2.x, vec2.y)

#func remove_pixel_cell(x, y):
#	if can_draw == false:
#		return false
#	if not cell_in_canvas_region(x, y):
#		return false
#	var layer_data = get_layer_data("Layer 1")
#	for pixel in range(0, layer_data.size()):
#		if layer_data[pixel][0] == x and layer_data[pixel][1] == y:
#			layer_data.remove(pixel)
#			#update_chunk_region_from_cell(x, y)
#			#TOOD: If pixel exists in temp_pool_pixels then remove it
#			image.set_pixel(x, y, Color(0, 0, 0, 0))
#			return true
#	return false

#func remove_pixel_cell_v(vec2):
#	return remove_pixel_cell(vec2.x, vec2.y)

func set_pixel_cell(x, y, color):
	if can_draw == false:
		return false
	
	if not cell_in_canvas_region(x, y):
		return false
	
	var layer
	if preview_enabled:
		layer = get_preview_layer()
	else:
		layer = get_active_layer()
	
	var index = 0
	for pixel in layer.data:
		#TODO: Make a better way of accessing the array because the more pixels we have, the longer it takes to
		#set the pixel
		if pixel[0] == x and pixel[1] == y:
			#No reason to set the pixel again if the colors are the same
			
			#If the color we are setting is 0, 0, 0, 0 then there is no reason to keep the information about the pixel
			#so we remove it from the layer data
			if color == Color(0, 0, 0, 0):
				layer.data.remove(index)
			else:
				pixel[2] = color
			#TODO: The new system is going to allow chunks to each have their own TextureRect and Image
			#nodes so what we are doing in here is that we are setting the local cell in the region of that image
			set_global_cell_in_chunk(x, y, color)
			last_pixel = [x, y, color]
			return true
		index += 1
	#don't append any data if the color is 0, 0, 0, 0
	if color != Color(0, 0, 0, 0):
		#if the pixel data doesn't exist then we add it in
		layer.data.append([x, y, color])
	set_global_cell_in_chunk(x, y, color)
	last_pixel = [x, y, color]
	return true

func set_pixel_cell_v(vec2, color):
	return set_pixel_cell(vec2.x, vec2.y, color)

func set_pixels_from_line(vec2_1, vec2_2, color):
	var points = get_pixels_from_line(vec2_1, vec2_2)
	for i in points:
		set_pixel_cell_v(i, color)

func set_random_pixels_from_line(vec2_1, vec2_2):
	var points = get_pixels_from_line(vec2_1, vec2_2)
	for i in points:
		set_pixel_cell_v(i, util.random_color_alt())

func get_pixels_from_line(vec2_1, vec2_2):
	var points = PoolVector2Array()
	
	var dx = abs(vec2_2.x - vec2_1.x)
	var dy = abs(vec2_2.y - vec2_1.y)
	
	var x = vec2_1.x
	var y = vec2_1.y
	
	var sx = 0
	if vec2_1.x > vec2_2.x:
		sx = -1
	else:
		sx = 1

	var sy = 0
	if vec2_1.y > vec2_2.y:
		sy = -1
	else:
		sy = 1
		
	if dx > dy:
		var err = dx / 2
		while(true):
			if x == vec2_2.x:
				break
			points.push_back(Vector2(x, y))
			
			err -= dy
			if err < 0:
				y += sy
				err += dx
			x += sx
	else:
		var err = dy / 2
		while (true):
			if y == vec2_2.y:
				break
			points.push_back(Vector2(x, y))
			
			err -= dx
			if err < 0:
				x += sx
				err += dy
			y += sy
	points.push_back(Vector2(x, y))
	return points


#even though the function checks for it, we can't afford adding more functions to the call stack
#because godot has a limit until it crashes
var flood_fill_queue = 0
func flood_fill(x, y, target_color, replacement_color):
	#yield(get_tree().create_timer(1), "timeout")
	flood_fill_queue += 1
	if not cell_in_canvas_region(x, y):
		flood_fill_queue -= 1
		return
	if target_color == replacement_color:
		flood_fill_queue -= 1
		return
	elif not get_pixel_cell_color(x, y) == target_color:
		flood_fill_queue -= 1
		return
	else:
		set_pixel_cell(x, y, replacement_color)
	if flood_fill_queue >= 500:
		#print(flood_fill_queue)
		yield(get_tree().create_timer(0.01), "timeout")
	#up
	if get_pixel_cell_color(x, y - 1) == target_color:
		flood_fill(x, y - 1, target_color, replacement_color)
	#down
	if get_pixel_cell_color(x, y + 1) == target_color:
		flood_fill(x, y + 1, target_color, replacement_color)
	#left
	if get_pixel_cell_color(x - 1, y) == target_color:
		flood_fill(x - 1, y, target_color, replacement_color)
	#right
	if get_pixel_cell_color(x + 1, y) == target_color:
		flood_fill(x + 1, y, target_color, replacement_color)
	flood_fill_queue -= 1
	return

#func flood_fill_erase(x, y, target_color):
#	yield(get_tree().create_timer(0.001), "timeout")
#	if not cell_in_canvas_region(x, y):
#		print("cell not in canvas")
#		return
#	#if target_color == replacement_color:
#	#	return
#	elif not get_pixel_cell_color(x, y) == target_color:
#		print("cell doesn't match pixel color")
#		return
#	elif not get_pixel_cell(x, y):
#		print("cell already erased")
#		return
#	else:
#		print("removed pixel")
#		remove_pixel_cell(x, y)
#	print("x: ", x, " y: ", y, " color: ", target_color)
#	#up
#	flood_fill_erase(x, y - 1, target_color)
#	#down
#	flood_fill_erase(x, y + 1, target_color)
#	#left
#	flood_fill_erase(x - 1, y, target_color)
#	#right
#	flood_fill_erase(x + 1, y, target_color)
#	return

func cell_in_canvas_region(x, y):
	if x > canvas_size.x - 1 or x < 0 or y > canvas_size.y - 1 or y < 0:
		#out of bounds, return false
		return false
	else:
		return true

#Both of these functions right now just return the starting position of the canvas and the last position of the canvas
func get_all_used_regions_in_canvas():
	var first_used_region = get_first_used_region_in_canvas()
	var last_used_region = get_last_used_region_in_canvas()
	var chunk_pool = PoolVector2Array()
	for chunk_x in range(first_used_region.x, last_used_region.x):
		for chunk_y in range(first_used_region.y, last_used_region.y):
			chunk_pool.append(Vector2(chunk_x, chunk_y))
	return chunk_pool

func get_first_used_region_in_canvas():
	return get_region_from_cell(0, 0)

func get_last_used_region_in_canvas():
	return get_region_from_cell(canvas_size.x - 1, canvas_size.y - 1)

func get_cells_in_region(x, y):
	var start_cell = Vector2(x * region_size, y * region_size)
	var end_cell = Vector2((x * region_size) + region_size, (y * region_size) + region_size)
	var cell_array = []
	for cx in range(start_cell.x, end_cell.x):
		for cy in range(start_cell.y, end_cell.y):
			var pixel_cell = get_pixel_cell(cx, cy)
			if pixel_cell == null:
				pixel_cell = [cx, cy, Color(0, 0, 0, 0)]
			cell_array.append(pixel_cell)
	return cell_array
