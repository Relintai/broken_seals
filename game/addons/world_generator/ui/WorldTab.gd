tool
extends HBoxContainer

var edited_world

func refresh() -> void:
	$HSplitContainer/ResourcePropertyList.edit_resource(edited_world)
	$VBoxContainer/DataList.set_edited_resource(edited_world)
	$HSplitContainer/RectEditor.set_edited_resource(edited_world)
	
func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()
