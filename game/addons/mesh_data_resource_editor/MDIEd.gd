tool
extends Control

var plugin : EditorPlugin

export var uv_editor_path : NodePath

var uv_editor : Node

func _enter_tree():
	uv_editor = get_node(uv_editor_path)
	
func set_mesh_data_resource(a : MeshDataResource) -> void:
	if uv_editor:
		uv_editor.set_mesh_data_resource(a)

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
		if plugin:
			plugin.set_translate(on)

func on_edit_mode_rotate_toggled(on : bool) -> void:
	if on:
		if plugin:
			plugin.set_rotate(on)
			
func on_edit_mode_scale_toggled(on : bool) -> void:
	if on:
		if plugin:
			plugin.set_scale(on)

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
	if plugin:
		plugin.set_axis_x(on)

func on_axis_y_toggled(on : bool) -> void:
	if plugin:
		plugin.set_axis_y(on)
			
func on_axis_z_toggled(on : bool) -> void:
	if plugin:
		plugin.set_axis_z(on)

#selection modes
func on_selection_mode_vertex_toggled(on : bool) -> void:
	if on:
		if plugin:
			plugin.set_selection_mode_vertex()

func on_selection_mode_edge_toggled(on : bool) -> void:
	if on:
		if plugin:
			plugin.set_selection_mode_edge()
			
func on_selection_mode_face_toggled(on : bool) -> void:
	if on:
		if plugin:
			plugin.set_selection_mode_face()

func set_selection_mode_vertex() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer3/Vertex.pressed = true

func set_selection_mode_edge() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer3/Edge.pressed = true
			
func set_selection_mode_face() -> void:
	$VBoxContainer/Actions/Actions/VBoxContainer2/HBoxContainer3/Face.pressed = true


func _on_Extrude_pressed():
	pass # Replace with function body.

func _on_AddBox_pressed():
	plugin.add_box()

func _on_UnwrapButton_pressed():
	plugin.uv_unwrap()

func _on_add_triangle_pressed():
	plugin.add_triangle()

func _on_add_quad_pressed():
	plugin.add_quad()

func _on_split_pressed():
	plugin.split()

func _on_connect_to_first_selected_pressed():
	plugin.onnect_to_first_selected()
	
func _on_connect_to_avg_pressed():
	plugin.connect_to_avg()
	
func _on_connect_to_last_selected_pressed():
	plugin.connect_to_last_selected()

func _on_disconnect_pressed():
	plugin.disconnect_action()

func _on_add_triangle_at_pressed():
	plugin.add_triangle_at()

func _on_add_auad_at_pressed():
	plugin.add_quad_at()

func _oncreate_face_pressed():
	plugin.create_face()

func _on_delete_pressed():
	plugin.delete_selected()

func _on_GenNormals_pressed():
	plugin.generate_normals()

func _on_RemDoubles_pressed():
	plugin.remove_doubles()

func _on_MergeOptimize_pressed():
	plugin.merge_optimize()

func _on_GenTangents_pressed():
	plugin.generate_tangents()

func _on_mark_seam_pressed():
	plugin.mark_seam()

func _on_unmark_seam_pressed():
	plugin.unmark_seam()
