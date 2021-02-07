extends GEAction
class_name GECut

const selection_color = Color(0.8, 0.8, 0.8, 0.5)
var mouse_start_pos = null
var mouse_end_pos = null


func can_commit() -> bool:
	return false #ugly way of handling a cut


func do_action(canvas, data: Array):
	.do_action(canvas, data)
	
	if mouse_start_pos == null:
		mouse_start_pos = data[0]
	mouse_end_pos = data[0]
	
	action_data.preview.cells.clear()
	action_data.preview.colors.clear()
	canvas.clear_preview_layer()
	
	var p = mouse_start_pos
	var s = mouse_end_pos - mouse_start_pos
	
	var pixels = GEUtils.get_pixels_in_line(p, p + Vector2(s.x, 0))
	pixels += GEUtils.get_pixels_in_line(p, p + Vector2(0, s.y))
	pixels += GEUtils.get_pixels_in_line(p + s, p + s + Vector2(0, -s.y))
	pixels += GEUtils.get_pixels_in_line(p + s, p + s  + Vector2(-s.x, 0))
	
	for pixel in pixels:
		canvas.set_preview_pixel_v(pixel, selection_color)
		action_data.preview.cells.append(pixel)
		action_data.preview.colors.append(selection_color)


func commit_action(canvas):
	canvas.clear_preview_layer()
	var p = mouse_start_pos
	var s = mouse_end_pos - mouse_start_pos
	
	for x in range(abs(s.x)+1):
		for y in range(abs(s.y)+1):
			var px = x
			var py = y
			if s.x < 0:
				px *= -1
			if s.y < 0:
				py *= -1
			
			var pos = p + Vector2(px, py)
			var color = canvas.get_pixel(pos.x, pos.y)
			
			if color == null or color.a == 0.0:
				continue
			
			action_data.redo.cells.append(pos)
			action_data.redo.colors.append(canvas.get_pixel_v(pos))
			
			canvas.set_pixel_v(pos, Color.transparent)
			
			action_data.undo.cells.append(pos)
			action_data.undo.colors.append(Color.transparent)
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



