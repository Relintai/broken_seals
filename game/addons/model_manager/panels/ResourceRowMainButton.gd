tool
extends Button

var _data : Resource

func get_drag_data(position):
	if _data == null:
		return null
	
	var d : Dictionary = Dictionary()
	d["type"] = "resource"
	d["resource"] = _data
	d["from"] = self
	
	return d

func set_resource(data : Resource) -> void:
	_data = data
