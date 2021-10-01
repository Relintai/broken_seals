tool
extends PanelContainer

signal palette_updated
signal palette_color_selected(palette, color_index)
signal palette_color_deleted(palette, color_index)
signal container_selected(container_object)

onready var btn_load_to_picker = $MarginContainer/VBoxContainer/HBoxContainer/BtnLoadToPicker
onready var btn_update_from_picker = $MarginContainer/VBoxContainer/HBoxContainer/BtnUpdateFromPicker
onready var name_label = $MarginContainer/VBoxContainer/HBoxContainer/PaletteName
onready var grid = $MarginContainer/VBoxContainer/PaletteTileContainer/TileContainer

var palette: Palette
var undoredo: UndoRedo
var selected: bool = false setget set_selected 


func _ready():
	btn_load_to_picker.connect("pressed", self, "load_to_picker")
	btn_update_from_picker.connect("pressed", self, "update_from_picker")
	grid.connect("grid_item_reordered", self, "_grid_item_reordered")
	
#	Base settings for all color rects are set in the color tile class
	var cr = ColorTile.new()
	
	if palette:
		name_label.text = palette.name
		name_label.hint_tooltip = palette.comments
		for c in palette.colors:
#			Color rect instance properties
			var cri = cr.duplicate()
			cri.color = c
			cri.connect("tile_selected", self, "_on_tile_selected")
			cri.connect("tile_deleted", self, "_on_tile_deleted")
			grid.add_child(cri)

func load_to_picker():
	var new_picker_presets: PoolColorArray
	
	for c in palette.colors:
		new_picker_presets.append(c)
	
#	Hack?
	var ep = EditorPlugin.new()
	ep.get_editor_interface() \
		.get_editor_settings() \
		.set_project_metadata("color_picker", "presets", new_picker_presets)
	ep.free()


func update_from_picker():
	var ep = EditorPlugin.new()
	var colors: PoolColorArray = ep.get_editor_interface() \
		.get_editor_settings() \
		.get_project_metadata("color_picker", "presets")
	
	palette.colors.clear()
	for c in colors:
		palette.add_color(c)
	
	palette.save()
	
	ep.free()
	
	emit_signal("palette_updated")


func _grid_item_reordered(p_index_from: int, p_index_to: int) -> void:
	undoredo.create_action("Reorder Palette %s" % palette.name)
	
#	To do, move from "from" to "to"
	undoredo.add_do_method(palette, "reorder_color", p_index_from, p_index_to)
	undoredo.add_do_method(palette, "save")
	undoredo.add_do_method(self, "emit_signal", "palette_updated")
	undoredo.add_do_method(self, "emit_signal", "palette_color_selected", palette, p_index_to)
	
#	To undo, just reverse the positions!
	undoredo.add_undo_method(palette, "reorder_color", p_index_to, p_index_from)
	undoredo.add_undo_method(palette, "save")
	undoredo.add_undo_method(self, "emit_signal", "palette_updated")
	undoredo.add_undo_method(self, "emit_signal", "palette_color_selected", palette, p_index_from)
	
	undoredo.commit_action()


# Bubble the event up the tree
func _on_tile_selected(index):
	emit_signal("palette_color_selected", palette, index)


func _on_tile_deleted(index):	
	var original_color = palette.colors[index]
	
	undoredo.create_action("Delete Color %s from Palette %s" % [original_color.to_html(), palette.name])
	
#	To do, move from "from" to "to"
	undoredo.add_do_method(palette, "remove_color", index)
	undoredo.add_do_method(palette, "save")
	undoredo.add_do_method(self, "emit_signal", "palette_updated")
	
#	To undo, just reverse the positions!
	undoredo.add_undo_method(palette, "add_color", original_color, index)
	undoredo.add_undo_method(palette, "save")
	undoredo.add_undo_method(self, "emit_signal", "palette_updated")
	
	undoredo.commit_action()


func set_selected(value: bool) -> void:
	selected = value
	if selected:
		var sb: StyleBoxFlat = get_stylebox("panel").duplicate()
		sb.bg_color = Color("#2c3141")
		add_stylebox_override("panel", sb)
		emit_signal("container_selected", self)
	else:
		var sb: StyleBoxFlat = get_stylebox("panel").duplicate()
		sb.bg_color = Color(0.15, 0.17, 0.23)
		add_stylebox_override("panel", sb)
	

func _gui_input(event):
	if (event is InputEventMouseButton and
			event.get_button_index() == 1 and
			event.is_pressed()):
		self.selected = true
