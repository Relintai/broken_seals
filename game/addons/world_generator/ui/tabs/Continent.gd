tool
extends HBoxContainer

var edited_world : WorldGenWorld = null
var edited_continent : Continent = null

func _ready():
	var option_button : OptionButton = $HSplitContainer/VBoxContainer/OptionButton
	option_button.connect("item_selected", self, "on_item_selected")

func set_plugin(plugin : EditorPlugin) -> void:
	$HSplitContainer/VBoxContainer/HBoxContainer2/ResourcePropertyList.set_plugin(plugin)
	$HSplitContainer/VBoxContainer/HBoxContainer2/VBoxContainer/DataList.set_plugin(plugin)
	$HSplitContainer/RectEditor.set_plugin(plugin)

func refresh_continent() -> void:
	$HSplitContainer/VBoxContainer/HBoxContainer2/ResourcePropertyList.edit_resource(edited_continent)
	$HSplitContainer/VBoxContainer/HBoxContainer2/VBoxContainer/DataList.set_edited_resource(edited_continent)
	$HSplitContainer/RectEditor.set_edited_resource(edited_continent)

#	if !edited_continent:
#		return

func refresh() -> void:
	var option_button : OptionButton = $HSplitContainer/VBoxContainer/OptionButton
	option_button.clear()

	if !edited_world:
		return
	
	var content : Array = edited_world.get_content()
	
	for c in content:
		if c:
			option_button.add_item(c.resource_name)
			option_button.set_item_metadata(option_button.get_item_count() - 1, c)
			
			if !edited_continent:
				edited_continent = c
			
	refresh_continent()
	
func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()

func set_continent(continent : Continent) -> void:
	edited_continent = continent
	
	refresh_continent()

func on_item_selected(idx : int) -> void:
	var option_button : OptionButton = $HSplitContainer/VBoxContainer/OptionButton
	
	set_continent(option_button.get_item_metadata(idx))
