tool
extends ConfirmationDialog

signal ok_pressed

export(NodePath) var line_edit_path : NodePath
export(NodePath) var tree_path : NodePath

export(PoolStringArray) var type_folders : PoolStringArray

var _resource_type : String = "MMNode"

var _line_edit : LineEdit
var _tree : Tree

func _ready():
	_line_edit = get_node(line_edit_path) as LineEdit
	_tree = get_node(tree_path) as Tree
	
	connect("confirmed", self, "_on_OK_pressed")
	connect("about_to_show", self, "about_to_show")
	
func set_resource_type(resource_type : String) -> void:
	_resource_type = resource_type 
	
func about_to_show():
	_tree.clear()
	
	var root : TreeItem = _tree.create_item()
	
	for s in type_folders:
		evaluate_folder(s, root)

func evaluate_folder(folder : String, root : TreeItem) -> void:
	var ti : TreeItem = _tree.create_item(root)
	ti.set_text(0, folder.substr(folder.find_last("/") + 1))
	
	var dir = Directory.new()
	if dir.open(folder) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				print("Found file: " + file_name)
				var e : TreeItem = _tree.create_item(ti)
				
				e.set_text(0, file_name.get_file())
				e.set_meta("file", folder + "/" + file_name)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _on_OK_pressed():
	var selected : TreeItem = _tree.get_selected()
	
	if selected:
		if !selected.has_meta("file"):
			hide()
			return
		
		var file_name : String = selected.get_meta("file")
		emit_signal("ok_pressed", file_name)
		
	hide()
