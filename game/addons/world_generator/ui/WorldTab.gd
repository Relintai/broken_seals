tool
extends HBoxContainer

var edited_world

func set_plugin(plugin : EditorPlugin) -> void:
	$HSplitContainer/ResourcePropertyList.set_plugin(plugin)
	$HSplitContainer/RectEditor.set_plugin(plugin)
	$VBoxContainer/DataList.set_plugin(plugin)

func refresh() -> void:
	$HSplitContainer/ResourcePropertyList.edit_resource(edited_world)
	$VBoxContainer/DataList.set_edited_resource(edited_world)
	$HSplitContainer/RectEditor.set_edited_resource(edited_world)
	
func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()
