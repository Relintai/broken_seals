tool
extends Button

signal history_entry_selected

var data : Resource setget set_data#, get_data

func _pressed() -> void:
	emit_signal("history_entry_selected", data)

func set_data(pdata: Resource) -> void:
	data = pdata
	
	var s : String = "(" + data.get_class() + ") "
	
	if data.has_method("get_id"):
		s += str(data.get_id()) + " - "
		
	if data.has_method("get_text_name"):
		s += str(data.get_text_name())
		
	if data.has_method("get_rank"):
		s += " (R " + str(data.get_rank()) + ")"

	text = s

func get_data() -> Resource:
	return data

func get_drag_data(position):
	if data == null:
		return null
	
	var d : Dictionary = Dictionary()
	d["type"] = "resource"
	d["resource"] = data
	d["from"] = self
	
	return d
