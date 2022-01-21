tool
extends Control

var rect_editor_node_scene : PackedScene = preload("res://addons/world_generator/ui/RectViewNode.tscn")

export(NodePath) var zoom_widget_path : NodePath = ""

var _rect_scale : float = 1

var edited_resource : WorldGenBaseResource = null
var edited_resource_current_size : Vector2 = Vector2()

var _plugin : EditorPlugin = null
var _undo_redo : UndoRedo = null

func _enter_tree():
	var zoom_widget : Node = get_node_or_null(zoom_widget_path)
	
	if !zoom_widget:
		return
	
	if !zoom_widget.is_connected("zoom_changed", self, "on_zoom_changed"):
		zoom_widget.connect("zoom_changed", self, "on_zoom_changed")
	
	if !is_connected("visibility_changed", self, "on_visibility_changed"):
		connect("visibility_changed", self, "on_visibility_changed")

func set_plugin(plugin : EditorPlugin) -> void:
	_plugin = plugin
	_undo_redo = _plugin.get_undo_redo()

func on_visibility_changed() -> void:
	call_deferred("apply_zoom")

func apply_zoom() -> void:
	if !edited_resource:
		return
	
	var rect : Rect2 = edited_resource.rect
	edited_resource_current_size = rect.size
	rect.position = rect.position * _rect_scale
	rect.size = rect.size * _rect_scale
	set_custom_minimum_size(rect.size)
	
	var p : MarginContainer = get_parent() as MarginContainer

	p.add_constant_override("margin_left", min(rect.size.x / 4.0, 50 * _rect_scale))
	p.add_constant_override("margin_right", min(rect.size.x / 4.0, 50 * _rect_scale))
	p.add_constant_override("margin_top", min(rect.size.y / 4.0, 50 * _rect_scale))
	p.add_constant_override("margin_bottom", min(rect.size.y / 4.0, 50 * _rect_scale))
	
	for c in get_children():
		c.set_editor_rect_scale(_rect_scale)
	
func on_zoom_changed(zoom : float) -> void:
	_rect_scale = zoom
	apply_zoom()

func _draw():
	draw_rect(Rect2(Vector2(), get_size()), Color(0.2, 0.2, 0.2, 1))
	
func refresh() -> void:
	clear()
	
	if !edited_resource:
		return
	
	var rect : Rect2 = edited_resource.rect
	edited_resource_current_size = rect.size
	rect.position = rect.position * _rect_scale
	rect.size = rect.size * _rect_scale
	set_custom_minimum_size(rect.size)
	
	apply_zoom()
	
	refresh_rects()
	
func clear() -> void:
	pass
	
func refresh_rects() -> void:
	clear_rects()
	
	if !edited_resource:
		return
	
	var cont : Array = edited_resource.get_content()
	
	for c in cont:
		if c:
			var s : Node = rect_editor_node_scene.instance()
			
			add_child(s)
			s.set_plugin(_plugin)
			s.set_editor_rect_scale(_rect_scale)
			s.edited_resource_parent_size = edited_resource_current_size
			s.set_edited_resource(c)

func clear_rects():
	for c in get_children():
		c.queue_free()
		remove_child(c)

func set_edited_resource(res : WorldGenBaseResource):
	if edited_resource:
		edited_resource.disconnect("changed", self, "on_edited_resource_changed")
	
	edited_resource = res
	
	refresh()
	
	if edited_resource:
		edited_resource.connect("changed", self, "on_edited_resource_changed")

func on_edited_resource_changed() -> void:
	call_deferred("refresh")
