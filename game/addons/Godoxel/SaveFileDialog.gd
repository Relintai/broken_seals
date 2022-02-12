tool
extends FileDialog

#var canvas

var file_path = ""


#func _enter_tree():
	#canvas = get_parent().find_node("Canvas")
	#canvas = get_parent().paint_canvas


func _ready():
	# warning-ignore:return_value_discarded
	get_line_edit().connect("text_entered", self, "_on_LineEdit_text_entered")
	invalidate()
	clear_filters()
	add_filter("*.png ; PNG Images")


func _on_SaveFileDialog_file_selected(path):
	#print("selected file: ", path)
	file_path = path
	save_file()


# warning-ignore:unused_argument
func _on_LineEdit_text_entered(text):
	return
#	print("text entered: ", text)


func _on_SaveFileDialog_confirmed():
	return
#	print("confirmed: ", current_path)


func save_file():
	var image = Image.new()
	var canvas = get_parent().paint_canvas
	image.create(canvas.canvas_width, canvas.canvas_height, true, Image.FORMAT_RGBA8)
	image.lock()
	
	for layer in canvas.layers:
		var idx = 0
		if not layer.visible:
			continue
		for x in range(layer.layer_width):
			for y in range(layer.layer_height):
				var color = layer.get_pixel(x, y)
				var image_color = image.get_pixel(x, y)
				
				if color.a != 0:
					image.set_pixel(x, y, image_color.blend(color))
				else:
					image.set_pixel(x, y, color)
	image.unlock()
	
	var dir = Directory.new()
	if dir.file_exists(file_path):
		dir.remove(file_path)
	
	image.save_png(file_path)


func _on_SaveFileDialog_about_to_show():
	invalidate()


func _on_SaveFileDialog_visibility_changed():
	invalidate()
