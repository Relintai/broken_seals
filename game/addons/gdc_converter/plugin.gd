tool
extends EditorPlugin

func _enter_tree():
	add_tool_menu_item("Convert scripts", self, "on_menu_clicked")

func _exit_tree():
	remove_tool_menu_item("Convert scripts")

func on_menu_clicked(val) -> void:
	var GDSParser = load("res://addons/gdc_converter/gdsparser.gd")
	var parser = GDSParser.new()
	
	var dir = Directory.new()
	var dir_name = get_editor_interface().get_selected_path()
	if dir.open(dir_name) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			
			if !dir.current_is_dir():
				if file_name.get_extension() == "gd":
					parser.process_file(dir_name + file_name)
			
			file_name = dir.get_next()
