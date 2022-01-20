tool
extends Control

var MeshDecompose = preload("res://addons/mesh_data_resource_editor/utilities/mesh_decompose.gd")

var rect_editor_node_scene : PackedScene = preload("res://addons/mesh_data_resource_editor/uv_editor/RectViewNode.tscn")

export(NodePath) var zoom_widget_path : NodePath = ""

var _rect_scale : float = 1

var _mdr : MeshDataResource = null
var _background_texture : Texture = null

var base_rect : Rect2 = Rect2(0, 0, 600, 600)
var edited_resource_current_size : Vector2 = Vector2()

var _stored_uvs : PoolVector2Array = PoolVector2Array()

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
	if is_visible_in_tree():
		store_uvs()
		call_deferred("refresh")

func apply_zoom() -> void:
	var rect : Rect2 = base_rect
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
	
	if _background_texture:
		draw_texture_rect_region(_background_texture, Rect2(Vector2(), get_size()), Rect2(Vector2(), _background_texture.get_size()))

func refresh() -> void:
	clear()
	
	var rect : Rect2 = base_rect
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
	
	if !_mdr:
		return
		
	var partitions : Array = MeshDecompose.partition_mesh(_mdr)
	
	for p in partitions:
		var s : Node = rect_editor_node_scene.instance()

		add_child(s)
		s.set_editor_rect_scale(_rect_scale)
		s.edited_resource_parent_size = edited_resource_current_size
		s.set_edited_resource(_mdr, p)

func clear_rects():
	for c in get_children():
		c.queue_free()
		remove_child(c)

func set_mesh_data_resource(a : MeshDataResource) -> void:
	_mdr = a

func set_mesh_data_instance(a : MeshDataInstance) -> void:
	_background_texture = null
	
	if a:
		_background_texture = a.texture

func on_edited_resource_changed() -> void:
	call_deferred("refresh")

func get_uvs(mdr : MeshDataResource) -> PoolVector2Array:
	if !_mdr:
		return PoolVector2Array()

	var arrays : Array = _mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return PoolVector2Array()
		
	if arrays[ArrayMesh.ARRAY_TEX_UV] == null:
		return PoolVector2Array()
		
	return arrays[ArrayMesh.ARRAY_TEX_UV]

func store_uvs() -> void:
	_stored_uvs.resize(0)

	if !_mdr:
		return

	var arrays : Array = _mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return
		
	if arrays[ArrayMesh.ARRAY_TEX_UV] == null:
		return
		
	# Make sure it gets copied
	_stored_uvs.append_array(arrays[ArrayMesh.ARRAY_TEX_UV])

func apply_uvs(mdr : MeshDataResource, stored_uvs : PoolVector2Array) -> void:
	if !_mdr:
		return

	var arrays : Array = _mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return
		
	if arrays[ArrayMesh.ARRAY_TEX_UV] == null:
		return
		
	arrays[ArrayMesh.ARRAY_TEX_UV] = stored_uvs
	
	_mdr.array = arrays

func ok_pressed() -> void:
	_undo_redo.create_action("UV Editor Accept")
	_undo_redo.add_do_method(self, "apply_uvs", _mdr, get_uvs(_mdr))
	_undo_redo.add_undo_method(self, "apply_uvs", _mdr, _stored_uvs)
	_undo_redo.commit_action()
	
func cancel_pressed() -> void:
	if !_mdr:
		return

	var arrays : Array = _mdr.get_array()
	
	if arrays.size() != ArrayMesh.ARRAY_MAX:
		return
		
	# Make sure it gets copied
	var uvs : PoolVector2Array = PoolVector2Array()
	uvs.append_array(_stored_uvs)

	_undo_redo.create_action("UV Editor Cancel")
	_undo_redo.add_do_method(self, "apply_uvs", _mdr, uvs)
	_undo_redo.add_undo_method(self, "apply_uvs", _mdr, get_uvs(_mdr))
	_undo_redo.commit_action()
	
	_stored_uvs.resize(0)
