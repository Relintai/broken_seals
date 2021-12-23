tool
extends Control

#"res://addons/world_generator/ui/RectEditorNode.tscn"

var edited_resource : WorldGenBaseResource = null

func _draw():
	draw_rect(Rect2(Vector2(), get_size()), Color(0.2, 0.2, 0.2, 1))
	
func refresh() -> void:
	clear()
	
	if !edited_resource:
		return
	
	var rect : Rect2 = edited_resource.rect
	
	set_custom_minimum_size(rect.size)
	
	var p : MarginContainer = get_parent() as MarginContainer

	p.add_constant_override("margin_left", rect.size.x / 4.0)
	p.add_constant_override("margin_right", rect.size.x / 4.0)
	p.add_constant_override("margin_top", rect.size.y / 4.0)
	p.add_constant_override("margin_bottom", rect.size.y / 4.0)

func clear() -> void:
	pass
	
func set_edited_resource(res : WorldGenBaseResource):
	if edited_resource:
		edited_resource.disconnect("changed", self, "on_edited_resource_changed")
	
	edited_resource = res
	
	refresh()
	
	if edited_resource:
		edited_resource.connect("changed", self, "on_edited_resource_changed")

func on_edited_resource_changed() -> void:
	pass
	#refresh()
