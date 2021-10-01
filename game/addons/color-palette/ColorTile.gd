tool
class_name ColorTile
extends ColorRect

signal tile_deleted(index)
signal tile_selected(index)

onready var parent = get_parent()

var dragging: bool = false

func _ready():
	rect_min_size = Vector2(30,30)
	mouse_filter = MOUSE_FILTER_PASS

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			parent.dragging = self
			parent.drag_start_index = get_index()
			emit_signal("tile_selected", get_index())
			accept_event()
			return
		if event.button_index == BUTTON_RIGHT and event.is_pressed():
			emit_signal("tile_deleted", get_index())
			accept_event()
			return
		
