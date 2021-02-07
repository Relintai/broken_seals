extends GEAction
class_name GEPasteCut


#data[2] = selection_pos
#data[3] = selection_color
#data[4] = cut pos
#data[5] = cut size
func do_action(canvas, data: Array):
	.do_action(canvas, data)
	
	for pixel_pos in GEUtils.get_pixels_in_line(data[0], data[1]):
		for idx in range(data[2].size()):
			var pixel = data[2][idx]
			var color = data[3][idx]
			pixel -= data[4] + data[5] / 2
			pixel += pixel_pos
			
			if canvas.get_pixel_v(pixel) == null:
				continue
			
			if canvas.is_alpha_locked() and canvas.get_pixel_v(pixel) == Color.transparent:
				continue
			
			var found = action_data.redo.cells.find(pixel)
			if found == -1:
				action_data.redo.cells.append(pixel)
				action_data.redo.colors.append(color)
			else:
				action_data.redo.colors[found] = color
			
			found = action_data.undo.cells.find(pixel)
			if found == -1:
				action_data.undo.colors.append(canvas.get_pixel_v(pixel))
				action_data.undo.cells.append(pixel)
			
			canvas.set_pixel_v(pixel, color)


func commit_action(canvas):
	canvas.clear_preview_layer()
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



