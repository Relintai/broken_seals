extends GEAction
class_name GEBucket



func do_action(canvas, data: Array):
	.do_action(canvas, data)
	
	if canvas.get_pixel_v(data[0]) == data[2]:
		return
	var pixels = canvas.select_same_color(data[0].x, data[0].y)
	
	for pixel in pixels:
		if pixel in action_data.undo.cells:
				continue
			
		if canvas.is_alpha_locked() and canvas.get_pixel_v(pixel) == Color.transparent:
			continue
		
		action_data.undo.colors.append(canvas.get_pixel_v(pixel))
		action_data.undo.cells.append(pixel)
		
		canvas.set_pixel_v(pixel, data[2])
	
		action_data.redo.cells.append(pixel)
		action_data.redo.colors.append(data[2])


func commit_action(canvas):
	var cells = action_data.preview.cells
	var colors = action_data.preview.colors
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



