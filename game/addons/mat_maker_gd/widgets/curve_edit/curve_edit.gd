tool
extends Control

var MMCurve = preload("res://addons/mat_maker_gd/nodes/bases/curve_base.gd")

var value = null setget set_value


signal updated(curve)


func _ready():
	set_value(MMCurve.new())

func set_value(v) -> void:
	value = v.duplicate()
	$CurveView.curve = value
	$CurveView.update()

func _on_CurveEdit_pressed():
	var dialog = preload("res://addons/mat_maker_gd/widgets/curve_edit/curve_dialog.tscn").instance()
	add_child(dialog)
	dialog.connect("curve_changed", self, "on_value_changed")
	var new_curve = dialog.edit_curve(value)
	while new_curve is GDScriptFunctionState:
		new_curve = yield(new_curve, "completed")
	if new_curve != null:
		set_value(new_curve)
		emit_signal("updated", new_curve.duplicate())

func on_value_changed(v) -> void:
	set_value(v)
	emit_signal("updated", v.duplicate())
