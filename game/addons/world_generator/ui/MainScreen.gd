tool
extends PanelContainer

var edited_world

func refresh() -> void:
	$TabContainer/World/HSplitContainer/ResourcePropertyList.edit_resource(edited_world)
	$TabContainer/World/VBoxContainer/DataList.set_edited_resource(edited_world)

func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()
