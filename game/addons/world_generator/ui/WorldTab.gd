tool
extends HBoxContainer

var edited_world

signal request_item_edit(world_gen_base_resource)

func _ready():
	var dl : Control = get_node("VBoxContainer/DataList")
	if !dl.is_connected("request_item_edit", self, "on_request_item_edit"):
		dl.connect("request_item_edit", self, "on_request_item_edit")

func set_plugin(plugin : EditorPlugin) -> void:
	$HSplitContainer/ResourcePropertyList.set_plugin(plugin)
	$HSplitContainer/RectEditor.set_plugin(plugin)
	$VBoxContainer/DataList.set_plugin(plugin)

func refresh() -> void:
	$HSplitContainer/ResourcePropertyList.edit_resource(edited_world)
	$VBoxContainer/DataList.set_edited_resource(edited_world)
	$HSplitContainer/RectEditor.set_edited_resource(edited_world)
	
func set_wgworld(wgw : WorldGenWorld) -> void:
	edited_world = wgw
	
	refresh()
	
func on_request_item_edit(resource : WorldGenBaseResource) -> void:
	emit_signal("request_item_edit", resource)
