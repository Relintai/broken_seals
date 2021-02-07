tool
extends GridContainer

signal color_change_request

func _enter_tree():
	for child in get_children():
		child.set("custom_styles/normal", StyleBoxFlat.new())
		child.get("custom_styles/normal").set("bg_color", Color(randf(), randf(), randf())) 
	for child in get_children():
		if child.is_connected("pressed", self, "change_color_to"):
			return
		child.connect("pressed", self, "change_color_to", [child.get("custom_styles/normal").bg_color])


func change_color_to(color):
	emit_signal("color_change_request", color)


func add_color_prefab(color: Color):
	var dup = get_child(0).duplicate()
	add_child(dup)
	move_child(dup, 0)
	dup.set("custom_styles/normal", StyleBoxFlat.new())
	dup.get("custom_styles/normal").set("bg_color", color) 
	for child in get_children():
		if child.is_connected("pressed", self, "change_color_to"):
			return
		child.connect("pressed", self, "change_color_to", [child.get("custom_styles/normal").bg_color])





