tool
extends Control

var _plugin : EditorPlugin

export var uv_preview_path : NodePath
export var uv_editor_path : NodePath

var uv_preview : Node
var uv_editor : Node

func _enter_tree():
	uv_preview = get_node(uv_preview_path)
	uv_editor = get_node(uv_editor_path)
	
	if _plugin && uv_editor:
		uv_editor.set_plugin(_plugin)
	
func set_plugin(plugin : EditorPlugin) -> void:
	_plugin = plugin
	
	if uv_editor:
		uv_editor.set_plugin(plugin)
	
func set_mesh_data_resource(a : MeshDataResource) -> void:
	if uv_preview:
		uv_preview.set_mesh_data_resource(a)
		
	if uv_editor:
		uv_editor.set_mesh_data_resource(a)

func set_mesh_data_instance(a : MeshDataInstance) -> void:
	if uv_preview:
		uv_preview.set_mesh_data_instance(a)
		
	if uv_editor:
		uv_editor.set_mesh_data_instance(a)

func _unhandled_key_input(event : InputEventKey) -> void:
	if event.echo:
		return
	
	if event.alt || event.shift || event.control || event.meta || event.command:
		return
	
	if event.scancode == KEY_G:
		set_edit_mode_translate()
	elif event.scancode == KEY_H:
		set_edit_mode_rotate()
	elif event.scancode == KEY_J:
		set_edit_mode_scale()
		
	elif event.scancode == KEY_V:
		set_axis_x(!get_axis_x())
	elif event.scancode == KEY_B:
		set_axis_y(!get_axis_y())
	elif event.scancode == KEY_N:
		set_axis_z(!get_axis_z())
	
	elif event.scancode == KEY_K:
		set_selection_mode_vertex()
	elif event.scancode == KEY_L:
		set_selection_mode_edge()
	elif event.scancode == KEY_SEMICOLON:
		set_selection_mode_face()

#Edit modes
func set_edit_mode_translate() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer/Translate.pressed = true

func set_edit_mode_rotate() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer/Rotate.pressed = true
			
func set_edit_mode_scale() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer/Scale.pressed = true

func on_edit_mode_translate_toggled(on : bool) -> void:
	if on:
		if _plugin:
			_plugin.set_translate()

func on_edit_mode_rotate_toggled(on : bool) -> void:
	if on:
		if _plugin:
			_plugin.set_rotate()
			
func on_edit_mode_scale_toggled(on : bool) -> void:
	if on:
		if _plugin:
			_plugin.set_scale()

#axis locks
func get_axis_x() -> bool:
	return $VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer2/AxisX.pressed

func get_axis_y() -> bool:
	return $VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer2/AxisY.pressed
			
func get_axis_z() -> bool:
	return $VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer2/AxisZ.pressed

func set_axis_x(on : bool) -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer2/AxisX.pressed = on

func set_axis_y(on : bool) -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer2/AxisY.pressed = on
			
func set_axis_z(on : bool) -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer2/AxisZ.pressed = on

func on_axis_x_toggled(on : bool) -> void:
	if _plugin:
		_plugin.set_axis_x(on)

func on_axis_y_toggled(on : bool) -> void:
	if _plugin:
		_plugin.set_axis_y(on)
			
func on_axis_z_toggled(on : bool) -> void:
	if _plugin:
		_plugin.set_axis_z(on)

#selection modes
func on_selection_mode_vertex_toggled(on : bool) -> void:
	if on:
		if _plugin:
			_plugin.set_selection_mode_vertex()

func on_selection_mode_edge_toggled(on : bool) -> void:
	if on:
		if _plugin:
			_plugin.set_selection_mode_edge()
			
func on_selection_mode_face_toggled(on : bool) -> void:
	if on:
		if _plugin:
			_plugin.set_selection_mode_face()

func set_selection_mode_vertex() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer3/Vertex.pressed = true

func set_selection_mode_edge() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer3/Edge.pressed = true
			
func set_selection_mode_face() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer3/Face.pressed = true


func _on_Extrude_pressed():
	_plugin.extrude()

func _on_AddBox_pressed():
	_plugin.add_box()

func _on_UnwrapButton_pressed():
	_plugin.uv_unwrap()

func _on_add_triangle_pressed():
	_plugin.add_triangle()

func _on_add_quad_pressed():
	_plugin.add_quad()

func _on_split_pressed():
	_plugin.split()

func _on_connect_to_first_selected_pressed():
	_plugin.connect_to_first_selected()
	
func _on_connect_to_avg_pressed():
	_plugin.connect_to_avg()
	
func _on_connect_to_last_selected_pressed():
	_plugin.connect_to_last_selected()

func _on_disconnect_pressed():
	_plugin.disconnect_action()

func _on_add_triangle_at_pressed():
	_plugin.add_triangle_at()

func _on_add_auad_at_pressed():
	_plugin.add_quad_at()

func _oncreate_face_pressed():
	_plugin.create_face()

func _on_delete_pressed():
	_plugin.delete_selected()

func _on_GenNormals_pressed():
	_plugin.generate_normals()

func _on_RemDoubles_pressed():
	_plugin.remove_doubles()

func _on_MergeOptimize_pressed():
	_plugin.merge_optimize()

func _on_GenTangents_pressed():
	_plugin.generate_tangents()

func _on_mark_seam_pressed():
	_plugin.mark_seam()

func _on_unmark_seam_pressed():
	_plugin.unmark_seam()

func _on_apply_seams_pressed():
	_plugin.apply_seam()

func _on_uv_edit_pressed():
	$Popups/UVEditorPopup.popup_centered()

func on_pivot_average_toggled(on : bool):
	if on:
		_plugin.set_pivot_averaged()

func on_pivot_mdi_origin_toggled(on : bool):
	if on:
		_plugin.set_pivot_mdi_origin()

func on_pivot_world_origin_toggled(on : bool):
	if on:
		_plugin.set_pivot_world_origin()

func on_visual_indicator_outline_toggled(on : bool):
	_plugin.visual_indicator_outline_set(on)

func on_visual_indicator_seam_toggled(on : bool):
	_plugin.visual_indicator_seam_set(on)

func on_visual_indicator_handle_toggled(on : bool):
	_plugin.visual_indicator_handle_set(on)

func _on_select_all_pressed():
	_plugin.select_all()

func onhandle_selection_type_front_toggled(on : bool):
	if on:
		_plugin.handle_selection_type_front()

func onhandle_selection_type_back_toggled(on : bool):
	if on:
		_plugin.handle_selection_type_back()

func onhandle_selection_type_all_toggled(on : bool):
	if on:
		_plugin.handle_selection_type_all()

func _on_clean_mesh_pressed():
	_plugin.clean_mesh()

func _on_flip_face_pressed():
	_plugin.flip_selected_faces()
