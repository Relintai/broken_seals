extends VBoxContainer

export(NodePath) var tree_path : NodePath
var tree : Tree

export(NodePath) var rtl_path : NodePath
var rtl : RichTextLabel

var populated : bool = false

func _enter_tree():
	tree = get_node(tree_path)  as Tree
	rtl = get_node(rtl_path) as RichTextLabel
	
	connect("visibility_changed", self, "on_visibility_changed")
	tree.connect("item_selected", self, "on_item_selected")
	
func on_visibility_changed():
	if visible:
		populate()
		
func on_item_selected():
	rtl.text = tree.get_selected().get_metadata(0)

func populate():
	if populated:
		return
		
	populated = true
	
	tree.create_item()

	for info in Engine.get_copyright_info():
		var ti : TreeItem = tree.create_item()
		
		var st : String = info["name"] + "\n\n"
		
		for p in info["parts"]:
			for k in p:
				st += k + ":\n\n"
				
				if p[k] is Array:
					for it in p[k]:
						st += String(it) + "\n"
				else:
					st += String(p[k]) + "\n"
				
			st += "\n\n"
		
		ti.set_metadata(0, st)
		ti.set_text(0, info["name"])
