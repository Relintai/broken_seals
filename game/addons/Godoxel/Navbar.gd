tool
extends Control

var editor
var paint_canvas

func _ready():
	editor = owner
	paint_canvas = editor.find_node("PaintCanvas")
	
	for i in get_node("Buttons").get_children():
		i.connect("item_pressed", self, "button_pressed")


func button_pressed(button_name, button_item, id):
#	print("pressed: ", button_name)
#	print("pressed item is: '%s'" % button_item)
	
	match button_name:
		"File":
			handle_file_menu(button_item, id)
		"Edit":
			handle_edit_menu(button_item, id)
		"Canvas":
			handle_canvas_menu(button_item, id)
		"Layer":
			handle_layer_menu(button_item, id)
		"Grid":
			handle_grid_menu(button_item, id)
		"Magic":
			handle_magic_menu(button_item, id)
		"Editor":
			handle_editor_menu(button_item, id)


func handle_file_menu(pressed_item: String, id):
	match pressed_item:
		"Save":
			owner.get_node("SaveFileDialog").show()
		"Load":
			owner.get_node("LoadFileDialog").show()
		"New":
			owner.get_node("ConfirmationDialog").show()


func handle_edit_menu(pressed_item: String, id):
	match pressed_item:
		"Add Layer":
			editor.add_new_layer()


func handle_canvas_menu(pressed_item: String, id):
	match pressed_item:
		"Change Size":
			owner.get_node("ChangeCanvasSize").show()
		"Crop To Content":
			owner.paint_canvas.crop_to_content()


func handle_layer_menu(pressed_item: String, id):
	match pressed_item:
		"Add Layer":
			editor.add_new_layer()
		"Delete Layer":
			editor.remove_active_layer()
		"Duplicate Layer":
			editor.duplicate_active_layer()
		"Clear Layer":
			owner.paint_canvas.clear_active_layer()
		"Toggle Alpha Locked":
			owner.paint_canvas.active_layer.toggle_alpha_locked()
			$Buttons/Layer.get_popup().set_item_checked(id, not $Buttons/Layer.get_popup().is_item_checked(id))
			owner.find_node("LockAlpha").pressed = $Buttons/Layer.get_popup().is_item_checked(id)


func handle_grid_menu(pressed_item: String, id):
	match pressed_item:
		"Change Grid Size":
			owner.get_node("ChangeGridSizeDialog").show()
		"Toggle Grid":
			owner.paint_canvas.toggle_grid()


func handle_magic_menu(pressed_item: String, id):
	match pressed_item:
		"Add Layer":
			editor.add_new_layer()


func handle_editor_menu(pressed_item: String, id):
	match pressed_item:
		"Settings":
			owner.get_node("Settings").show()
		"Toggle Grid":
			var grids_node = owner.find_node("Grids")
			grids_node.visible = !grids_node.visible
		"Reset Canvas Position":
			owner.paint_canvas_node.rect_position = Vector2(0, 0)


func is_any_menu_open() -> bool:
	for child in $Buttons.get_children():
		if child.get_popup().visible:
			return true
	return false

