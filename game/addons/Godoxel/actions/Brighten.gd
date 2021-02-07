extends GEAction
class_name GEBrighten


const brighten_color = 0.1


func do_action(canvas, data: Array):
	.do_action(canvas, data)
	
	var pixels = GEUtils.get_pixels_in_line(data[0], data[1])
	for pixel in pixels:
		if canvas.get_pixel_v(pixel) == null:
			continue
		
		if canvas.is_alpha_locked() and canvas.get_pixel_v(pixel) == Color.transparent:
			continue
		
		if pixel in action_data.undo.cells:
			var brightened_color = canvas.get_pixel_v(pixel).lightened(0.1)
			canvas.set_pixel_v(pixel, brightened_color)
		
			action_data.redo.cells.append(pixel)
			action_data.redo.colors.append(brightened_color)
			continue
		
		action_data.undo.colors.append(canvas.get_pixel_v(pixel))
		action_data.undo.cells.append(pixel)
		var brightened_color = canvas.get_pixel_v(pixel).lightened(0.1)
		canvas.set_pixel_v(pixel, brightened_color)
	
		action_data.redo.cells.append(pixel)
		action_data.redo.colors.append(brightened_color)


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
