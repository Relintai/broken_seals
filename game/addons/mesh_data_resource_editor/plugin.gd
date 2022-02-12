tool
extends EditorPlugin

const MDRMeshUtils = preload("res://addons/mesh_data_resource_editor/utilities/mdred_mesh_utils.gd")

const MdiGizmoPlugin = preload("res://addons/mesh_data_resource_editor/MDIGizmoPlugin.gd")
const MDIEdGui = preload("res://addons/mesh_data_resource_editor/MDIEd.tscn")

var gizmo_plugin = MdiGizmoPlugin.new()
var mdi_ed_gui : Control

var active_gizmos : Array

var current_mesh_data_instance : MeshDataInstance = null

func _enter_tree():
	gizmo_plugin = MdiGizmoPlugin.new()
	mdi_ed_gui = MDIEdGui.instance()
	mdi_ed_gui.set_plugin(self)
	active_gizmos = []
	
	gizmo_plugin.plugin = self
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, mdi_ed_gui)
	mdi_ed_gui.hide()
	
	add_spatial_gizmo_plugin(gizmo_plugin)
	
	set_input_event_forwarding_always_enabled()

func _exit_tree():
	#print("_exit_tree")
	
	remove_spatial_gizmo_plugin(gizmo_plugin)
	#remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, mdi_ed_gui)
	mdi_ed_gui.queue_free()
	pass
	
#func enable_plugin():
#	print("enable_plugin")
#	pass
#
#func disable_plugin():
#	print("disable_plugin")
#	remove_spatial_gizmo_plugin(gizmo_plugin)
#	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, mdi_ed_gui)
#	mdi_ed_gui.queue_free()

func handles(object):
	#print("disable_plugin")
	
	if object is MeshDataInstance:
		return true
		
	return false

func edit(object):
	var mdi : MeshDataInstance = object as MeshDataInstance

	if mdi:
		if current_mesh_data_instance && mdi.gizmo && current_mesh_data_instance.gizmo:
			mdi.gizmo.transfer_state_from(current_mesh_data_instance.gizmo)
			
		mdi_ed_gui.set_mesh_data_resource(mdi.mesh_data)
		mdi_ed_gui.set_mesh_data_instance(mdi)
		
	current_mesh_data_instance = mdi

func make_visible(visible):
	#print("make_visible")
	
	if visible:
		mdi_ed_gui.show()
	else:
		#mdi_ed_gui.hide()
		#figure out how to hide it when something else gets selected, don't hide on unselect
		pass

func get_plugin_name():
	return "mesh_data_resource_editor"
	

#func forward_spatial_gui_input(camera, event):
#	return forward_spatial_gui_input(0, camera, event)

func register_gizmo(gizmo):
	active_gizmos.append(gizmo)
	
func unregister_gizmo(gizmo):
	for i in range(active_gizmos.size()):
		if active_gizmos[i] == gizmo:
			active_gizmos.remove(i)
			return

func set_translate() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_translate()
	
func set_scale() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_scale()
	
func set_rotate() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_rotate()
	
func set_axis_x(on : bool) -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_axis_x(on)
	
func set_axis_y(on : bool) -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_axis_y(on)
	
func set_axis_z(on : bool) -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_axis_z(on)

func set_selection_mode_vertex() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_selection_mode_vertex()

func set_selection_mode_edge() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_selection_mode_edge()
			
func set_selection_mode_face() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_selection_mode_face()

func get_mdr() -> MeshDataResource:
	if current_mesh_data_instance:
		return current_mesh_data_instance.mesh_data
		
	return null

	
#func forward_spatial_gui_input(camera, event):
#	for g in active_gizmos:
#		if g.forward_spatial_gui_input(0, camera, event):
#			return true
#
#	return false

func forward_spatial_gui_input(index, camera, event):
	if (!is_instance_valid(current_mesh_data_instance)):
		current_mesh_data_instance = null
		
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		if current_mesh_data_instance.gizmo.forward_spatial_gui_input(index, camera, event):
			return true

	return false

func add_box() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.add_box()

func add_triangle() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.add_triangle()
		
func add_quad() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.add_quad()

func add_triangle_at() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.add_triangle_at()
		
func add_quad_at() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.add_quad_at()

func split():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.split()

func connect_action():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.connect_action()

func disconnect_action():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.disconnect_action()

func create_face():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.create_face()

func delete_selected():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.delete_selected()

func generate_normals():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.generate_normals()
		
func remove_doubles():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.remove_doubles()
		
func merge_optimize():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.merge_optimize()
		
func generate_tangents():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.generate_tangents()
		
func connect_to_first_selected():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.connect_to_first_selected()
		
func connect_to_avg():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.connect_to_avg()
		
func connect_to_last_selected():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.connect_to_last_selected()

func mark_seam():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.mark_seam()
		
func unmark_seam():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.unmark_seam()

func apply_seam():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.apply_seam()

func uv_unwrap() -> void:
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.uv_unwrap()
	
func set_pivot_averaged():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_pivot_averaged()

func set_pivot_mdi_origin():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_pivot_mdi_origin()

func set_pivot_world_origin():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.set_pivot_world_origin()
		
func visual_indicator_outline_set(on : bool):
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.visual_indicator_outline_set(on)

func visual_indicator_seam_set(on : bool):
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.visual_indicator_seam_set(on)

func visual_indicator_handle_set(on : bool):
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.visual_indicator_handle_set(on)

func select_all():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.select_all()

func handle_selection_type_front():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.handle_selection_type_front()
		
func handle_selection_type_back():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.handle_selection_type_back()
		
func handle_selection_type_all():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.handle_selection_type_all()

func extrude():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.extrude()

func clean_mesh():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.clean_mesh()
		
func flip_selected_faces():
	if current_mesh_data_instance && current_mesh_data_instance.gizmo:
		current_mesh_data_instance.gizmo.flip_selected_faces()
