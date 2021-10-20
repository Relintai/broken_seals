tool
extends Control

var MMPolygon = preload("res://addons/mat_maker_gd/nodes/bases/polygon_base.gd")

export var closed : bool = true setget set_closed
var value = null setget set_value

signal updated(polygon)

func set_closed(c : bool = true):
	closed = c
	$PolygonView.set_closed(c)

func set_value(v) -> void:
	value = v
	$PolygonView.set_polygon(value)
	$PolygonView.update()

func _on_PolygonEdit_pressed():
	var dialog = preload("res://addons/mat_maker_gd/widgets/polygon_edit/polygon_dialog.tscn").instance()
	dialog.set_closed(closed)
	add_child(dialog)
	
	dialog.connect("polygon_changed", self, "on_value_changed")
	
	dialog.edit_polygon(value)
	
	

func on_value_changed(v) -> void:
	#set_value(v)
	emit_signal("updated", v)
	$PolygonView.update()
