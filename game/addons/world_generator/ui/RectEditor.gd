tool
extends PanelContainer

var last_edited_res : WorldGenBaseResource = null

func _init():
#	Control/EditorZoomWidget
	pass

func set_plugin(plugin : EditorPlugin) -> void:
	$ScrollContainer/MarginContainer/RectView.set_plugin(plugin)

func set_edited_resource(res : WorldGenBaseResource):
	if res && res != last_edited_res:
		var r : Rect2 = res.get_rect()
		
		if r.size.x > 0:
			var rsx : float = $ScrollContainer/MarginContainer.rect_size.x
			var scale : float = rsx / r.size.x
			
			$Control/EditorZoomWidget.zoom = scale
			
		
	
	$ScrollContainer/MarginContainer/RectView.set_edited_resource(res)
