tool
extends Resource
class_name WorldGenBaseResource

export(Rect2) var rect : Rect2 = Rect2(0, 0, 1, 1)
export(bool) var locked : bool = false

func get_rect() -> Rect2:
	return rect

func set_rect(r : Rect2) -> void:
	rect = r
	emit_changed()

func get_content() -> Array:
	return Array()

func set_content(arr : Array) -> void:
	pass
	
func add_content(item_name : String = "") -> void:
	pass

func get_editor_rect_border_color() -> Color:
	return Color(1, 1, 1, 1)

func get_editor_rect_color() -> Color:
	return Color(0.8, 0.8, 0.8, 0.9)

func get_editor_rect_border_size() -> int:
	return 2

func get_editor_font_color() -> Color:
	return Color(0, 0, 0, 1)
	
func get_editor_additional_text() -> String:
	return "WorldGenBaseResource"

func setup_property_inspector(inspector) -> void:
	inspector.add_slot_line_edit("get_name", "set_name", "Name")
	inspector.add_slot_rect2("get_rect", "set_rect", "Rect", 1)
