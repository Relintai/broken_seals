extends Button

func _ready():
	if OS.has_feature("mobile") || OS.has_feature("web"):
		hide()

func _pressed():
	get_tree().quit()
