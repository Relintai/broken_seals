tool
extends Resource

class SettingEntry:
	var folder : String = ""
	var header : String = ""
	var name : String = ""
	var type : String = ""

var folders : Array = Array()

func get_folder_count() -> int:
	return folders.size()

func folder_get(index : int) -> SettingEntry:
	return folders[index]

func folder_get_folder(index : int) -> String:
	return folders[index].folder

func folder_get_header(index : int) -> String:
	return folders[index].header
	
func folder_get_name(index : int) -> String:
	return folders[index].name
	
func folder_get_type(index : int) -> String:
	return folders[index].type

func _get(property : StringName):
	var sprop : String = property
	
	if sprop == "folder_count":
		return folders.size()
		
	if sprop.begins_with("folders/"):
		var sindex : String = sprop.get_slice("/", 1)
		
		if sindex == "":
			return null
			
		var index : int = sindex.to_int()
		
		if index < 0 || index >= folders.size():
			return null
			
		var p : String = sprop.get_slice("/", 2)
		
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

func _set(property : StringName, val) -> bool:
	var sprop : String = property
	
	if property == "folder_count":
		set_folder_count(val)
		return true
	
	if sprop.begins_with("folders/"):
		var sindex : String = sprop.get_slice("/", 1)
		
		if sindex == "":
			return false
			
		var index : int = sindex.to_int()
		
		if index < 0:
			return false
			
		if index >= folders.size():
			return false
			
		var p : String = sprop.get_slice("/", 2)
		
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
			"name": "save",
			"type": TYPE_NIL,
			"hint": PROPERTY_HINT_BUTTON,
			"hint_string": "save_to_project_settings",
		})
	
#	props.append({
#			"name": "convert_to_json",
#			"type": TYPE_NIL,
#			"hint": PROPERTY_HINT_BUTTON,
#			"hint_string": "convert_to_json",
#		})
#
#	props.append({
#			"name": "convert_from_json",
#			"type": TYPE_NIL,
#			"hint": PROPERTY_HINT_BUTTON,
#			"hint_string": "convert_from_json",
#		})

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

func convert_to_json() -> void:
	var f : File = File.new()
	
	f.open("res://addons/data_manager/_data/settings.json", File.WRITE)
	f.store_string(get_as_json())
	f.close()
	
	PLogger.log_message("Saved settings to res://addons/data_manager/_data/settings.json")

func convert_from_json() -> void:
	var f : File = File.new()
	
	if (!f.file_exists("res://addons/data_manager/_data/settings.json")):
		PLogger.log_message("File res://addons/data_manager/_data/settings.json doesn't exist!")
		return
	
	f.open("res://addons/data_manager/_data/settings.json", File.READ)
	set_from_json(f.get_as_text())
	f.close()
	
	PLogger.log_message("Loaded settings from res://addons/data_manager/_data/settings.json")

func get_as_json() -> String:
	var arr : Array

	for i in range(folders.size()):
		var s : SettingEntry = folders[i]
		
		var dict : Dictionary
		
		dict["folder"] = s.folder
		dict["header"] = s.header
		dict["name"] = s.name
		dict["type"] = s.type
		
		arr.push_back(dict)

	return to_json(arr);

func set_from_json(data : String) -> void:
	var jpr : JSONParseResult = JSON.parse(data)
	
	if jpr.error != OK:
		PLogger.log_message("DataManagerAddonSettings: set_from_json: Couldn't load data!");
		return
		
	var arr = jpr.result
	
	for i in range(arr.size()):
		var dict : Dictionary = arr[i]
		
		var s : SettingEntry = SettingEntry.new()
		
		s.folder = dict["folder"]
		s.header = dict["header"]
		s.name = dict["name"]
		s.type = dict["type"]
		
		folders.push_back(s)

func save_to_project_settings() -> void:
	ProjectSettings.set("addons/data_manager/folder_settings", get_as_json())
	
func load_from_project_settings() -> void:
	var d : String = ProjectSettings.get("addons/data_manager/folder_settings")
	
	if d != "":
		set_from_json(d)
	
