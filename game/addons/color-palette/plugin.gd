tool
extends EditorPlugin

var cpm

func _enter_tree():
	cpm = preload("res://addons/color-palette/ColorPaletteManager.tscn").instance()
	cpm.undoredo = get_undo_redo()
	add_control_to_bottom_panel(cpm, "Color Palette")


func _exit_tree():
	remove_control_from_bottom_panel(cpm)
	cpm.free()
