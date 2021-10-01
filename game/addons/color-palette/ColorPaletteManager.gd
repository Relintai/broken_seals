tool
extends MarginContainer

# Palette list
onready var refresh_list_button = $HBoxContainer/ColorPaletteContainer/OptionsContainer/RefreshList
onready var palette_list = $HBoxContainer/ColorPaletteContainer/PaletteListScroll/PaletteList
# Options
onready var palette_dir_le = $HBoxContainer/ColorPaletteContainer/OptionsContainer/PaletteDirectory
onready var new_palette_name_le = $HBoxContainer/ColorPaletteContainer/OptionsContainer/NewPaletteName
onready var new_palette_button = $HBoxContainer/ColorPaletteContainer/OptionsContainer/NewPalette
onready var open_palette_dir_button = $HBoxContainer/ColorPaletteContainer/OptionsContainer/OpenPaletteDirectory
# Color Editor
onready var color_picker = $HBoxContainer/ColorEditorContainer/Margin/Scroll/ColorPickerContainer/ColorPicker
onready var color_preview_rect = $HBoxContainer/ColorEditorContainer/Margin/Scroll/ColorPickerContainer/HBoxContainer/SelectedColorRect
onready var color_preview_label = $HBoxContainer/ColorEditorContainer/Margin/Scroll/ColorPickerContainer/SelectedColorLabel
onready var apply_color_changed_button = $HBoxContainer/ColorEditorContainer/Margin/Scroll/ColorPickerContainer/HBoxContainer/ApplyChanges
onready var new_color_rect = $HBoxContainer/ColorEditorContainer/Margin/Scroll/ColorPickerContainer/HBoxContainer/NewColorRect
onready var new_color_button = $HBoxContainer/ColorEditorContainer/Margin/Scroll/ColorPickerContainer/HBoxContainer/AddNewColor

var palette_container = preload("res://addons/color-palette/ColorPaletteContainer.tscn")

var palettes: Array # of Palette
var undoredo: UndoRedo # passed from EditorPlugin

var selected_palette: Palette
var selected_color_index: int

func _ready():
	refresh_palettes()
	refresh_list_button.connect("pressed", self, "refresh_palettes")
	apply_color_changed_button.connect("pressed", self, "_apply_new_color_to_selected_palette")
	new_palette_button.connect("pressed", self, "_create_new_palette")
	color_picker.connect("color_changed", new_color_rect, "set_frame_color")
	new_color_button.connect("pressed", self, "_add_color_to_selected_palette")
	open_palette_dir_button.connect("pressed", self, "_open_dir_in_file_manager")

# Clear the palette list, load the gpl files and populate the list again
func refresh_palettes():
	palettes.clear()
	for plc in palette_list.get_children():
		palette_list.remove_child(plc)

#	Ensure trailing slash
	if not palette_dir_le.text.ends_with("/"):
		palette_dir_le.text += "/"

	var gpl_files = PaletteImporter.get_gpl_files(palette_dir_le.text)
	
	for i in gpl_files:
		palettes.append(PaletteImporter.import_gpl(i))
	
	for p in palettes:
		var pc = palette_container.instance()
		pc.palette = p
		pc.undoredo = undoredo
		if selected_palette:
			pc.selected = true if pc.palette.name == selected_palette.name else false
		pc.connect("palette_updated", self, "refresh_palettes")
		pc.connect("palette_color_selected", self, "_on_palette_color_selected")
		pc.connect("container_selected", self, "_on_palette_container_selected")
		palette_list.add_child(pc)


func _on_palette_color_selected(palette: Palette, index: int):
	color_preview_label.text = ("%s (Color #%s)" % [palette.name, index+1])
	color_preview_rect.color = palette.colors[index]
	color_picker.color = palette.colors[index]
	new_color_rect.color = palette.colors[index]
	
	selected_palette = palette
	selected_color_index = index


func _apply_new_color_to_selected_palette() -> void:
#	Check that we can actually apply before doing so
	var size = selected_palette.colors.size()
	if size == 0 or selected_color_index >= size:
		return
		
	var new_color = color_picker.color
	var original_color = selected_palette.colors[selected_color_index]
	
	undoredo.create_action("Change Palette Color")
	undoredo.add_do_method(selected_palette, "change_color", selected_color_index, new_color)
	undoredo.add_do_method(selected_palette, "save")
	undoredo.add_do_method(self, "refresh_palettes")
	
	undoredo.add_undo_method(selected_palette, "change_color", selected_color_index, original_color)
	undoredo.add_undo_method(selected_palette, "save")
	undoredo.add_undo_method(self, "refresh_palettes")
	undoredo.commit_action()


func _create_new_palette() -> void:
	if new_palette_name_le.text.strip_edges().length() > 0:
		var palette = Palette.new()
		palette.path = palette_dir_le.text + new_palette_name_le.text + ".gpl"
		palette.save()
		refresh_palettes()
	else:
		push_error("Name cannot be blank")


func _on_palette_container_selected(container: Control) -> void:
	for pc in palette_list.get_children():
		if pc != container:
			pc.selected = false
	
	selected_palette = container.palette
	selected_color_index = 0
	color_preview_label.text = ("%s (No Color Selected)" % selected_palette.name)


func _add_color_to_selected_palette() -> void:
	if selected_palette != null:
		selected_palette.add_color(color_picker.color)
		selected_palette.save()
		refresh_palettes()


func _open_dir_in_file_manager():
	var dir := Directory.new()
	var path = ProjectSettings.globalize_path(palette_dir_le.text)
	if dir.dir_exists(path):
		OS.shell_open(path)
	else:
		push_error("Invalid directory.")
