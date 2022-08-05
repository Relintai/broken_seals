tool
extends PanelContainer

var last_edited_res : WorldGenBaseResource = null

func set_plugin(plugin : EditorPlugin) -> void:
	get_node("ScrollContainer/MarginContainer/RectView").set_plugin(plugin)

func set_edited_resource(res : WorldGenBaseResource):
	get_node("ScrollContainer/MarginContainer/RectView").set_edited_resource(res)
	
	if res && res != last_edited_res:
		var r : Rect2 = res.get_rect()
		last_edited_res = res
		
		if r.size.x > 0:
			var rsx : float = get_node("ScrollContainer").rect_size.x
			var scale : float = rsx / r.size.x * 0.8
			
			get_node("Control/EditorZoomWidget").zoom = scale
			get_node("ScrollContainer/MarginContainer/RectView").apply_zoom()
	
			var sb : ScrollBar = get_node("ScrollContainer").get_h_scrollbar()
			sb.ratio = 1
					
			sb = get_node("ScrollContainer").get_v_scrollbar()
			sb.ratio = 1
