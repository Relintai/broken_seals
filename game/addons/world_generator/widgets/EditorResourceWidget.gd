tool
extends HBoxContainer

var _resource_type : String = "Resource"
var _resource : Resource = null

signal on_resource_changed(new_res)

func _enter_tree():
	$ResourceButton.set_drag_forwarding(self)

func set_resource_type(type : String) -> void:
	_resource_type = type
	
func set_resource(res : Resource) -> void:
	if res && !res.is_class(_resource_type):
		return

	var emit : bool = res != _resource

	_resource = res
	
	refresh_ui()
	
	if emit:
		emit_signal("on_resource_changed", _resource)

func refresh_ui() -> void:
	if _resource:
		var text : String = _resource.resource_name
		
		if text == "":
			text = _resource.get_class()
			
		$ResourceButton.text = text
	else:
		$ResourceButton.text = "[null]"

func on_clear_button_pressed() -> void:
	if _resource:
		set_resource(null)

func on_resource_button_pressed() -> void:
	if _resource:
		#todo
		pass

#examples
#{files:[res://modules/planets/test_planet/test_world.tres], from:@@4176:[Tree:9070], type:files}
#{from:Button:[Button:917001], resource:[Resource:26180], type:resource}

func can_drop_data_fw(position, data, from_control):
	return true
	
func drop_data_fw(position, data, from_control):
	if data["type"] == "resource":
		var res : Resource = data["resource"]
		set_resource(res)
	elif data["type"] == "files":
		var files : Array = data["files"]
		
		for f in files:
			var res : Resource = load(f)
			set_resource(res)
			return

func get_drag_data_fw(position, from_control):
	if !_resource:
		return
		
	var d : Dictionary = Dictionary()
	
	d["from"] = self
	d["resource"] = _resource
	d["type"] = "resource"
	
	return d
