tool
extends Tree

var edited_resource : WorldGenBaseResource = null

var name_edited_resource : WorldGenBaseResource = null

func _init():
	connect("item_activated", self, "on_item_activated")

func add_item(item_name : String = "") -> void:
	if !edited_resource:
		return
		
	edited_resource.create_content(item_name)
	
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

func set_edited_resource(res : WorldGenBaseResource)-> void:
	if edited_resource:
		edited_resource.disconnect("changed", self, "on_resource_changed")
	
	edited_resource = res
	
	if edited_resource:
		edited_resource.connect("changed", self, "on_resource_changed")
	
	refresh()

func add_button_pressed() -> void:
	$NameDialog/TextEdit.text = ""
	$NameDialog.popup_centered()

func name_dialog_ok_pressed() -> void:
	if !name_edited_resource:
		add_item($NameDialog/TextEdit.text)
	else:
		name_edited_resource.resource_name = $NameDialog/TextEdit.text
		name_edited_resource = null

func delete_button_pressed() -> void:
	var item : TreeItem = get_selected()
	
	if !item:
		return
		
	var item_resource = item.get_meta("res")
	
	if !item_resource:
		return
		
	edited_resource.remove_content_entry(item_resource)

func duplicate_button_pressed() -> void:
	var item : TreeItem = get_selected()
	
	if !item:
		return
		
	var item_resource = item.get_meta("res")
	
	if !item_resource:
		return
		
	edited_resource.duplicate_content_entry(item_resource)

func on_resource_changed() -> void:
	call_deferred("refresh")

func on_item_activated() -> void:
	var item : TreeItem = get_selected()
	
	if !item:
		return
		
	name_edited_resource = item.get_meta("res")
	
	if !name_edited_resource:
		return
		
	$NameDialog/TextEdit.text = name_edited_resource.resource_name
	$NameDialog.popup_centered()
