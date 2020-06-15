extends Button

func _ready():
	if Settings.get_value("ui", "touchscreen_mode"):
		rect_min_size = Vector2(rect_min_size.x, 40)

