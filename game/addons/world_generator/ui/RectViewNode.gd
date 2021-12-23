tool
extends MarginContainer

var edited_resource : WorldGenBaseResource = null

func _draw():
	draw_rect(Rect2(get_position(), get_size()), Color(1, 1, 1, 1))

func refresh() -> void:
	if !edited_resource:
		return
		
	var rect : Rect2 = edited_resource.get_rect()
	
	rect_position = rect.position
	rect_size = rect.size
	
	update()

func set_edited_resource(res : WorldGenBaseResource):
	edited_resource = res
	
	refresh()
	
