tool
extends WindowDialog

export var closed : bool = true setget set_closed
var previous_points : PoolVector2Array
var polygon

signal polygon_changed(polygon)

func set_closed(c : bool = true):
	closed = c
	window_title = "Edit polygon" if closed else "Edit polyline"
	$VBoxContainer/EditorContainer/PolygonEditor.set_closed(closed)

func _on_CurveDialog_popup_hide():
#	emit_signal("return_polygon", null)
	queue_free()
	pass

func _on_OK_pressed():
	emit_signal("polygon_changed", polygon)
	polygon.polygon_changed()
	
	queue_free()

func _on_Cancel_pressed():
	polygon.set_points(previous_points)
	emit_signal("polygon_changed", polygon)

	queue_free()

func edit_polygon(poly):
	polygon = poly
	previous_points = polygon.points
	
	$VBoxContainer/EditorContainer/PolygonEditor.set_polygon(polygon)
	popup_centered()
	
	#var result = yield(self, "return_polygon")
	
	#queue_free()
	
	#return result

func _on_PolygonEditor_value_changed(value):
	emit_signal("polygon_changed", value)
