tool
extends PanelContainer

var edited_world

func refresh() -> void:
	pass

func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()
