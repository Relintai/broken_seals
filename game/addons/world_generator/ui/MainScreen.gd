tool
extends PanelContainer

var edited_world

func _ready():
	var world : Control = get_node("TabContainer/World")
	if !world.is_connected("request_item_edit", self, "on_world_request_item_edit"):
		world.connect("request_item_edit", self, "on_world_request_item_edit")
		
	var continent : Control = get_node("TabContainer/Continent")
	if !continent.is_connected("request_item_edit", self, "on_continent_request_item_edit"):
		continent.connect("request_item_edit", self, "on_continent_request_item_edit")
		
	var zone : Control = get_node("TabContainer/Zone")
	if !zone.is_connected("request_item_edit", self, "on_zone_request_item_edit"):
		zone.connect("request_item_edit", self, "on_zone_request_item_edit")
	
	var subzone : Control = get_node("TabContainer/SubZone")
	if !subzone.is_connected("request_item_edit", self, "on_subzone_request_item_edit"):
		subzone.connect("request_item_edit", self, "on_subzone_request_item_edit")
		

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

func on_continent_request_item_edit(continent : WorldGenBaseResource, resource : WorldGenBaseResource) -> void:
	var zone : Control = get_node("TabContainer/Zone")
	
	var tc : TabContainer = get_node("TabContainer")
	tc.current_tab = zone.get_position_in_parent()

	zone.switch_to(continent, resource)
	
func on_zone_request_item_edit(continent : WorldGenBaseResource, zone : WorldGenBaseResource, subzone : WorldGenBaseResource) -> void:
	var sz : Control = get_node("TabContainer/SubZone")
	
	var tc : TabContainer = get_node("TabContainer")
	tc.current_tab = sz.get_position_in_parent()

	sz.switch_to(continent, zone, subzone)

func on_subzone_request_item_edit(continent : WorldGenBaseResource, zone : WorldGenBaseResource, subzone : WorldGenBaseResource, subzone_prop : WorldGenBaseResource) -> void:
	var sz : Control = get_node("TabContainer/SubZoneProp")
	
	var tc : TabContainer = get_node("TabContainer")
	tc.current_tab = sz.get_position_in_parent()

	sz.switch_to(continent, zone, subzone, subzone_prop)
