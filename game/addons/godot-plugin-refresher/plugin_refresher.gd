tool
extends HBoxContainer

signal request_refresh_plugin(p_name)
signal confirm_refresh_plugin(p_name)

onready var options = $OptionButton

func _ready():
	$RefreshButton.icon = get_icon('Reload', 'EditorIcons')

func update_items(p_plugins):
	if not options:
		return
	options.clear()
	var plugin_dirs = p_plugins.keys()
	for idx in plugin_dirs.size():
		var plugin_dirname = plugin_dirs[idx]
		var plugin_name = p_plugins[plugin_dirname]
		options.add_item(plugin_name, idx)
		options.set_item_metadata(idx, plugin_dirname)

func select_plugin(p_name):
	if not options:
		return
	if p_name == null or p_name.empty():
		return

	for idx in options.get_item_count():
		var plugin = options.get_item_metadata(idx)
		if plugin == p_name:
			options.selected = options.get_item_id(idx)
			break

func _on_RefreshButton_pressed():
	if options.selected == -1:
		return # nothing selected

	var plugin = options.get_item_metadata(options.selected)
	if not plugin or plugin.empty():
		return
	emit_signal("request_refresh_plugin", plugin)

func show_warning(p_name):
	$ConfirmationDialog.dialog_text = """
		Plugin `%s` is currently disabled.\n
		Do you want to enable it now?
	""" % [p_name]
	$ConfirmationDialog.popup_centered()

func _on_ConfirmationDialog_confirmed():
	var plugin = options.get_item_metadata(options.selected)
	emit_signal('confirm_refresh_plugin', plugin)
