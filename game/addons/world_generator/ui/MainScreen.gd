tool
extends PanelContainer

var edited_world

func set_plugin(plugin : EditorPlugin) -> void:
	$TabContainer/World.set_plugin(plugin)
	$TabContainer/Continent.set_plugin(plugin)
	$TabContainer/Zone.set_plugin(plugin)
	$TabContainer/SubZone.set_plugin(plugin)

func refresh() -> void:
	$TabContainer/World.set_wgworld(edited_world)
	$TabContainer/Continent.set_wgworld(edited_world)
	$TabContainer/Zone.set_wgworld(edited_world)
	$TabContainer/SubZone.set_wgworld(edited_world)

func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()
