tool
extends Resource
class_name WorldGenBaseResource

export(Rect2) var rect : Rect2 = Rect2(0, 0, 1, 1)

func get_content() -> Array:
	return Array()

func set_content(arr : Array) -> void:
	pass
	
func add_content() -> void:
	pass

func setup_property_inspector(inspector) -> void:
	inspector.add_slot_line_edit("get_name", "set_name", "Name")
