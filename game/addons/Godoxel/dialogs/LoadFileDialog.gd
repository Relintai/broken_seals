tool
extends FileDialog


var canvas: GECanvas

var file_path = ""


func _ready():
	get_line_edit().connect("text_entered", self, "_on_LineEdit_text_entered")
	invalidate()
	clear_filters()
	add_filter("*.png ; PNG Images")


func _on_LineEdit_text_entered(_text):
	return
#	print(_text)
	#load_img()
#	print("hsadfasd")


func _on_LoadFileDialog_file_selected(path):
	file_path = path
	#print("1ere")
	load_img()


func _on_LoadFileDialog_confirmed():
	return
	#print("ere")
	#load_img()


func load_img():
	var image = Image.new()
	if image.load(file_path) != OK:
		print("couldn't load image!")
		return
	
	var image_data = image.get_data()
	var layer: GELayer = owner.add_new_layer()
	
	var width = image.get_width()
	var height = image.get_height()
	
	if owner.paint_canvas.canvas_width < width:
		owner.paint_canvas.resize(width, owner.paint_canvas.canvas_height)
	
	if owner.paint_canvas.canvas_height < height:
		owner.paint_canvas.resize(owner.paint_canvas.canvas_width, height)
	
	for i in range(image_data.size() / 4):
		var color = Color(image_data[i*4] / 255.0, image_data[i*4+1] / 255.0, image_data[i*4+2] / 255.0, image_data[i*4+3] / 255.0)
		var pos = GEUtils.to_2D(i, image.get_width())
		if pos.x > layer.layer_width:
			continue
			
		layer.set_pixel(pos.x, pos.y, color)
	layer.update_texture()



func _on_LoadFileDialog_about_to_show():
	invalidate()


func _on_LoadFileDialog_visibility_changed():
	invalidate()
