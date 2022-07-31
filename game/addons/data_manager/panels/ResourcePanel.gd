tool
extends Control

signal inspect_data
signal edit_settings

export(PackedScene) var resource_row_scene : PackedScene
export(PackedScene) var history_row_scene : PackedScene

export(NodePath) var entry_container_path : NodePath

export(NodePath) var name_popup_path : NodePath
export(NodePath) var create_popup_path : NodePath
export(NodePath) var delete_popup_path : NodePath

export(NodePath) var history_container_path : NodePath

var _filter_term : String

var _entry_container : Node
var _name_popup : Node
var _create_popup : ConfirmationDialog
var _delete_popup : ConfirmationDialog

var _history_container : Node

var _folder : String
var _resource_type : String

var _queue_deleted : Resource

var _state : Dictionary
var _states : Dictionary

func _ready():
	_history_container = get_node(history_container_path)
	
	_entry_container = get_node(entry_container_path)
	_name_popup = get_node(name_popup_path)
	_name_popup.connect("ok_pressed", self, "ok_pressed")
	
	_create_popup = get_node(create_popup_path)
	_delete_popup = get_node(delete_popup_path)

func set_resource_type(folder : String, resource_type : String) -> void:
	if !folder.ends_with("/"):
		folder += "/"
	
	if folder == _folder and _resource_type == resource_type:
		return
	
	_states[_folder + "," + _resource_type] = _state
	
	if _states.has(folder + "," + resource_type):
		_state = _states[folder + "," + resource_type]
	else:
		_state = Dictionary()
	
	_folder = folder
	_resource_type = resource_type
	
#	_filter_term = ""
	
	_create_popup.set_resource_type(resource_type)
	
	refresh()
	
func refresh() -> void:
	for ch in _entry_container.get_children():
		ch.queue_free()
	
	var dir : Directory = Directory.new()
	
	if dir.open(_folder) == OK:
		dir.list_dir_begin()
		var data_array : Array = Array()
		
		var file_name = dir.get_next()
		
		while (file_name != ""):
			if not dir.current_is_dir():
				
				if ResourceLoader.exists(_folder + file_name, _resource_type):
					
					var res = ResourceLoader.load(_folder + file_name, _resource_type)
	
					if _filter_term != "":
						var ftext : String = ""
						
						if res.has_method("get_text_name"):
							ftext = res.get_text_name()

						if ftext == "":
							if res.resource_name != "":
								ftext = res.resource_name
							else:
								ftext = res.resource_path
						
						ftext = ftext.to_lower()
						
						if ftext.find(_filter_term) == -1:
							file_name = dir.get_next()
							continue
							
					var id : int = 0
							
					if res.has_method("get_id"):
						id = res.get_id()
							
					data_array.append({
						"id": id,
						"resource": res
					})
				
			file_name = dir.get_next()
			
		data_array.sort_custom(self, "sort_entries")
		
		for d in data_array:
			
			var resn : Node = resource_row_scene.instance()
					
			_entry_container.add_child(resn)
			resn.owner = _entry_container
			resn.set_resource(d["resource"])
			resn.connect("inspect_data", self, "inspect_data")
			resn.connect("duplicate", self, "duplicate_data")
			resn.connect("delete", self, "delete")

func inspect_data(var data : Resource) -> void:
	var found : bool = false
	
	for ch in _history_container.get_children():
		if ch.data == data:
			found = true
			
			_history_container.move_child(ch, 0)
			
			break
			
	if not found:
		var n : Node = history_row_scene.instance()
		
		_history_container.add_child(n)
		_history_container.move_child(n, 0)
		n.owner = _history_container
		
		n.data = data
		n.connect("history_entry_selected", self, "inspect_data")
	
	if _history_container.get_child_count() > 20:
		var ch : Node = _history_container.get_child(_history_container.get_child_count() - 1)
		
		ch.queue_free()
	
	emit_signal("inspect_data", data)

func ok_pressed(res_name: String, pclass_name: String) -> void:

	var d : Directory = Directory.new()
	
	if d.open(_folder) == OK:
		d.list_dir_begin()
		
		var file_name = d.get_next()
		
		var max_ind : int = 0
		
		while (file_name != ""):
			
			if not d.current_is_dir():
				
				var curr_ind : int = int(file_name.split("_")[0])
				
				if curr_ind > max_ind:
					max_ind = curr_ind
				
			file_name = d.get_next()
			
		max_ind += 1
		
		var newfname : String = str(res_name)
		newfname = newfname.replace(" ", "_")
		newfname = newfname.to_lower()
		newfname = str(max_ind) + "_" + newfname + ".tres"
		
		var res : Resource = null
		
		if ClassDB.class_exists(pclass_name) and ClassDB.can_instance(pclass_name):
			res = ClassDB.instance(pclass_name)
		else:
			var gsc : Array = ProjectSettings.get("_global_script_classes")
			
			for i in range(gsc.size()):
				var gsce : Dictionary = gsc[i] as Dictionary
				
				if gsce["class"] == pclass_name:
					var script : Script = load(gsce["path"])
					
					res = script.new()
						
					break
		
		if res == null:
			print("ESSData: Error in creating resource type " + pclass_name)
			return
		
		if res.has_method("set_id"):
			res.set_id(max_ind)

		if res.has_method("set_text_name"):
			res.set_text_name(str(res_name))

		ResourceSaver.save(_folder + newfname, res)
		
		refresh()
	
func duplicate_data(data):
	if not data is Resource:
		return
	
	var d : Directory = Directory.new()
	
	if d.open(_folder) == OK:
		d.list_dir_begin()
		
		var file_name = d.get_next()
		
		var max_ind : int = 0
		
		while (file_name != ""):
			
			if not d.current_is_dir():
				
				var curr_ind : int = int(file_name.split("_")[0])
				
				if curr_ind > max_ind:
					max_ind = curr_ind
				
			file_name = d.get_next()
			
		max_ind += 1
		
		var res_name : String = ""

		if data.has_method("get_text_name"):
			res_name = data.get_text_name()
		
		var newfname : String = res_name
		newfname = newfname.replace(" ", "_")
		newfname = newfname.to_lower()
		newfname = str(max_ind) + "_" + newfname + ".tres"
		
		var res : Resource = data.duplicate()
		
		if res.has_method("set_id"):
			res.set_id(max_ind)
			
		if res.has_method("set_text_name"):
			res.set_text_name(str(res_name))

		ResourceSaver.save(_folder + newfname, res)
		
		refresh()
	
func delete(data):
	if data == null or data as Resource == null:
		return 
		
	_queue_deleted = data as Resource
	
	_delete_popup.popup_centered()

func delete_confirm():
	if _queue_deleted == null:
		return
		
	var d  : Directory = Directory.new()
	d.remove(_queue_deleted.resource_path)
	
	_queue_deleted = null
	
	refresh()
	
func clear_history() -> void:
		for ch in _history_container.get_children():
			ch.queue_free()

func search(text : String) -> void:
	_filter_term = text.to_lower()
	
	refresh()

func sort_entries(a, b):
	return a["id"] < b["id"]


func edit_settings():
	emit_signal("edit_settings")
