tool
extends Control

export var color = Color()
export var size:int = 16
export var zoom = 0
export var offset = Vector2(0, 0)


func _enter_tree():
	set_process(true)


func _draw():
	if size == 0:
		size = 1
	
	var temp_size = size + zoom
	
	var wrap_offset = Vector2(wrapf(offset.x, 0, temp_size), wrapf(offset.y, 0, temp_size))

	var ceil_x = ceil(rect_size.x / temp_size)
	var ceil_y = ceil(rect_size.y / temp_size)
	
	for i in ceil_y:
		var start_x = Vector2(0, (i * temp_size) + wrap_offset.y)
		var end_x = Vector2(rect_size.x, (i * temp_size) + wrap_offset.y)
#		var end_x = Vector2(int(rect_size.x) + size - int(rect_size.x) % size, (i * temp_size) + wrap_offset.y)
		draw_line(start_x, end_x, color, 1)
	
	for i in ceil_x:
		var start_y = Vector2((i * temp_size) + wrap_offset.x, 0)
		var end_y = Vector2((i * temp_size) + (wrap_offset.x), rect_size.y)
#		var end_y = Vector2((i * temp_size) + (wrap_offset.x), int(rect_size.y) + size - int(rect_size.y) % size)
		draw_line(start_y, end_y, color, 1)


func _process(delta):
	if not is_visible_in_tree():
		return
	update()
