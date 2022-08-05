tool
extends PanelContainer

var edited_world

func _ready():
	var world : Control = get_node("TabContainer/World")
	if !world.is_connected("request_item_edit", self, "on_world_request_item_edit"):
		world.connect("request_item_edit", self, "on_world_request_item_edit")

func set_plugin(plugin : EditorPlugin) -> void:
	$TabContainer/World.set_plugin(plugin)
	$TabContainer/Continent.set_plugin(plugin)
	$TabContainer/Zone.set_plugin(plugin)
	$TabContainer/SubZone.set_plugin(plugin)
	$TabContainer/SubZoneProp.set_plugin(plugin)

func refresh() -> void:
	$TabContainer/World.set_wgworld(edited_world)
	$TabContainer/Continent.set_wgworld(edited_world)
	$TabContainer/Zone.set_wgworld(edited_world)
	$TabContainer/SubZone.set_wgworld(edited_world)
	$TabContainer/SubZoneProp.set_wgworld(edited_world)

func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()

func on_world_request_item_edit(resource : WorldGenBaseResource) -> void:
	var cont : Control = get_node("TabContainer/Continent")
	
	var tc : TabContainer = get_node("TabContainer")
	tc.current_tab = cont.get_position_in_parent()
	
	cont.switch_to(resource)
