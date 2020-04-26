tool
extends Control

signal inspect_data
signal duplicate
signal delete

export(PackedScene) var spatial_preview : PackedScene
export(PackedScene) var node2d_preview : PackedScene
export(PackedScene) var control_preview : PackedScene
export(PackedScene) var texture_preview : PackedScene

export(NodePath) var main_button_path : NodePath

var _main_button : Button

var _preview : Node
var _data : Resource

func _ready():
	_main_button = get_node(main_button_path) as Button

func set_resource(data : Resource) -> void:
	_data = data
	
	_main_button.set_resource(data)
	
	var name_text : String = ""
	
	if data.has_method("get_id"):
		name_text += str(data.get_id()) + " - "
		
	if data.has_method("get_text_name"):
		name_text += str(data.get_text_name())
	else:
		if data.resource_name != "":
			name_text += data.resource_name
		else:
			name_text += data.resource_path
		
	if data.has_method("get_rank"):
		name_text +=  " - Rank " + str(data.get_rank())

	if data is Texture:
		_preview = texture_preview.instance()
		add_child(_preview)
		_preview.owner = self
		move_child(_preview, 0)
			
		_preview.set_texture(data as Texture)
	elif data is PackedScene:
		var n : Node = data.instance()
		
		if _preview != null:
			_preview.queue_free()
		
		if n is Spatial:
			_preview = spatial_preview.instance()
			add_child(_preview)
			_preview.owner = self
			move_child(_preview, 0)
			
			_preview.preview(n as Spatial)
		elif n is Node2D:
			_preview = node2d_preview.instance()
			add_child(_preview)
			_preview.owner = self
			move_child(_preview, 0)
			
			_preview.preview(n as Node2D)
		elif n is Control:
			_preview = control_preview.instance()
			add_child(_preview)
			_preview.owner = self
			move_child(_preview, 0)
			
			_preview.preview(n as Control)
		else:
			n.queue_free()
		
	_main_button.text = name_text

func can_drop_data(position, data):
	return false
	
func inspect():
	emit_signal("inspect_data", _data)

func duplicate_data():
	emit_signal("duplicate", _data)
	
func delete():
	emit_signal("delete", _data)
