tool
extends MenuButton

var popup = get_popup()
signal item_pressed

func _ready():
	popup.connect("id_pressed", self, "id_pressed")

func id_pressed(id):
	emit_signal("item_pressed", name, popup.get_item_text(id), id)


