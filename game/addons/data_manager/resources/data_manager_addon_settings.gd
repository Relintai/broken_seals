tool
extends Resource

class SettingEntry:
	var folder : String = ""
	var header : String = ""
	var name : String = ""
	var type : String = ""

var folders : Array = Array()

func _get(property):
	if property == "folder_count":
		return folders.size()
		
	if property.begins_with("folders/"):
		var sindex : String = property.get_slice("/", 1)
		
		if sindex == "":
			return null
			
		var index : int = sindex.to_int()
		
		if index < 0 || index >= folders.size():
			return null
			
		var p : String = property.get_slice("/", 2)
		
		if p == "folder":
			return folders[index].folder
		elif p == "header":
			return folders[index].header
		elif p == "name":
			return folders[index].name
		elif p == "type":
			return folders[index].type
		else:
			return null
		
	return null

func _set(property, val):
	if property == "folder_count":
		set_folder_count(val)
		return true
	
	if property.begins_with("folders/"):
		var sindex : String = property.get_slice("/", 1)
		
		if sindex == "":
			return null
			
		var index : int = sindex.to_int()
		
		if index < 0:
			return false
			
		if index >= folders.size():
			return false
			
		var p : String = property.get_slice("/", 2)
		
		if p == "folder":
			folders[index].folder = val
			return true
		elif p == "header":
			folders[index].header = val
			return true
		elif p == "name":
			folders[index].name = val
			return true
		elif p == "type":
			folders[index].type = val
			return true
			
	return false

func _get_property_list() -> Array:
	var props : Array = Array()
	
	props.append({
			"name": "folder_count",
			"type": TYPE_INT,
		})
	
	for i in range(folders.size()):
		props.append({
			"name": "folders/" + str(i) + "/folder",
			"type": TYPE_STRING,
		})
		props.append({
			"name": "folders/" + str(i) + "/header",
			"type": TYPE_STRING,
		})
		props.append({
			"name": "folders/" + str(i) + "/name",
			"type": TYPE_STRING,
		})
		props.append({
			"name": "folders/" + str(i) + "/type",
			"type": TYPE_STRING,
		})
		
	return props

func apply_folder_size(val : int) -> void:
	folders.resize(val)
	
	for i in range(folders.size()):
		if !folders[i]:
			folders[i] = SettingEntry.new()
	
func set_folder_count(val : int) -> void:
	apply_folder_size(val)

	emit_changed()
	property_list_changed_notify()
