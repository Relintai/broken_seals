extends Theme

export(float) var content_margin_vertical_normal : float = 6
export(float) var content_margin_vertical_touch : float = 10

export(float) var content_margin_horizontal_normal : float = 5
export(float) var content_margin_horizontal_touch : float = 20

func _init():
	Settings.connect("setting_changed", self, "setting_changed") 
	Settings.connect("settings_loaded", self, "settings_loaded") 
	
	if Settings.loaded:
		adapt(Settings.get_value("ui", "touchscreen_mode"))


func setting_changed(section, key, value):
	if section == "ui" and key == "touchscreen_mode":
		adapt(value)

func settings_loaded():
	adapt(Settings.get_value("ui", "touchscreen_mode"))

func adapt(touchscreen_mode : bool) -> void:
	var content_martgin_vert : float = 0
	var content_margin_horiz : float = 0
	
	if touchscreen_mode:
		content_martgin_vert = content_margin_vertical_touch
		content_margin_horiz = content_margin_horizontal_touch
	else:
		content_martgin_vert = content_margin_vertical_normal
		content_margin_horiz = content_margin_horizontal_normal
		
	for sbs in get_stylebox_list("Button"):
		var sb : StyleBoxTexture = get_stylebox(sbs, "Button") as StyleBoxTexture
		
		if sb == null:
			continue

		sb.content_margin_top = content_martgin_vert
		sb.content_margin_bottom = content_martgin_vert
		
		sb.content_margin_left = content_margin_horiz
		sb.content_margin_right = content_margin_horiz
		


	
