extends GEAction
class_name GEPencil


func do_action(canvas, data: Array):
	.do_action(canvas, data)
	
	var pixels = GEUtils.get_pixels_in_line(data[0], data[1])
	for pixel in pixels:
		for p in get_points(canvas, pixel):
			_set_pixel(canvas, p, data[2])


func _set_pixel(canvas, pixel, color):
	action_data.undo.colors.append(canvas.get_pixel_v(pixel))
	action_data.undo.cells.append(pixel)
	canvas.set_pixel_v(pixel, color)
	
	action_data.redo.cells.append(pixel)
	action_data.redo.colors.append(color)


func commit_action(canvas):
	var cells = action_data.redo.cells
	var colors = action_data.redo.colors
	return []


func undo_action(canvas):
	var cells = action_data.undo.cells
	var colors = action_data.undo.colors
	for idx in range(cells.size()):
		canvas._set_pixel_v(action_data.layer, cells[idx], colors[idx])


func redo_action(canvas):
	var cells = action_data.redo.cells
	var colors = action_data.redo.colors
	for idx in range(cells.size()):
		canvas._set_pixel_v(action_data.layer, cells[idx], colors[idx])



