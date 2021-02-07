extends Node
class_name GEAction


var action_data = {}


func _init():
	action_data["redo"] = {}
	action_data["undo"] = {}
	action_data["preview"] = {}


func do_action(canvas, data: Array):
	if not "cells" in action_data.redo:
		action_data.redo["cells"] = []
		action_data.redo["colors"] = []
	
	if not "cells" in action_data.undo:
		action_data.undo["cells"] = []
		action_data.undo["colors"] = []
	
	if not "cells" in action_data.preview:
		action_data.preview["cells"] = []
		action_data.preview["colors"] = []
	
	if not "layer" in action_data:
		action_data["layer"] = canvas.active_layer


func commit_action(canvas):
	print("NO IMPL commit_action ")
	return []


func undo_action(canvas):
	print("NO IMPL undo_action ")


func redo_action(canvas):
	print("NO IMPL redo_action ")


func can_commit() -> bool:
	return not action_data.redo.empty()


func get_x_sym_points(canvas_width, pixel):
	var p = int(canvas_width - pixel.x)
	var all_points = [pixel, Vector2(p-1, pixel.y)]
	
	var points :Array = []
	for point in all_points:
		if point in points:
			continue
		points.append(point)
	return points


func get_y_sym_points(canvas_height, pixel):
	var p = int(canvas_height - pixel.y)
	var all_points = [pixel, Vector2(pixel.x, p-1)]
	
	var points :Array = []
	for point in all_points:
		if point in points:
			continue
		points.append(point)
	return points


func get_xy_sym_points(canvas_width, canvas_height, pixel):
	var all_points = []
	var xpoints = get_x_sym_points(canvas_width, pixel)
	
	all_points += get_y_sym_points(canvas_height, xpoints[0])
	all_points += get_y_sym_points(canvas_height, xpoints[1])
	
	var points :Array = []
	for point in all_points:
		if point in points:
			continue
		points.append(point)
	
	return points


func get_points(canvas, pixel):
	var points = []
	if canvas.symmetry_x and canvas.symmetry_y:
		var sym_points = get_xy_sym_points(canvas.canvas_width, canvas.canvas_height, pixel)
		for point in sym_points:
			if point in action_data.undo.cells or canvas.get_pixel_v(point) == null:
				continue
			if canvas.is_alpha_locked() and canvas.get_pixel_v(pixel) == Color.transparent:
				continue
			points.append(point)
	elif canvas.symmetry_y:
		var sym_points = get_y_sym_points(canvas.canvas_height, pixel)
		for point in sym_points:
			if point in action_data.undo.cells or canvas.get_pixel_v(point) == null:
				continue
			if canvas.is_alpha_locked() and canvas.get_pixel_v(pixel) == Color.transparent:
				continue
			points.append(point)
	elif canvas.symmetry_x:
		var sym_points = get_x_sym_points(canvas.canvas_width, pixel)
		for point in sym_points:
			if point in action_data.undo.cells or canvas.get_pixel_v(point) == null:
				continue
			if canvas.is_alpha_locked() and canvas.get_pixel_v(pixel) == Color.transparent:
				continue
			points.append(point)
	else:
		if pixel in action_data.undo.cells or canvas.get_pixel_v(pixel) == null:
			return []
		if canvas.is_alpha_locked() and canvas.get_pixel_v(pixel) == Color.transparent:
			return []
		points.append(pixel)
	
	return points


