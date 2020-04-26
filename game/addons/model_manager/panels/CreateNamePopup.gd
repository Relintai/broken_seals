tool
extends ConfirmationDialog

signal ok_pressed

export(NodePath) var line_edit_path : NodePath
export(NodePath) var option_button_path : NodePath

var _resource_type : String

var _line_edit : LineEdit
var _option_button : OptionButton

func _ready():
	_line_edit = get_node(line_edit_path) as LineEdit
	_option_button = get_node(option_button_path) as OptionButton
	
	connect("confirmed", self, "_on_OK_pressed")
	connect("about_to_show", self, "about_to_show")
	
func set_resource_type(resource_type : String) -> void:
	_resource_type = resource_type 
	
	
func about_to_show():
	_option_button.clear()
	
	if not ClassDB.class_exists(_resource_type):
		return
	
	var arr : PoolStringArray = PoolStringArray()
	arr.append(_resource_type)
	arr.append_array(ClassDB.get_inheriters_from_class(_resource_type))

	var gsc : Array = ProjectSettings.get("_global_script_classes")
	
	var l : int = arr.size() - 1
	
	while (arr.size() != l):
		l = arr.size()
		
		for i in range(gsc.size()):
			var d : Dictionary = gsc[i] as Dictionary
			
			var found = false
			for j in range(arr.size()):
				if arr[j] == d["class"]:
					found = true
					break
				
			if found:
				continue
				
			for j in range(arr.size()):
				if arr[j] == d["base"]:
					arr.append(d["class"])

	for a in arr:
		_option_button.add_item(a)
		
	
func _on_OK_pressed():
	emit_signal("ok_pressed", _line_edit.text, _option_button.get_item_text(_option_button.selected))
	hide()
