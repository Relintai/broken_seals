extends RichTextLabel

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
	
	text = Engine.get_license_text()
