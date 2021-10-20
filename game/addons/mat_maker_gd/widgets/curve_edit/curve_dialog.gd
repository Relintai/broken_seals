tool
extends WindowDialog

var MMCurve = preload("res://addons/mat_maker_gd/nodes/bases/curve_base.gd")

var previous_points : Array
var curve

signal curve_changed(curve)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_CurveDialog_popup_hide():
	queue_free()

func _on_OK_pressed():
	emit_signal("curve_changed", curve)
	curve.curve_changed()
	
	queue_free()

func _on_Cancel_pressed():
	curve.set_points(previous_points)
	emit_signal("curve_changed", curve)

	queue_free()

func edit_curve(c) -> void:
	curve = c
	previous_points = curve.get_points()
	$VBoxContainer/EditorContainer/CurveEditor.set_curve(curve)
	popup_centered()

func _on_CurveEditor_value_changed(value):
	emit_signal("curve_changed", value)
