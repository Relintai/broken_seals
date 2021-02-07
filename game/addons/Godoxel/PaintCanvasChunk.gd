tool
extends Control

var image = Image.new()
var image_texture = ImageTexture.new()

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func setup(region_size):
	image.create(region_size, region_size, true, Image.FORMAT_RGBA8)
	image.lock()

func update_chunk():
	image_texture.create_from_image(image)
	image_texture.set_flags(0)
	self.texture = image_texture

func set_cell(x, y, color):
	image.set_pixel(x, y, color)
	update_chunk()

func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
