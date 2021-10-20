tool
extends Control

var MMCurve = preload("res://addons/mat_maker_gd/nodes/bases/curve_base.gd")

export var show_axes : bool = false

var curve #: MMCurve

func _ready() -> void:
#	curve = MMCurve.new()
	connect("resized", self, "_on_resize")
	update()

func set_curve(val) -> void:
	curve = val
	update()

func transform_point(p : Vector2) -> Vector2:
	return (Vector2(0.0, 1.0)+Vector2(1.0, -1.0)*p)*rect_size

func reverse_transform_point(p : Vector2) -> Vector2:
	return Vector2(0.0, 1.0)+Vector2(1.0, -1.0)*p/rect_size

func _draw():
	if !curve:
		return
	
#	var current_theme : Theme = get_node("/root/MainWindow").theme
#
#	var bg = current_theme.get_stylebox("panel", "Panel").bg_color
#	var fg = current_theme.get_color("font_color", "Label")
#
#	var axes_color : Color = bg.linear_interpolate(fg, 0.25)
#	var curve_color : Color = bg.linear_interpolate(fg, 0.75)
	
	var axes_color : Color = Color(0.9, 0.9, 0.9, 1)
	var curve_color : Color = Color(1, 1, 1, 1)
	
	if show_axes:
		for i in range(5):
			var p = transform_point(0.25*Vector2(i, i))
			draw_line(Vector2(p.x, 0), Vector2(p.x, rect_size.y-1), axes_color)
			draw_line(Vector2(0, p.y), Vector2(rect_size.x-1, p.y), axes_color)
			
	var points = curve.get_points()
			
	for i in range(points.size() - 1):
		var p1 = points[i].p
		var p2 = points[i+1].p
		var d = (p2.x-p1.x)/3.0
		var yac = p1.y+d*points[i].rs
		var ybc = p2.y-d*points[i+1].ls
		var p = transform_point(p1)
		var count : int = max(1, int((transform_point(p2).x-p.x/5.0)))
		
		for tt in range(count):
			var t = (tt+1.0)/count
			var omt = (1.0 - t)
			var omt2 = omt * omt
			var omt3 = omt2 * omt
			var t2 = t * t
			var t3 = t2 * t
			var x = p1.x+(p2.x-p1.x)*t
			var np = transform_point(Vector2(x, p1.y*omt3 + yac*omt2*t*3.0 + ybc*omt*t2*3.0 + p2.y*t3))
			draw_line(p, np, curve_color)
			p = np

func _on_resize() -> void:
	update()
