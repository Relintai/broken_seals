tool
extends HBoxContainer

var edited_world : WorldGenWorld = null
var edited_continent : Continent = null
var edited_zone : Zone = null

func _ready():
	var coption_button : OptionButton = $HSplitContainer/VBoxContainer/ContinentOptionButton
	coption_button.connect("item_selected", self, "on_continent_item_selected")
	
	var zoption_button : OptionButton = $HSplitContainer/VBoxContainer/ZoneOptionButton
	zoption_button.connect("item_selected", self, "on_zone_item_selected")

func set_plugin(plugin : EditorPlugin) -> void:
	$HSplitContainer/VBoxContainer/HBoxContainer2/ResourcePropertyList.set_plugin(plugin)
	$HSplitContainer/VBoxContainer/HBoxContainer2/VBoxContainer/DataList.set_plugin(plugin)
	$HSplitContainer/RectEditor.set_plugin(plugin)

func refresh() -> void:
	var option_button : OptionButton = $HSplitContainer/VBoxContainer/ContinentOptionButton
	option_button.clear()
	edited_continent = null
	edited_zone = null

	if !edited_world:
		return
	
	var content : Array = edited_world.get_content()
	
	for c in content:
		if c:
			option_button.add_item(c.resource_name)
			option_button.set_item_metadata(option_button.get_item_count() - 1, c)
			
			if !edited_continent:
				edited_continent = c
			
	continent_changed()

func continent_changed() -> void:
	var option_button : OptionButton = $HSplitContainer/VBoxContainer/ZoneOptionButton
	option_button.clear()
	edited_zone = null

	if !edited_continent:
		return
	
	var content : Array = edited_continent.get_content()
	
	for c in content:
		if c:
			option_button.add_item(c.resource_name)
			option_button.set_item_metadata(option_button.get_item_count() - 1, c)
			
			if !edited_zone:
				edited_zone = c
				
	zone_changed()

func zone_changed() -> void:
	$HSplitContainer/VBoxContainer/HBoxContainer2/ResourcePropertyList.edit_resource(edited_zone)
	$HSplitContainer/VBoxContainer/HBoxContainer2/VBoxContainer/DataList.set_edited_resource(edited_zone)
	$HSplitContainer/RectEditor.set_edited_resource(edited_zone)
	
func set_continent(continent : Continent) -> void:
	edited_continent = continent
	edited_zone = null
	
	continent_changed()

func set_zone(zone : Zone) -> void:
	edited_zone = zone
	
	zone_changed()

func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	edited_continent = null
	edited_zone = null
	
	refresh()

func on_continent_item_selected(idx : int) -> void:
	var option_button : OptionButton = $HSplitContainer/VBoxContainer/ContinentOptionButton
	
	set_continent(option_button.get_item_metadata(idx))

func on_zone_item_selected(idx : int) -> void:
	var option_button : OptionButton = $HSplitContainer/VBoxContainer/ZoneOptionButton
	
	set_zone(option_button.get_item_metadata(idx))
