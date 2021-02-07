extends GEAction
class_name GEMultiLine


func can_commit() -> bool:
	return false


func update_action(canvas, data: Array):
	.update_action(canvas, data)
	
	var pixels = GEUtils.get_pixels_in_line(data[0], data[1])
	for pixel in pixels:
		if pixel in action_data.undo.cells or canvas.get_pixel_v(pixel) == null or canvas.is_alpha_locked():
			continue
		action_data.undo.colors.append(canvas.get_pixel_v(pixel))
		action_data.undo.cells.append(pixel)
		canvas.set_pixel_v(pixel, data[2])
	
		action_data.redo.cells.append(pixel)
		action_data.redo.colors.append(data[2])


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



