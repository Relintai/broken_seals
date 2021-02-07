tool
extends Control

var editor
var canvas_outline
var start_time
var end_time


func _enter_tree():
	canvas_outline = get_parent().find_node("CanvasOutline")
	editor = get_parent()


func _on_ColorPickerButton_color_changed(color):
	canvas_outline.color = color


func _on_CheckButton_toggled(button_pressed):
	canvas_outline.visible = button_pressed


func _on_Ok_pressed():
	hide()
