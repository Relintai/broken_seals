tool
extends Tree

export(int, "Continent,Zone,Sub Zone,Sub Zone Prop") var class_types : int = 0

var edited_resource : WorldGenBaseResource = null
var name_edited_resource : WorldGenBaseResource = null

var _ignore_changed_event : bool = false

var _plugin : EditorPlugin = null
var _undo_redo : UndoRedo = null

signal request_item_edit(world_gen_base_resource)

func _init():
	if !is_connected("item_edited", self, "on_item_edited"):
		connect("item_edited", self, "on_item_edited")
	
	if !is_connected("button_pressed", self, "on_tree_button_pressed"):
		connect("button_pressed", self, "on_tree_button_pressed")
	
func set_plugin(plugin : EditorPlugin) -> void:
	_plugin = plugin
	_undo_redo = _plugin.get_undo_redo()

func _enter_tree():
	var dir : Directory = Directory.new()
	
	if dir.file_exists("res://world_generator_settings.tres"):
		var wgs : WorldGeneratorSettings = load("res://world_generator_settings.tres") as WorldGeneratorSettings
		
		if !wgs:
			return
			
		wgs.evaluate_scripts(class_types, $NameDialog/VBoxContainer/Tree)

func add_item(item_name : String = "") -> void:
	if !edited_resource:
		return
		
	var ti : TreeItem = $NameDialog/VBoxContainer/Tree.get_selected()
	
	if !ti:
		return
		
	var e : WorldGenBaseResource = null
	
	if ti.has_meta("class_name"):
		var cn : String = ti.get_meta("class_name")
		
		if cn == "Continent":
			e = Continent.new()
		elif cn == "Zone":
			e = Zone.new()
		elif cn == "SubZone":
			e = SubZone.new()
		elif cn == "SubZoneProp":
			e = SubZoneProp.new()
			
	elif ti.has_meta("file"):
		var cls = load(ti.get_meta("file"))
		
		if cls:
			e = cls.new()
		
	if !e:
		return
	
	e.resource_name = item_name
	
	var r : Rect2 = edited_resource.get_rect()
	var rs : Vector2 = r.size
	r.size.x /= 5.0
	r.size.y /= 5.0
	r.position = rs / Vector2(2, 2)
	r.position -= r.size / Vector2(2, 2)
	e.set_rect(r)
	
	#edited_resource.add_content(e)
	#remove_content_entry
	
	_undo_redo.create_action("WE: Created Entry")
	_undo_redo.add_do_method(edited_resource, "add_content", e)
	_undo_redo.add_undo_method(edited_resource, "remove_content_entry", e)
	_undo_redo.commit_action()
	
func refresh() -> void:
	clear()
	
	if !edited_resource:
		return
		
	var root : TreeItem = create_item()
	
	var data : Array = edited_resource.get_content()
	
	for d in data:
		if d:
			var n : String = d.resource_name
			
			if n == "":
				n = "<no name>"
				
			var item : TreeItem = create_item(root)
			
			item.set_text(0, n)
			item.set_meta("res", d)
			item.add_button(0, get_theme_icon("Edit", "EditorIcons"), -1, false, "Edit")
			item.set_editable(0, true)

func set_edited_resource(res : WorldGenBaseResource)-> void:
	if edited_resource:
		edited_resource.disconnect("changed", self, "on_resource_changed")
	
	edited_resource = res
	
	if edited_resource:
		edited_resource.connect("changed", self, "on_resource_changed")
	
	refresh()

func add_button_pressed() -> void:
	$NameDialog/VBoxContainer/LineEdit.text = ""
	$NameDialog.popup_centered()

func name_dialog_ok_pressed() -> void:
	add_item($NameDialog/VBoxContainer/LineEdit.text)

func delete_button_pressed() -> void:
	var item : TreeItem = get_selected()
	
	if !item:
		return
		
	var item_resource = item.get_meta("res")
	
	if !item_resource:
		return
		
	#edited_resource.remove_content_entry(item_resource)
	
	_undo_redo.create_action("WE: Created Entry")
	_undo_redo.add_do_method(edited_resource, "remove_content_entry", item_resource)
	_undo_redo.add_undo_method(edited_resource, "add_content", item_resource)
	_undo_redo.commit_action()

func duplicate_button_pressed() -> void:
	var item : TreeItem = get_selected()
	
	if !item:
		return
		
	var item_resource = item.get_meta("res")
	
	if !item_resource:
		return
		
	#edited_resource.duplicate_content_entry(item_resource)
	
	var de = edited_resource.duplicate_content_entry(item_resource, false)

	_undo_redo.create_action("WE: Created Entry")
	_undo_redo.add_do_method(edited_resource, "add_content", de)
	_undo_redo.add_undo_method(edited_resource, "remove_content_entry", de)
	_undo_redo.commit_action()

func on_resource_changed() -> void:
	if _ignore_changed_event:
		return
		
	call_deferred("refresh")

func on_tree_button_pressed(item: TreeItem, column: int, id: int) -> void:
	var resource : WorldGenBaseResource = item.get_meta("res")
	
	if !resource:
		return
		
	emit_signal("request_item_edit", resource)

func on_item_edited() -> void:
	var item : TreeItem = get_edited()
	
	if !item:
		return
		
	name_edited_resource = item.get_meta("res")
	
	if !name_edited_resource:
		return
		
	_undo_redo.create_action("WE: Renamed Entry")
	_undo_redo.add_do_method(name_edited_resource, "set_name", item.get_text(0))
	_undo_redo.add_undo_method(name_edited_resource, "set_name", name_edited_resource.resource_name)
	_undo_redo.commit_action()
	
#	name_edited_resource.resource_name = item.get_text(0)
	name_edited_resource.emit_changed()
	name_edited_resource = null
	on_resource_changed()
