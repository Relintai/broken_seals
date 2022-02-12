extends VBoxContainer

var populated : bool = false

func _enter_tree():
	connect("visibility_changed", self, "on_visibility_changed")

func on_visibility_changed():
	if visible:
		populate()

func populate():
	if populated:
		return
		
	populated = true
	
	for key in Engine.get_donor_info():
		var l : Label = Label.new()
		l.text = key
		add_child(l)
		
		var il : ItemList = ItemList.new()
		il.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		il.mouse_filter = MOUSE_FILTER_IGNORE
		il.auto_height = true
		
		for e in Engine.get_donor_info()[key]:
			il.add_item(e)
		
		add_child(il)
