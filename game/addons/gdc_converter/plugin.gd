tool
extends EditorPlugin

func _enter_tree():
	add_tool_menu_item("Convert Scripts to Cpp", self, "on_convert_script_menu_clicked")
	add_tool_menu_item("Generate Cpp Class Bind for Scripts", self, "on_generate_class_binds_menu_clicked")
	add_tool_menu_item("Convert Scenes to Cpp", self, "on_convert_scene_menu_clicked")

func _exit_tree():
	remove_tool_menu_item("Convert Scripts to Cpp")
	remove_tool_menu_item("Generate Cpp Class Bind for Scripts")
	remove_tool_menu_item("Convert Scenes to Cpp")

func on_convert_script_menu_clicked(val) -> void:
	var GDSParser = load("res://addons/gdc_converter/gdc_code_converter.gd")
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

func on_generate_class_binds_menu_clicked(val) -> void:
	var GDSParser = load("res://addons/gdc_converter/gdc_class_bind_generator.gd")
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

func on_convert_scene_menu_clicked(val) -> void:
	var GDSParser = load("res://addons/gdc_converter/gdc_scene_converter.gd")
	var parser = GDSParser.new()
	
	var dir = Directory.new()
	var dir_name = get_editor_interface().get_selected_path()
	if dir.open(dir_name) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			
			if !dir.current_is_dir():
				if file_name.get_extension() == "tscn":
					parser.process_file(dir_name + file_name)
			
			file_name = dir.get_next()
