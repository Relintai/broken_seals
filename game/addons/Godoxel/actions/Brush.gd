extends GEAction
class_name GEBrush


func do_action(canvas: GECanvas, data: Array):
	.do_action(canvas, data)
	
	for pixel in GEUtils.get_pixels_in_line(data[0], data[1]):
		for off in BrushPrefabs.get_brush(data[3], data[4]):
			var p = pixel + off
			
			if p in action_data.undo.cells or canvas.get_pixel_v(p) == null:
				continue
			
			if canvas.is_alpha_locked() and canvas.get_pixel_v(p) == Color.transparent:
				continue
			
			action_data.undo.colors.append(canvas.get_pixel_v(p))
			action_data.undo.cells.append(p)
			
			canvas.set_pixel_v(p, data[2])
		
			action_data.redo.cells.append(p)
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



