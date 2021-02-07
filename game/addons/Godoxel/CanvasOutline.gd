tool
extends Control

export var color = Color()


func _ready():
	pass


func _draw():
	var size = get_parent().rect_size
	var pos = Vector2.ZERO #get_parent().rect_global_position
	draw_outline_box(pos, size, color, 1)


func draw_outline_box(pos, size, color, width):
		#Top line
		draw_line(pos, pos + Vector2(size.x, 0), color, width)
		#Left line
		draw_line(pos, pos + Vector2(0, size.y), color, width)
		#Bottom line
		draw_line(pos + Vector2(0, size.y), pos + Vector2(size.x, size.y), color, width)
		#Right line
		draw_line(pos + Vector2(size.x, 0), pos + Vector2(size.x, size.y), color, width)


func _process(delta):
	if not is_visible_in_tree():
		return
	update()
