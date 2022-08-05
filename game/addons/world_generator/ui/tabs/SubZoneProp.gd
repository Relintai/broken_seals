tool
extends HBoxContainer

var edited_world : WorldGenWorld = null
var edited_continent : Continent = null
var edited_zone : Zone = null
var edited_sub_zone : SubZone = null
var edited_sub_zone_prop : SubZoneProp = null

func _ready():
	var coption_button : OptionButton = $VBoxContainer/ContinentOptionButton
	coption_button.connect("item_selected", self, "on_continent_item_selected")
	
	var zoption_button : OptionButton = $VBoxContainer/ZoneOptionButton
	zoption_button.connect("item_selected", self, "on_zone_item_selected")
	
	var szoption_button : OptionButton = $VBoxContainer/SubZoneOptionButton
	szoption_button.connect("item_selected", self, "on_sub_zone_item_selected")
	
	var szpoption_button : OptionButton = $VBoxContainer/SubZonePropOptionButton
	szpoption_button.connect("item_selected", self, "on_sub_zone_prop_item_selected")

func set_plugin(plugin : EditorPlugin) -> void:
	$VBoxContainer/HBoxContainer2/ResourcePropertyList.set_plugin(plugin)

func continent_changed() -> void:
	var option_button : OptionButton = $VBoxContainer/ZoneOptionButton
	option_button.clear()
	edited_zone = null
	edited_sub_zone = null

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
	var option_button : OptionButton = $VBoxContainer/SubZoneOptionButton
	option_button.clear()
	edited_sub_zone = null

	if !edited_zone:
		return
	
	var content : Array = edited_zone.get_content()
	
	for c in content:
		if c:
			option_button.add_item(c.resource_name)
			option_button.set_item_metadata(option_button.get_item_count() - 1, c)
			
			if !edited_sub_zone:
				edited_sub_zone = c
				
	sub_zone_changed()

func sub_zone_changed() -> void:
	var option_button : OptionButton = $VBoxContainer/SubZonePropOptionButton
	option_button.clear()
	edited_sub_zone_prop = null

	if !edited_sub_zone:
		return
	
	var content : Array = edited_sub_zone.get_content()
	
	for c in content:
		if c:
			option_button.add_item(c.resource_name)
			option_button.set_item_metadata(option_button.get_item_count() - 1, c)
			
			if !edited_sub_zone_prop:
				edited_sub_zone_prop = c
				
	sub_zone_prop_changed()

func sub_zone_prop_changed() -> void:
	$VBoxContainer/HBoxContainer2/ResourcePropertyList.edit_resource(edited_sub_zone_prop)
	
func refresh() -> void:
	var option_button : OptionButton = $VBoxContainer/ContinentOptionButton
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
			
	continent_changed()
	
func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	edited_continent = null
	edited_zone = null
	edited_sub_zone = null
	edited_sub_zone_prop = null
	
	refresh()

func set_continent(continent : Continent) -> void:
	edited_continent = continent
	edited_zone = null
	edited_sub_zone = null
	edited_sub_zone_prop = null
	
	continent_changed()

func set_zone(zone : Zone) -> void:
	edited_zone = zone
	edited_sub_zone = null
	edited_sub_zone_prop = null
	
	zone_changed()
	
func set_sub_zone(sub_zone : SubZone) -> void:
	edited_sub_zone = sub_zone
	edited_sub_zone_prop = null
	
	sub_zone_changed()

func set_sub_zone_prop(sub_zone_prop : SubZoneProp) -> void:
	edited_sub_zone_prop = sub_zone_prop
	
	sub_zone_prop_changed()

func switch_to(continent : WorldGenBaseResource, zone : WorldGenBaseResource, subzone : WorldGenBaseResource, subzone_prop : WorldGenBaseResource) -> void:
	var contob : OptionButton = $VBoxContainer/ContinentOptionButton
	
	for i in range(contob.get_item_count()):
		var ccont : Continent = contob.get_item_metadata(i)
		
		if (ccont == continent):
			contob.select(i)
			set_continent(continent)
			break
			
	var zoneob : OptionButton = $VBoxContainer/ZoneOptionButton
			
	for i in range(zoneob.get_item_count()):
		var czone : Zone = zoneob.get_item_metadata(i)
		
		if (czone == zone):
			zoneob.select(i)
			set_zone(zone)
			break
			
	var subzoneob : OptionButton = $VBoxContainer/SubZoneOptionButton
			
	for i in range(subzoneob.get_item_count()):
		var cszone : SubZone = subzoneob.get_item_metadata(i)
		
		if (cszone == subzone):
			subzoneob.select(i)
			set_sub_zone(subzone)
			break
	
	var subzonepropob : OptionButton = $VBoxContainer/SubZonePropOptionButton
			
	for i in range(subzonepropob.get_item_count()):
		var cszoneprop : SubZoneProp = subzonepropob.get_item_metadata(i)
		
		if (cszoneprop == subzone_prop):
			subzonepropob.select(i)
			set_sub_zone_prop(subzone_prop)
			return


func on_continent_item_selected(idx : int) -> void:
	var option_button : OptionButton = $VBoxContainer/ContinentOptionButton
	
	set_continent(option_button.get_item_metadata(idx))

func on_zone_item_selected(idx : int) -> void:
	var option_button : OptionButton = $VBoxContainer/ZoneOptionButton
	
	set_zone(option_button.get_item_metadata(idx))

func on_sub_zone_item_selected(idx : int) -> void:
	var option_button : OptionButton = $VBoxContainer/SubZoneOptionButton
	
	set_sub_zone(option_button.get_item_metadata(idx))

func on_sub_zone_prop_item_selected(idx : int) -> void:
	var option_button : OptionButton = $VBoxContainer/SubZonePropOptionButton
	
	set_sub_zone_prop(option_button.get_item_metadata(idx))
