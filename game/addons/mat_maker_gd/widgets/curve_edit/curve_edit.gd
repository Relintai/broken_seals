tool
extends Control

var MMCurve = preload("res://addons/mat_maker_gd/nodes/bases/curve_base.gd")

var value = null setget set_value

signal updated(curve)

func set_value(v) -> void:
	value = v
	$CurveView.set_curve(value)
	$CurveView.update()

func _on_CurveEdit_pressed():
	var dialog = preload("res://addons/mat_maker_gd/widgets/curve_edit/curve_dialog.tscn").instance()
	add_child(dialog)
	dialog.connect("curve_changed", self, "on_value_changed")
	dialog.edit_curve(value)

func on_value_changed(v) -> void:
	#set_value(v)
	emit_signal("updated", v)
	$CurveView.update()
