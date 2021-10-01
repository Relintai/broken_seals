tool
class_name Palette
extends Reference

var name: String = "Palette"
var colors: Array = [] # of Color
var comments: String = ""
var path: String = ""

func add_color(p_color : Color, p_index: int = -1) -> void:
	if p_index != -1:
		colors.insert(p_index, p_color)
	else:
		colors.append(p_color)


func change_color(p_index: int, p_color: Color) -> void:
	colors[p_index] = p_color


func reorder_color(p_index_from: int, p_index_to: int):
	if p_index_from == p_index_to:
		return
	
	var moving_color = colors[p_index_from]
	if p_index_from < p_index_to:
		colors.remove(p_index_from)
		colors.insert(p_index_to, moving_color)
	
	if p_index_from > p_index_to:
		colors.remove(p_index_from)
		colors.insert(p_index_to, moving_color)


func remove_color(p_index: int):
	colors.remove(p_index)


func save():
	if path.ends_with(".gpl") == false:
		push_error("To export gpl, file name must end in .gpl")
		return

	var file = File.new()
	file.open(path, file.WRITE)
	file.store_line("GIMP Palette")

	var comment_lines = comments.split("\n")
	for cl in comment_lines:
		file.store_line("# " + cl)
	
	for c in colors:
		var color_data = [
			str(c.r8), 
			str(c.g8), 
			str(c.b8), 
			"Untitled"
		]

		var line = PoolStringArray(color_data).join(" ")
		file.store_line(line)

	file.close()
