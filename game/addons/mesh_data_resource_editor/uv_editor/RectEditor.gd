tool
extends PanelContainer

func set_plugin(plugin : EditorPlugin) -> void:
	$ScrollContainer/MarginContainer/RectView.set_plugin(plugin)

func set_mesh_data_resource(a : MeshDataResource) -> void:
	$ScrollContainer/MarginContainer/RectView.set_mesh_data_resource(a)

func set_mesh_data_instance(a : MeshDataInstance) -> void:
	$ScrollContainer/MarginContainer/RectView.set_mesh_data_instance(a)

func ok_pressed() -> void:
	$ScrollContainer/MarginContainer/RectView.ok_pressed()
	
func cancel_pressed() -> void:
	$ScrollContainer/MarginContainer/RectView.cancel_pressed()
	
