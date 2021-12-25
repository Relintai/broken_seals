tool
extends PanelContainer

var edited_world

func refresh() -> void:
	$TabContainer/World.set_wgworld(edited_world)
	$TabContainer/Continent.set_wgworld(edited_world)
	$TabContainer/Zone.set_wgworld(edited_world)
	$TabContainer/SubZone.set_wgworld(edited_world)

func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()
