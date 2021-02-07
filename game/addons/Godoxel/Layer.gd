extends Reference
class_name GELayer


var name
var layer_width
var layer_height
var visible = true setget set_visible
var locked = false
var alpha_locked = false

var texture: ImageTexture
var image: Image
var texture_rect_ref


func _init():
	texture = ImageTexture.new()


func create(texture_rect_ref, width: int, height: int):
	self.texture_rect_ref = texture_rect_ref
	
	layer_width = width
	layer_height = height
	
	image = Image.new()
	image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(Color.transparent)
	update_texture()


func resize(width: int, height: int):
	var pixel_colors = []
	var prev_width = layer_width
	var prev_height = layer_height
	
	image.lock()
	for y in range(prev_height):
		for x in range(prev_width):
			pixel_colors.append(image.get_pixel(x, y))
	image.unlock()
	
	layer_width = width
	layer_height = height
	
	image.create(width, height, false, Image.FORMAT_RGBA8)
	
	image.lock()
	for x in range(prev_width):
		for y in range(prev_height):
			if x >= width or y >= height:
				continue
			image.set_pixel(x, y, pixel_colors[GEUtils.to_1D(x, y, prev_width)])
	image.unlock()
	
	update_texture()


func set_pixel(x, y, color):
	image.lock()
	image.set_pixel(x, y, color)
	image.unlock()


func get_pixel(x: int, y: int):
	if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
		return null
	image.lock()
	var pixel = image.get_pixel(x, y)
	image.unlock()
	return pixel


func clear():
	image.fill(Color.transparent)
	update_texture()


func update_texture():
	texture.create_from_image(image, 0)
	texture_rect_ref.texture = texture
	texture_rect_ref.margin_right = 0
	texture_rect_ref.margin_bottom = 0


func set_visible(vis: bool):
	visible = vis
	texture_rect_ref.visible = visible


func toggle_lock():
	locked = not locked


func toggle_alpha_locked():
	alpha_locked = not alpha_locked

