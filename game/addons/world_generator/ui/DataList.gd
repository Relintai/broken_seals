tool
extends Tree

var edited_resource : WorldGenBaseResource = null

func add_item() -> void:
	if !edited_resource:
		return
		
	edited_resource.add_content()
	
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

func set_edited_resource(res : WorldGenBaseResource)-> void:
	if edited_resource:
		edited_resource.disconnect("changed", self, "on_resource_changed")
	
	edited_resource = res
	
	if edited_resource:
		edited_resource.connect("changed", self, "on_resource_changed")
	
	refresh()

func on_resource_changed() -> void:
	refresh()
